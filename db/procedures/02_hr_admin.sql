USE HRMS_DB;
GO


-- 1:
CREATE PROCEDURE CreateContract
    @EmployeeID INT,
    @Type VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN

    SET NOCOUNT ON;

    -- Insert new contract
    INSERT INTO Contract (type, start_date, end_date, current_state)
    VALUES (@Type, @StartDate, @EndDate, 'Active');

    -- Link contract to employee
    UPDATE Employee
    SET contract_id = SCOPE_IDENTITY()
    WHERE employee_id = @EmployeeID;

    SELECT 'Contract created successfully for Employee ID: ' + CAST(@EmployeeID AS VARCHAR) +
       '. Contract ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR) AS Message;

END;
GO

-- 2:
CREATE PROCEDURE RenewContract
    @ContractID INT,
    @NewEndDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Contract
    SET end_date = @NewEndDate
    WHERE contract_id = @ContractID;

    SELECT 'Contract ID ' + CAST(@ContractID AS VARCHAR) +
       ' renewed successfully until ' + CAST(@NewEndDate AS VARCHAR) AS Message;

END;
GO

-- 3:

CREATE PROCEDURE ApproveLeaveRequest
    @LeaveRequestID INT,
    @ApproverID INT,
    @Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE LeaveRequest
    SET status = @Status
    WHERE request_id = @LeaveRequestID;

    SELECT 'Leave request ID ' + CAST(@LeaveRequestID AS VARCHAR) +
       ' has been ' + @Status + ' by approver ID ' + CAST(@ApproverID AS VARCHAR) AS Message;

END;
GO

-- 4:

CREATE PROCEDURE AssignMission
    @EmployeeID INT,
    @ManagerID INT,
    @Destination VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Mission (employee_id, manager_id, destination, start_date, end_date, status)
    VALUES (@EmployeeID, @ManagerID, @Destination, @StartDate, @EndDate, 'Assigned');

    SELECT 'Mission assigned successfully to Employee ID: ' + CAST(@EmployeeID AS VARCHAR) +
       ' for destination: ' + @Destination +
       ' (Mission ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR) + ')' AS Message;

END;
GO

-- 5:

CREATE PROCEDURE ReviewReimbursement
    @ClaimID INT,
    @ApproverID INT,
    @Decision VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Reimbursement
    SET current_status = @Decision
    WHERE reimbursement_id = @ClaimID;

    SELECT 'Reimbursement claim ID ' + CAST(@ClaimID AS VARCHAR) +
       ' has been ' + @Decision + ' by approver ID ' + CAST(@ApproverID AS VARCHAR) AS Message;

END;
GO

--6:

CREATE PROCEDURE GetActiveContracts
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.contract_id,
        e.employee_id,
        e.full_name AS employee_name,
        c.type AS contract_type,
        c.start_date,
        c.end_date,
        c.current_state AS status
    FROM Contract c
    INNER JOIN Employee e
        ON e.contract_id = c.contract_id
    WHERE c.current_state = 'Active'
    ORDER BY c.end_date;
END;
GO

-- 7:

CREATE PROCEDURE GetTeamByManager
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        employee_id,
        full_name AS employee_name
    FROM Employee
    WHERE manager_id = @ManagerID
    ORDER BY full_name;
END;
GO


-- 8:

CREATE PROCEDURE UpdateLeavePolicy
    @PolicyID INT,
    @EligibilityRules VARCHAR(200),
    @NoticePeriod INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE LeavePolicy
    SET eligibility_rules = @EligibilityRules,
        notice_period = @NoticePeriod
    WHERE policy_id = @PolicyID;

    SELECT 'Leave policy ID ' + CAST(@PolicyID AS VARCHAR) + ' updated successfully.' AS Message;

END;
GO

 -- 9:
CREATE PROCEDURE GetExpiringContracts
    @DaysBefore INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        contract_id,
        type,
        start_date,
        end_date,
        current_state
    FROM Contract
    WHERE current_state = 'Active'
      AND end_date <= DATEADD(DAY, @DaysBefore, GETDATE())
    ORDER BY end_date;
END;
GO


-- 10:
CREATE PROCEDURE AssignDepartmentHead
    @DepartmentID INT,
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Department
    SET department_head_id = @ManagerID
    WHERE department_id = @DepartmentID;

    SELECT 'Manager ID ' + CAST(@ManagerID AS VARCHAR) +
       ' assigned as head of Department ID ' + CAST(@DepartmentID AS VARCHAR) AS Message;

END;
GO

-- 11:
CREATE PROCEDURE CreateEmployeeProfile
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DepartmentID INT,
    @RoleID INT,
    @HireDate DATE,
    @Email VARCHAR(100),
    @Phone VARCHAR(20),
    @NationalID VARCHAR(50),
    @DateOfBirth DATE,
    @CountryOfBirth VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert new employee
    INSERT INTO Employee (
        first_name, last_name, full_name, department_id, hire_date, email, phone, national_id, date_of_birth, country_of_birth,
        is_active, employment_status, account_status
    )
    VALUES (
        @FirstName, @LastName, @FirstName + ' ' + @LastName, @DepartmentID, @HireDate, @Email, @Phone, @NationalID, @DateOfBirth, @CountryOfBirth,
        1, 'Active', 'Active'
    );

    -- Retrieve the employee_id using email (unique)
    DECLARE @NewEmployeeID INT;
    SELECT @NewEmployeeID = employee_id FROM Employee WHERE email = @Email;

    -- Assign role
    INSERT INTO Employee_Role (employee_id, role_id)
    VALUES (@NewEmployeeID, @RoleID);

    -- Confirmation message
    SELECT 'Employee profile created successfully. New Employee ID: ' + CAST(@NewEmployeeID AS VARCHAR) AS Message;
END;
GO


-- 12:  check again
CREATE PROCEDURE UpdateEmployeeProfile
    @EmployeeID INT,
    @FieldName VARCHAR(50),
    @NewValue VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the column based on @FieldName
    IF @FieldName = 'first_name'
        UPDATE Employee SET first_name = @NewValue WHERE employee_id = @EmployeeID;

    ELSE IF @FieldName = 'last_name'
        UPDATE Employee SET last_name = @NewValue WHERE employee_id = @EmployeeID;

    ELSE IF @FieldName = 'email'
        UPDATE Employee SET email = @NewValue WHERE employee_id = @EmployeeID;

    ELSE IF @FieldName = 'phone'
        UPDATE Employee SET phone = @NewValue WHERE employee_id = @EmployeeID;

    ELSE IF @FieldName = 'address'
        UPDATE Employee SET address = @NewValue WHERE employee_id = @EmployeeID;

    ELSE IF @FieldName = 'employment_status'
        UPDATE Employee SET employment_status = @NewValue WHERE employee_id = @EmployeeID;

    ELSE IF @FieldName = 'account_status'
        UPDATE Employee SET account_status = @NewValue WHERE employee_id = @EmployeeID;

    ELSE IF @FieldName = 'department_id'
        UPDATE Employee SET department_id = CAST(@NewValue AS INT) WHERE employee_id = @EmployeeID;

    ELSE IF @FieldName = 'position_id'
        UPDATE Employee SET position_id = CAST(@NewValue AS INT) WHERE employee_id = @EmployeeID;

    ELSE IF @FieldName = 'full_name'
        UPDATE Employee SET full_name = @NewValue WHERE employee_id = @EmployeeID;

    SELECT 'Employee ID ' + CAST(@EmployeeID AS VARCHAR) + ' updated successfully.' AS Message;
END;
GO



--13:

CREATE PROCEDURE SetProfileCompleteness
    @EmployeeID INT,
    @CompletenessPercentage INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Employee
    SET profile_completion = @CompletenessPercentage
    WHERE employee_id = @EmployeeID;

    SELECT 'Profile completeness updated to ' + CAST(@CompletenessPercentage AS VARCHAR) +
           '% for Employee ID: ' + CAST(@EmployeeID AS VARCHAR) AS Message;
END;
GO


--14:
CREATE PROCEDURE GenerateProfileReport
    @FilterField VARCHAR(50),
    @FilterValue VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT employee_id, full_name, department_id, position_id, hire_date, email, phone
    FROM Employee
    WHERE
        (@FilterField = 'department_id' AND CAST(department_id AS VARCHAR) = @FilterValue)
        OR (@FilterField = 'position_id' AND CAST(position_id AS VARCHAR) = @FilterValue)
        OR (@FilterField = 'employment_status' AND employment_status = @FilterValue);
END;
GO

--15:
CREATE PROCEDURE CreateShiftType
    @ShiftID INT,
    @Name VARCHAR(100),
    @Type VARCHAR(50),
    @Start_Time TIME,
    @End_Time TIME,
    @Break_Duration INT,
    @Shift_Date DATE,
    @Status VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO ShiftSchedule (name, type, start_time, end_time, break_duration, shift_date, status)
    VALUES (@Name, @Type, @Start_Time, @End_Time, @Break_Duration, @Shift_Date, @Status);

    SELECT 'Shift type "' + @Name + '" (Logical ID: ' + CAST(@ShiftID AS VARCHAR(10)) +
           ') created successfully.' AS Message;
END;
GO


--17:
CREATE PROCEDURE AssignRotationalShift
    @EmployeeID INT,
    @ShiftCycle INT,
    @StartDate DATE,
    @EndDate DATE,
    @Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- Assign the employee to the shift cycle
    INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status)
    VALUES (@EmployeeID, @ShiftCycle, @StartDate, @EndDate, @Status);

    SELECT 'Employee ID ' + CAST(@EmployeeID AS VARCHAR) +
           ' assigned to shift cycle ' + CAST(@ShiftCycle AS VARCHAR) +
           ' from ' + CAST(@StartDate AS VARCHAR) +
           ' to ' + CAST(@EndDate AS VARCHAR) +
           ' with status: ' + @Status AS Message;
END;
GO


--18:

CREATE PROCEDURE NotifyShiftExpiry
    @EmployeeID INT,
    @ShiftAssignmentID INT,
    @ExpiryDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NotificationID INT;

    -- Insert notification and capture the generated ID
    INSERT INTO Notification (message_content, urgency, notification_type)
    VALUES (
        'Shift Assignment ID ' + CAST(@ShiftAssignmentID AS VARCHAR) +
        ' for Employee ID ' + CAST(@EmployeeID AS VARCHAR) +
        ' is nearing expiry on ' + CAST(@ExpiryDate AS VARCHAR),
        'High',
        'ShiftExpiry'
    );

    -- Capture the ID of the inserted notification
    SET @NotificationID = (SELECT MAX(notification_id) FROM Notification);

    -- Link notification to employee
    INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status)
    VALUES (
        @EmployeeID,
        @NotificationID,
        'Pending'
    );

    SELECT 'Notification created for Employee ID ' + CAST(@EmployeeID AS VARCHAR) +
           ' for Shift Assignment ID ' + CAST(@ShiftAssignmentID AS VARCHAR) AS Message;
END;
GO


--19:
CREATE PROCEDURE DefineShortTimeRules
    @RuleName VARCHAR(50),
    @LateMinutes INT,
    @EarlyLeaveMinutes INT,
    @PenaltyType VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PolicyID INT;

    -- Insert a new payroll policy first
    INSERT INTO PayrollPolicy (effective_date, type, description)
    VALUES (NULL, 'Lateness', 'Short time rule: ' + @RuleName + ', Penalty: ' + @PenaltyType);

    -- Capture the inserted policy_id using OUTPUT clause
    SET @PolicyID = (SELECT MAX(policy_id) FROM PayrollPolicy);

    -- Insert corresponding lateness rule
    INSERT INTO LatenessPolicy (policy_id, grace_period_mins, deduction_rate)
    VALUES (@PolicyID, @LateMinutes, @EarlyLeaveMinutes);

    -- Confirmation message
    SELECT 'Short time rule "' + @RuleName + '" with penalty type "' + @PenaltyType + '" applied successfully.' AS Message;
END;
GO


--20:
CREATE PROCEDURE SetGracePeriod
    @Minutes INT
AS
BEGIN
    UPDATE LatenessPolicy
    SET grace_period_mins = @Minutes;

    SELECT 'Grace period of ' + CAST(@Minutes AS VARCHAR(5)) + ' minutes set successfully.' AS Message;
END
GO

--21:
CREATE PROCEDURE DefinePenaltyThreshold
    @LateMinutes INT,
    @DeductionType VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert a new PayrollPolicy
    DECLARE @PolicyID INT;

    INSERT INTO PayrollPolicy (effective_date, type, description)
    VALUES (NULL, 'LatenessPenalty', 'Late > ' + CAST(@LateMinutes AS VARCHAR(5)) + ' minutes triggers ' + @DeductionType);

    SET @PolicyID = SCOPE_IDENTITY();

    -- Insert corresponding DeductionPolicy
    INSERT INTO DeductionPolicy (policy_id, deduction_reason, calculation_mode)
    VALUES (@PolicyID, 'Late by ' + CAST(@LateMinutes AS VARCHAR(5)) + ' mins', @DeductionType);

    SELECT 'Penalty threshold for ' + CAST(@LateMinutes AS VARCHAR(5)) +
           ' late minutes set successfully.' AS Message;
END;
GO

--22:

CREATE PROCEDURE DefinePermissionLimits
    @MinHours INT,
    @MaxHours INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Only update approval_limit (max hours)
    UPDATE LineManager
    SET approval_limit = @MaxHours;

    SELECT 'Permission limits set successfully. Max hours: ' + CAST(@MaxHours AS VARCHAR) AS Message;
END;
GO



-- 23: Escalate pending leave requests
CREATE PROCEDURE EscalatePendingRequests
    @Deadline DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Mark pending requests as escalated
    UPDATE LeaveRequest
    SET status = 'Escalated'
    WHERE status = 'Pending'
      AND approval_timing <= @Deadline;

    -- Confirmation message
    SELECT 'Pending requests escalated as of ' + CAST(@Deadline AS VARCHAR(30)) AS Message;
END;
GO




--24:
CREATE PROCEDURE LinkVacationToShift
    @VacationLeaveID INT,
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Link vacation leave to the employee by creating a LeaveRequest
    INSERT INTO LeaveRequest (employee_id, leave_id, justification, duration, status)
    VALUES (@EmployeeID, @VacationLeaveID, 'Vacation linked to shift schedule', 0, 'Approved');

    -- Confirmation message
    SELECT 'VacationLeave ID ' + CAST(@VacationLeaveID AS VARCHAR) +
           ' linked to Employee ID ' + CAST(@EmployeeID AS VARCHAR) AS Message;
END;
GO




--25:
CREATE PROCEDURE ConfigureLeavePolicies
AS
BEGIN
    INSERT INTO LeavePolicy (name, purpose, eligibility_rules, notice_period, special_leave_type, reset_on_new_year)
    SELECT 'Default Policy', 'Initial leave configuration', 'All employees eligible', 7, NULL, 1
    WHERE NOT EXISTS (SELECT * FROM LeavePolicy WHERE name = 'Default Policy');

    SELECT 'Leave policies configured successfully.' AS Message;
END
GO

--26:
CREATE PROCEDURE AuthenticateLeaveAdmin
    @AdminID INT,
    @Password VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT * FROM HRAdministrator WHERE employee_id = @AdminID AND document_validation_rights = @Password)
        SELECT 'Authentication successful.' AS Message;
    ELSE
        SELECT 'Authentication failed.' AS Message;
END;
GO

--27:
CREATE PROCEDURE ApplyLeaveConfiguration
AS
BEGIN
    -- Example: apply default leave policy to all employees who don't have one
    INSERT INTO LeaveEntitlement (employee_id, leave_type_id, entitlement)
    SELECT E.employee_id, L.leave_id, 0
    FROM Employee E, Leave L
    WHERE NOT EXISTS (
        SELECT * FROM LeaveEntitlement LE
        WHERE LE.employee_id = E.employee_id AND LE.leave_type_id = L.leave_id
    );

    SELECT 'Leave configuration applied successfully.' AS Message;
END;
GO

--28:

CREATE PROCEDURE UpdateLeaveEntitlements
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE LE
    SET LE.entitlement = LE.entitlement + LP.notice_period
    FROM LeaveEntitlement LE
    INNER JOIN Leave L ON LE.leave_type_id = L.leave_id
    INNER JOIN LeavePolicy LP ON LP.name = 'Default Policy'
    WHERE LE.employee_id = @EmployeeID;

    SELECT 'Leave entitlements updated successfully.' AS Message;
END;
GO


--29:

CREATE PROCEDURE ConfigureLeaveEligibility
    @LeaveType VARCHAR(50),
    @MinTenure INT,
    @EmployeeType VARCHAR(50)
AS
BEGIN
    -- Update eligibility rules in LeavePolicy for the given leave type
    UPDATE LeavePolicy
    SET eligibility_rules = 'MinTenure: ' + CAST(@MinTenure AS VARCHAR) + ', EmployeeType: ' + @EmployeeType
    WHERE special_leave_type = @LeaveType;

    SELECT 'Leave eligibility configured successfully.' AS Message;
END;
GO

--30:
CREATE PROCEDURE ManageLeaveTypes
    @LeaveType VARCHAR(50),
    @Description VARCHAR(200)
AS
BEGIN
    -- Check if leave type exists
    IF EXISTS (SELECT * FROM Leave WHERE leave_type = @LeaveType)
        -- If exists, update the description
        UPDATE Leave SET leave_description = @Description WHERE leave_type = @LeaveType;
    ELSE
        -- If not, insert new leave type
        INSERT INTO Leave (leave_type, leave_description) VALUES (@LeaveType, @Description);

    SELECT 'Leave type managed successfully.' AS Message;
END;
GO

--31:

CREATE PROCEDURE AssignLeaveEntitlement
    @EmployeeID INT,
    @LeaveType VARCHAR(50),
    @Entitlement DECIMAL(5,2)
AS
BEGIN
    -- Assign entitlement for the employee and leave type
    IF EXISTS (SELECT * FROM LeaveEntitlement LE, Leave L WHERE LE.leave_type_id = L.leave_id AND L.leave_type = @LeaveType AND LE.employee_id = @EmployeeID)
        UPDATE LeaveEntitlement
        SET entitlement = @Entitlement
        WHERE employee_id = @EmployeeID AND leave_type_id = (SELECT leave_id FROM Leave WHERE leave_type = @LeaveType);
    ELSE
        INSERT INTO LeaveEntitlement (employee_id, leave_type_id, entitlement)
        VALUES (@EmployeeID, (SELECT leave_id FROM Leave WHERE leave_type = @LeaveType), @Entitlement);

    SELECT 'Leave entitlement assigned successfully.' AS Message;
END;
GO

--32:
CREATE PROCEDURE ConfigureLeaveRules
    @LeaveType VARCHAR(50),
    @MaxDuration INT,
    @NoticePeriod INT,
    @WorkflowType VARCHAR(50)
AS
BEGIN
    -- Update if the leave policy exists
    UPDATE LeavePolicy
    SET eligibility_rules = 'Max Duration: ' + CAST(@MaxDuration AS VARCHAR(10)) + ', Notice Period: ' + CAST(@NoticePeriod AS VARCHAR(10)),
        notice_period = @NoticePeriod
    WHERE name = @LeaveType;

    -- Insert if it does not exist
    INSERT INTO LeavePolicy (name, eligibility_rules, notice_period)
    SELECT @LeaveType, 'Max Duration: ' + CAST(@MaxDuration AS VARCHAR(10)) + ', Notice Period: ' + CAST(@NoticePeriod AS VARCHAR(10)), @NoticePeriod
    WHERE NOT EXISTS (SELECT * FROM LeavePolicy WHERE name = @LeaveType);

    -- Insert workflow if it does not exist
    INSERT INTO ApprovalWorkflow (workflow_type, status)
    SELECT @WorkflowType, 'Active'
    WHERE NOT EXISTS (SELECT * FROM ApprovalWorkflow WHERE workflow_type = @WorkflowType);

    SELECT 'Leave rules configured successfully.' AS Message;
END;
GO

--33:

CREATE PROCEDURE ConfigureSpecialLeave
    @LeaveType VARCHAR(50),
    @Rules VARCHAR(200)
AS
BEGIN
    -- Update if the leave type already exists
    UPDATE LeavePolicy
    SET eligibility_rules = @Rules
    WHERE name = @LeaveType;

    -- Insert if the leave type does not exist
    INSERT INTO LeavePolicy (name, eligibility_rules)
    SELECT @LeaveType, @Rules
    WHERE NOT EXISTS (SELECT * FROM LeavePolicy WHERE name = @LeaveType);

    SELECT 'Special leave configured successfully.' AS Message;
END;
GO

--34:
CREATE PROCEDURE SetLeaveYearRules
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    -- Update the leave year if it already exists
    UPDATE LeavePolicy
    SET eligibility_rules = 'Leave year from ' + CAST(@StartDate AS VARCHAR) + ' to ' + CAST(@EndDate AS VARCHAR)
    WHERE name = 'Leave Year';

    -- Insert leave year if it does not exist
    INSERT INTO LeavePolicy (name, eligibility_rules)
    SELECT 'Leave Year', 'Leave year from ' + CAST(@StartDate AS VARCHAR) + ' to ' + CAST(@EndDate AS VARCHAR)
    WHERE NOT EXISTS (SELECT * FROM LeavePolicy WHERE name = 'Leave Year');

    SELECT 'Leave year rules set successfully.' AS Message;
END;
GO


--35:
CREATE PROCEDURE AdjustLeaveBalance
    @EmployeeID INT,
    @LeaveType VARCHAR(50),
    @Adjustment DECIMAL(5,2)
AS
BEGIN
    -- Update the entitlement by adding the adjustment
    UPDATE LeaveEntitlement
    SET entitlement = entitlement + @Adjustment
    WHERE employee_id = @EmployeeID
      AND leave_type_id = (SELECT leave_id FROM Leave WHERE leave_type = @LeaveType);

    SELECT 'Leave balance adjusted successfully.' AS Message;
END;
GO

    --36:
   CREATE PROCEDURE ManageLeaveRoles
    @RoleID INT,
    @Permission VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the permission if it already exists
    UPDATE RolePermission
    SET allowed_action = @Permission
    WHERE role_id = @RoleID
      AND permission_name = @Permission;

    -- Insert the permission if it does not exist
    INSERT INTO RolePermission (role_id, permission_name, allowed_action)
    SELECT @RoleID, @Permission, @Permission
    WHERE NOT EXISTS (
        SELECT *
        FROM RolePermission
        WHERE role_id = @RoleID
          AND permission_name = @Permission
    );

    SELECT 'Leave role permission updated successfully.' AS Message;
END;
GO


 --37:
 CREATE PROCEDURE FinalizeLeaveRequest
    @LeaveRequestID INT
AS
BEGIN
    -- Update the status of the leave request to 'Finalized'
    UPDATE LeaveRequest
    SET status = 'Finalized'
    WHERE request_id = @LeaveRequestID AND status = 'Approved';

    -- Return confirmation message
    SELECT 'Leave request finalized successfully.' AS Message;
END;
GO

--38:
CREATE PROCEDURE OverrideLeaveDecision
    @LeaveRequestID INT,
    @Reason VARCHAR(200)
AS
BEGIN
    -- Update the leave request status to 'Overridden'
    UPDATE LeaveRequest
    SET status = 'Overridden', justification = @Reason
    WHERE request_id = @LeaveRequestID;

    -- Return confirmation message
    SELECT 'Leave decision overridden successfully.' AS Message;
END;
GO

--39: couldnt be used without CHARINDEX
CREATE PROCEDURE BulkProcessLeaveRequests
    @LeaveRequestIDs VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update all leave requests whose IDs are in the comma-separated string
    UPDATE LeaveRequest
    SET status = 'Processed'
    WHERE request_id IN (
        SELECT CAST(value AS INT)
        FROM STRING_SPLIT(@LeaveRequestIDs, ',')
    );

    -- Return confirmation message
    SELECT 'Leave requests processed successfully.' AS Message;
END;
GO


 --40:
CREATE PROCEDURE VerifyMedicalLeave
    @LeaveRequestID INT,
    @DocumentID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if document exists
    IF EXISTS (
        SELECT 1 FROM LeaveDocument
        WHERE document_id = @DocumentID
        AND leave_request_id = @LeaveRequestID
    )
    BEGIN
        -- Update leave request status to indicate verification
        UPDATE LeaveRequest
        SET status = 'Verified'
        WHERE request_id = @LeaveRequestID
        AND status = 'Pending';

        SELECT 'Medical leave document verified successfully.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 'Document not found for this leave request.' AS Message;
    END
END;
GO

--41:

CREATE PROCEDURE SyncLeaveBalances
    @LeaveRequestID INT
AS
BEGIN
    UPDATE LE
    SET LE.entitlement = LE.entitlement + LR.duration
    FROM LeaveEntitlement LE
    INNER JOIN LeaveRequest LR
        ON LE.employee_id = LR.employee_id
       AND LE.leave_type_id = LR.leave_id
    WHERE LR.request_id = @LeaveRequestID
      AND LR.status = 'Approved';

    SELECT 'Leave balances synced successfully.' AS Message;
END
GO



--42:
CREATE PROCEDURE ProcessLeaveCarryForward
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE LE_Current
    SET LE_Current.entitlement = LE_Current.entitlement +
        (SELECT ISNULL(SUM(LR.duration), 0)
         FROM LeaveRequest LR
         WHERE LR.employee_id = LE_Current.employee_id
         AND LR.leave_id = LE_Current.leave_type_id
         AND LR.status = 'Approved'
         AND YEAR(LR.approval_timing) = @Year)
    FROM LeaveEntitlement LE_Current;

    SELECT 'Leave carry-forward for year ' + CAST(@Year AS VARCHAR) + ' processed successfully.' AS Message;
END;
GO


--43:
CREATE PROCEDURE SyncLeaveToAttendance
    @LeaveRequestID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert a new exception for this leave request
    INSERT INTO Exception (name, category, status)
    SELECT
        'Leave Exception for LeaveRequest ' + CAST(LR.request_id AS VARCHAR),
        'Leave',
        'Active'
    FROM LeaveRequest LR
    WHERE LR.request_id = @LeaveRequestID
      AND LR.status = 'Approved';

    -- Link the newly created exception to the employee
    INSERT INTO Employee_Exception (employee_id, exception_id)
    SELECT LR.employee_id, E.exception_id
    FROM LeaveRequest LR
    JOIN Exception E
        ON E.name = 'Leave Exception for LeaveRequest ' + CAST(LR.request_id AS VARCHAR)
    WHERE LR.request_id = @LeaveRequestID
      AND LR.status = 'Approved';

    SELECT 'Leave request synced to attendance as an exception successfully.' AS Message;
END
GO


--44:
CREATE PROCEDURE UpdateInsuranceBrackets
    @BracketID INT,
    @NewMinSalary DECIMAL(10,2),
    @NewMaxSalary DECIMAL(10,2),
    @NewEmployeeContribution DECIMAL(5,2),
    @NewEmployerContribution DECIMAL(5,2),
    @UpdatedBy INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update only the fields that exist in Insurance table
    -- contribution_rate could represent total contribution percentage
    DECLARE @TotalContribution DECIMAL(6,3);
    SET @TotalContribution = @NewEmployeeContribution + @NewEmployerContribution;

    UPDATE Insurance
    SET contribution_rate = @TotalContribution,
        coverage = 'Salary Range: ' + CAST(@NewMinSalary AS VARCHAR) + ' - ' + CAST(@NewMaxSalary AS VARCHAR)
    WHERE insurance_id = @BracketID;

    SELECT 'Insurance bracket ID ' + CAST(@BracketID AS VARCHAR) + ' updated successfully.' AS Message;
END;
GO


--45:
CREATE PROCEDURE ApprovePolicyUpdate
    @PolicyID INT,
    @ApprovedBy INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update PayrollPolicy status
    UPDATE PayrollPolicy
    SET description = description + ' [Approved by Employee ' + CAST(@ApprovedBy AS VARCHAR) + ']'
    WHERE policy_id = @PolicyID;

    SELECT 'Payroll policy update approved successfully for Policy ID ' +
           CAST(@PolicyID AS VARCHAR) AS Message;
END;
GO