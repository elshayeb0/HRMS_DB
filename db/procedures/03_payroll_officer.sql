USE HRMS_DB;
GO

-- 1. GeneratePayroll: Return payroll runs within a specified date range.
CREATE PROCEDURE GeneratePayroll
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT
        payroll_id,
        employee_id,
        taxes,
        period_start,
        period_end,
        base_amount,
        adjustments,
        contributions,
        actual_pay,
        net_salary,
        payment_date
    FROM Payroll
    WHERE period_start >= @StartDate
      AND period_end <= @EndDate;
END;
GO

-- 2. AdjustPayrollItem: Add an allowance or deduction row for a payroll record.
CREATE PROCEDURE AdjustPayrollItem
    @PayrollID INT,
    @Type VARCHAR(50),
    @Amount DECIMAL(10,2),
    @duration INT,
    @timezone VARCHAR(20)
AS
BEGIN
    INSERT INTO AllowanceDeduction (payroll_id, employee_id, type, amount, currency, duration, timezone)
    SELECT payroll_id, employee_id, @Type, @Amount, 'EGP', @duration, @timezone
    FROM Payroll
    WHERE payroll_id = @PayrollID;

    PRINT 'Payroll item adjusted successfully';
END;
GO

-- 3. CalculateNetSalary: Compute net pay by aggregating payroll fields.
CREATE PROCEDURE CalculateNetSalary
    @PayrollID INT
AS
BEGIN
    SELECT
        ISNULL(base_amount,0) + ISNULL(adjustments,0) + ISNULL(contributions,0) - ISNULL(taxes,0)
        AS NetSalary
    FROM Payroll
    WHERE payroll_id = @PayrollID;
END;
GO

-- 4. ApplyPayrollPolicy: Link a policy to a payroll and update its metadata.
CREATE PROCEDURE ApplyPayrollPolicy
    @PolicyID INT,
    @PayrollID INT,
    @type VARCHAR(20),
    @description VARCHAR(50)
AS
BEGIN
    INSERT INTO PayrollPolicy_ID (payroll_id, policy_id)
    VALUES (@PayrollID, @PolicyID);

    UPDATE PayrollPolicy
    SET type = @type,
        description = @description
    WHERE policy_id = @PolicyID;

    PRINT 'Payroll policy applied successfully';
END;
GO

-- 5. GetMonthlyPayrollSummary: Sum net salary for a given month and year.
CREATE PROCEDURE GetMonthlyPayrollSummary
    @Month INT,
    @Year INT
AS
BEGIN
    SELECT
        SUM(ISNULL(net_salary,0)) AS TotalSalaryExpenditure
    FROM Payroll
    WHERE MONTH(period_end) = @Month
      AND YEAR(period_end) = @Year;
END;
GO

-- 6. AddAllowanceDeduction: Add a simple allowance/deduction for a payroll run.
CREATE PROCEDURE AddAllowanceDeduction
    @PayrollID INT,
    @Type VARCHAR(50),
    @Amount DECIMAL(10,2)
AS
BEGIN
    INSERT INTO AllowanceDeduction (payroll_id, employee_id, type, amount, currency, duration, timezone)
    SELECT payroll_id, employee_id, @Type, @Amount, 'EGP', 1, 'Local'
    FROM Payroll
    WHERE payroll_id = @PayrollID;

    PRINT 'Allowance/Deduction added successfully' ;
END;
GO

-- 7. GetEmployeePayrollHistory: List payroll records for one employee.
CREATE PROCEDURE GetEmployeePayrollHistory
    @EmployeeID INT
AS
BEGIN
    SELECT *
    FROM Payroll
    WHERE employee_id = @EmployeeID;
END;
GO

-- 8. GetBonusEligibleEmployees: List employees matching a bonus eligibility rule.
CREATE PROCEDURE GetBonusEligibleEmployees
    @Eligibility_criteria NVARCHAR(MAX)
AS
BEGIN
    SELECT DISTINCT e.employee_id, e.first_name, e.last_name
    FROM Employee e
    JOIN Payroll p ON e.employee_id = p.employee_id
    JOIN PayrollPolicy_ID pp ON p.payroll_id = pp.payroll_id
    JOIN BonusPolicy b ON pp.policy_id = b.policy_id
    WHERE b.eligibility_criteria = @Eligibility_criteria;
END;
GO

-- 9. UpdateSalaryType: Update the salary type reference for an employee.
CREATE PROCEDURE UpdateSalaryType
    @EmployeeID INT,
    @SalaryTypeID INT
AS
BEGIN
    UPDATE Employee
    SET salary_type_id = @SalaryTypeID
    WHERE employee_id = @EmployeeID;

    PRINT 'Salary type updated successfully' ;
END;
GO

-- 10. GetPayrollByDepartment: Aggregate payroll totals per department for a period.
CREATE PROCEDURE GetPayrollByDepartment
    @DepartmentID INT,
    @Month INT,
    @Year INT
AS
BEGIN
    SELECT
        d.department_id,
        d.department_name,
        SUM(ISNULL(p.net_salary,0)) AS TotalPayroll
    FROM Employee e
    JOIN Payroll p ON e.employee_id = p.employee_id
    JOIN Department d ON e.department_id = d.department_id
    WHERE e.department_id = @DepartmentID
      AND MONTH(p.period_end) = @Month
      AND YEAR(p.period_end) = @Year
    GROUP BY d.department_id, d.department_name;
END;
GO

-- 11. ValidateAttendanceBeforePayroll: Flag employees lacking exit times in a payroll period.
CREATE PROCEDURE ValidateAttendanceBeforePayroll
    @PayrollPeriodID INT
AS
BEGIN
    SELECT DISTINCT e.employee_id, e.first_name, e.last_name
    FROM Employee e
    JOIN PayrollPeriod pp ON e.employee_id = pp.payroll_id
    JOIN Attendance a ON e.employee_id = a.employee_id
    LEFT JOIN AttendanceLog al ON a.attendance_id = al.attendance_id
    WHERE pp.payroll_period_id = @PayrollPeriodID
      AND a.exit_time IS NULL;
END;
GO

-- 12. SyncAttendanceToPayroll: Create payroll stubs for attendance on a specific date.
CREATE PROCEDURE SyncAttendanceToPayroll
    @SyncDate DATE
AS
BEGIN

    INSERT INTO Payroll (employee_id, period_start, period_end, base_amount, adjustments, contributions, taxes, actual_pay, net_salary, payment_date)
    SELECT
        a.employee_id,
        CAST(@SyncDate AS DATE),
        CAST(@SyncDate AS DATE),
        0,
        0,
        0,
        0,
        0,
        0,
        GETDATE()
    FROM Attendance a
    WHERE CAST(a.entry_time AS DATE) = @SyncDate
      AND NOT EXISTS (
          SELECT 1 FROM Payroll p
          WHERE p.employee_id = a.employee_id
            AND p.period_start = CAST(@SyncDate AS DATE)
      );

    PRINT 'Attendance synced to payroll successfully' ;
END;
GO

-- 13. SyncApprovedPermissionsToPayroll: Add payroll entries for approved workflows in a period.
CREATE PROCEDURE SyncApprovedPermissionsToPayroll
    @PayrollPeriodID INT
AS
BEGIN
    INSERT INTO Payroll (employee_id, period_start, period_end, base_amount, adjustments, contributions, taxes, actual_pay, net_salary, payment_date)
    SELECT
        e.employee_id,
        pp.start_date,
        pp.end_date,
        0,
        0,
        0,
        0,
        0,
        0,
        GETDATE()
    FROM Employee e
    JOIN PayrollPeriod pp ON pp.payroll_id = e.employee_id
    JOIN ApprovalWorkflow aw ON aw.workflow_id = pp.payroll_id
    WHERE aw.status = 'Approved'
      AND pp.payroll_period_id = @PayrollPeriodID;

    PRINT  'Approved permissions synced to payroll successfully' ;
END;
GO

-- 14. ConfigurePayGrades: Insert a pay grade with salary bounds.
CREATE PROCEDURE ConfigurePayGrades
    @GradeName VARCHAR(60),
    @MinSalary DECIMAL(11,3),
    @MaxSalary DECIMAL(11,3)
AS
BEGIN
    INSERT INTO PayGrade (grade_name, min_salary, max_salary)
    VALUES (@GradeName, @MinSalary, @MaxSalary);

    PRINT 'Pay grade configured successfully' ;
END;
GO

-- 15. ConfigureShiftAllowances: Add allowance rows for employees on a shift type.
CREATE PROCEDURE ConfigureShiftAllowances
    @ShiftType VARCHAR(50),
    @AllowanceName VARCHAR(50),
    @Amount DECIMAL(10,2)
AS
BEGIN
    INSERT INTO AllowanceDeduction (employee_id, type, amount, currency, duration, timezone)
    SELECT e.employee_id, @AllowanceName, @Amount, 'EGP', 1, 'Local'
    FROM Employee e
    JOIN ShiftSchedule s ON s.type = @ShiftType

    PRINT  'Shift allowance configured successfully' ;
END;
GO

-- 16. EnableMultiCurrencyPayroll: Register a currency with its exchange rate.
CREATE PROCEDURE EnableMultiCurrencyPayroll
    @CurrencyCode VARCHAR(10),
    @ExchangeRate DECIMAL(10,4)
AS
BEGIN
    INSERT INTO Currency (CurrencyCode, CurrencyName, ExchangeRate)
    VALUES (@CurrencyCode, @CurrencyCode, @ExchangeRate);

    PRINT 'Currency added successfully' ;
END;
GO

-- 17. ManageTaxRules: Record tax rule details in the tax form catalog.
CREATE PROCEDURE ManageTaxRules
    @TaxRuleName VARCHAR(50),
    @CountryCode VARCHAR(10),
    @Rate DECIMAL(5,2),
    @Exemption DECIMAL(10,2)
AS
BEGIN
    INSERT INTO TaxForm (jurisdiction, form_content)
    VALUES (@CountryCode, 'TaxRule: ' + @TaxRuleName + ', Rate: ' + CAST(@Rate AS VARCHAR(10)) + ', Exemption: ' + CAST(@Exemption AS VARCHAR(10)));

    PRINT  'Tax rule added/updated successfully' ;
END;
GO

-- 18. ApprovePayrollConfigChanges: Log approval/rejection for a payroll config item.
CREATE PROCEDURE ApprovePayrollConfigChanges
    @ConfigID INT,
    @ApproverID INT,
    @Status VARCHAR(20)
AS
BEGIN
    INSERT INTO Payroll_Log (payroll_id, actor, change_date, modification_type)
    VALUES (@ConfigID, @ApproverID, GETDATE(), 'Configuration ' + @Status);

    PRINT  'Payroll configuration change ' + @Status + ' successfully'  ;
END;
GO

-- 19. ConfigureSigningBonus: Add a signing bonus allowance for an employee.
CREATE PROCEDURE ConfigureSigningBonus
    @EmployeeID INT,
    @BonusAmount DECIMAL(10,2),
    @EffectiveDate DATE
AS
BEGIN
    INSERT INTO AllowanceDeduction (payroll_id, employee_id, type, amount, currency, duration, timezone)
    SELECT payroll_id, @EmployeeID, 'Signing Bonus', @BonusAmount, 'EGP', 1, 'Local'
    FROM Payroll
    WHERE employee_id = @EmployeeID;

    PRINT  'Signing bonus configured successfully'  ;
END;
GO

-- 20. ConfigureTerminationBenefits: Add termination or resignation compensation entries.
CREATE PROCEDURE ConfigureTerminationBenefits
    @EmployeeID INT,
    @CompensationAmount DECIMAL(10,2),
    @EffectiveDate DATE,
    @Reason VARCHAR(50)
AS
BEGIN
    INSERT INTO AllowanceDeduction (payroll_id, employee_id, type, amount, currency, duration, timezone)
    SELECT payroll_id, @EmployeeID, CONCAT('Termination - ', @Reason), @CompensationAmount, 'EGP', 1, 'Local'
    FROM Payroll
    WHERE employee_id = @EmployeeID;

    PRINT  'Termination/resignation compensation configured successfully'  ;
END;
GO

-- 21. ConfigureInsuranceBrackets: Insert a new insurance bracket with contributions.
CREATE PROCEDURE ConfigureInsuranceBrackets
    @InsuranceType VARCHAR(50),
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2),
    @EmployeeContribution DECIMAL(5,2),
    @EmployerContribution DECIMAL(5,2)
AS
BEGIN
    INSERT INTO Insurance (type, contribution_rate, coverage)
    VALUES (
        @InsuranceType,
        @EmployeeContribution + @EmployerContribution,
        'Salary bracket'
    );

    PRINT  'Insurance bracket configured successfully'  ;
END;
GO

-- 22. UpdateInsuranceBracketss: Update an existing insurance bracket's values.
CREATE PROCEDURE UpdateInsuranceBracketss
    @BracketID INT,
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2),
    @EmployeeContribution DECIMAL(5,2),
    @EmployerContribution DECIMAL(5,2)
AS
BEGIN
    UPDATE Insurance
    SET
        contribution_rate = @EmployeeContribution + @EmployerContribution,
        coverage = 'Salary bracket'
    WHERE insurance_id = @BracketID;

    PRINT  'Insurance bracket updated successfully'  ;
END;
GO

-- 23. ConfigurePayrollPolicies: Insert a payroll policy with type, details, and effective date.
CREATE PROCEDURE ConfigurePayrollPolicies
    @PolicyType VARCHAR(50),
    @PolicyDetails NVARCHAR(MAX),
    @EffectiveDate DATE
AS
BEGIN
    INSERT INTO PayrollPolicy (type, description, effective_date)
    VALUES (@PolicyType, @PolicyDetails, @EffectiveDate);

    PRINT  'Payroll policy configured successfully'  ;
END;
GO

-- 24. DefinePayGrades: Insert a pay grade with created-by context.
CREATE PROCEDURE DefinePayGrades
    @GradeName VARCHAR(50),
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2),
    @CreatedBy INT
AS
BEGIN
    INSERT INTO PayGrade (grade_name, min_salary, max_salary)
    VALUES (@GradeName, @MinSalary, @MaxSalary);

    PRINT 'Pay grade defined successfully';
END;
GO

-- 25. ConfigureEscalationWorkflow: Create an approval workflow for payroll escalation thresholds.
CREATE PROCEDURE ConfigureEscalationWorkflow
    @ThresholdAmount DECIMAL(11,2),
    @ApproverRole VARCHAR(60),
    @CreatedBy INT
AS
BEGIN
    INSERT INTO ApprovalWorkflow (workflow_type, threshold_amount, approver_role, created_by, status)
    VALUES ('Payroll Escalation', @ThresholdAmount, @ApproverRole, @CreatedBy, 'Active');

    PRINT  'Escalation workflow configured successfully.'  ;
END;
GO

-- 26. DefinePayType: Set an employee's salary type by name.
CREATE PROCEDURE DefinePayType
    @EmployeeID INT,
    @PayType VARCHAR(50),
    @EffectiveDate DATE
AS
BEGIN
    UPDATE Employee
    SET salary_type_id = (
        SELECT salary_type_id
        FROM SalaryType
        WHERE type = @PayType
    )
    WHERE employee_id = @EmployeeID;

    PRINT  'Pay type assigned successfully.'  ;
END;
GO

-- 27. ConfigureOvertimeRules: Update overtime multipliers and hour caps.
CREATE PROCEDURE ConfigureOvertimeRules
    @DayType VARCHAR(20),
    @Multiplier DECIMAL(3,2),
    @hourspermonth INT
AS
BEGIN
    UPDATE OvertimePolicy
    SET weekday_rate_multiplier = @Multiplier
    WHERE @DayType = 'Weekday';

    UPDATE OvertimePolicy
    SET weekend_rate_multiplier = @Multiplier
    WHERE @DayType = 'Weekend';

    UPDATE OvertimePolicy
    SET max_hours_per_month = @hourspermonth;

    PRINT  'Overtime rules configured successfully.'  ;
END;
GO

-- 28. ConfigureShiftAllowance: Update allowance amounts for a given shift type.
GO
CREATE PROCEDURE ConfigureShiftAllowance
    @ShiftType VARCHAR(20),
    @AllowanceAmount DECIMAL(10,2),
    @CreatedBy INT
AS
BEGIN
    UPDATE ShiftSchedule
    SET allowance_amount = @AllowanceAmount
    WHERE type = @ShiftType;

    PRINT  'Shift allowance configured successfully.'  ;
END;
GO


-- 29. ConfigureSigningBonusPolicy: Add a signing bonus policy definition.
GO
CREATE PROCEDURE ConfigureSigningBonusPolicy
    @BonusType VARCHAR(50),
    @Amount DECIMAL(10,2),
    @EligibilityCriteria NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO BonusPolicy (bonus_type, amount, eligibility_criteria)
    VALUES (@BonusType, @Amount, @EligibilityCriteria);

    PRINT  'Signing bonus policy configured successfully.'  ;
END;
GO

-- 32. GenerateTaxStatement: Summarize taxable pay and withholding for a year.
CREATE PROCEDURE GenerateTaxStatement
    @EmployeeID INT,
    @TaxYear INT
AS
BEGIN
    SELECT
        e.employee_id,
        e.full_name,
        tf.jurisdiction AS tax_jurisdiction,
        SUM(p.base_amount) AS total_base_salary,
        SUM(p.taxes) AS total_taxes,
        SUM(p.contributions) AS total_contributions,
        SUM(p.net_salary) AS total_net_salary
    FROM Payroll p
    INNER JOIN Employee e ON p.employee_id = e.employee_id
    LEFT JOIN TaxForm tf ON e.tax_form_id = tf.tax_form_id
    WHERE p.employee_id = @EmployeeID
      AND YEAR(p.period_start) = @TaxYear
    GROUP BY e.employee_id, e.full_name, tf.jurisdiction;
END;
GO

-- 33. ApprovePayrollConfiguration: Mark a payroll configuration log as approved.
CREATE PROCEDURE ApprovePayrollConfiguration
    @ConfigID INT,
    @ApprovedBy INT
AS
BEGIN
    UPDATE Payroll_Log
    SET actor = @ApprovedBy,
        change_date = GETDATE(),
        modification_type = 'Approved'
    WHERE payroll_id = @ConfigID;

    PRINT  'Payroll configuration approved successfully.'  ;
END;
GO

-- 34. ModifyPastPayroll: Adjust historical payroll fields and log the change.
CREATE PROCEDURE ModifyPastPayroll
    @PayrollRunID INT,
    @EmployeeID INT,
    @FieldName VARCHAR(50),
    @NewValue DECIMAL(10,2),
    @ModifiedBy INT
AS
BEGIN
    IF @FieldName = 'adjustments'
        UPDATE Payroll
        SET adjustments = @NewValue
        WHERE payroll_id = @PayrollRunID
          AND employee_id = @EmployeeID;

    IF @FieldName = 'contributions'
        UPDATE Payroll
        SET contributions = @NewValue
        WHERE payroll_id = @PayrollRunID
          AND employee_id = @EmployeeID;

    IF @FieldName = 'net_salary'
        UPDATE Payroll
        SET net_salary = @NewValue
        WHERE payroll_id = @PayrollRunID
          AND employee_id = @EmployeeID;

    INSERT INTO Payroll_Log (payroll_id, actor, change_date, modification_type)
    VALUES (@PayrollRunID, @ModifiedBy, GETDATE(), 'Modified ' + @FieldName);

    PRINT  'Payroll entry updated successfully.'  ;
END;
