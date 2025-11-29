USE HRMS_DB;
GO

 -- 1;

CREATE PROCEDURE ViewEmployeeInfo
    @EmployeeID INT
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE employee_id = @EmployeeID;
END;
GO

 -- 2;


CREATE PROCEDURE AddEmployee
    @FullName VARCHAR(200),
    @NationalID VARCHAR(50),
    @DateOfBirth DATE,
    @CountryOfBirth VARCHAR(100),
    @Phone VARCHAR(50),
    @Email VARCHAR(100),
    @Address VARCHAR(255),
    @EmergencyContactName VARCHAR(100),
    @EmergencyContactPhone VARCHAR(50),
    @Relationship VARCHAR(50),
    @Biography VARCHAR(MAX),
    @EmploymentProgress VARCHAR(100),
    @AccountStatus VARCHAR(50),
    @EmploymentStatus VARCHAR(50),
    @HireDate DATE,
    @IsActive BIT,
    @ProfileCompletion INT,
    @DepartmentID INT,
    @PositionID INT,
    @ManagerID INT,
    @ContractID INT,
    @TaxFormID INT,
    @SalaryTypeID INT,
    @PayGrade VARCHAR(50)
AS
BEGIN
    INSERT INTO Employee
    (
        full_name, national_id, date_of_birth, country_of_birth, phone, email, address,
        emergency_contact_name, emergency_contact_phone, relationship, biography,
        employment_progress, account_status, employment_status, hire_date, is_active,
        profile_completion, department_id, position_id, manager_id, contract_id,
        tax_form_id, salary_type_id, pay_grade
    )
    VALUES
    (
        @FullName, @NationalID, @DateOfBirth, @CountryOfBirth, @Phone, @Email, @Address,
        @EmergencyContactName, @EmergencyContactPhone, @Relationship, @Biography,
        @EmploymentProgress, @AccountStatus, @EmploymentStatus, @HireDate, @IsActive,
        @ProfileCompletion, @DepartmentID, @PositionID, @ManagerID, @ContractID,
        @TaxFormID, @SalaryTypeID, @PayGrade
    );

    SELECT SCOPE_IDENTITY() AS EmployeeID;
    PRINT 'Employee added successfully';
END;
GO

-- 3;

CREATE PROCEDURE UpdateEmployeeInfo
    @EmployeeID INT,
    @Email VARCHAR(100),
    @Phone VARCHAR(20),
    @Address VARCHAR(150)
AS
BEGIN
    UPDATE Employee
    SET email = @Email,
        phone = @Phone,
        address = @Address
    WHERE employee_id = @EmployeeID;

    PRINT 'Employee information updated';
END;
GO

-- 4;

CREATE PROCEDURE AssignRole
    @EmployeeID INT,
    @RoleID INT
AS
BEGIN
    -- Check if role already assigned
    IF EXISTS (SELECT 1 FROM Employee_Role WHERE employee_id = @EmployeeID AND role_id = @RoleID)
    BEGIN
        PRINT 'Role already assigned to this employee';
        RETURN;
    END

    INSERT INTO Employee_Role(employee_id, role_id, assigned_date)
    VALUES(@EmployeeID, @RoleID, GETDATE());

    PRINT 'Role assigned successfully';
END;
GO

-- 5;

CREATE PROCEDURE GetDepartmentEmployeeStats
AS
BEGIN
    SELECT
        department_name AS Department,
        COUNT(employee_id) AS NumberOfEmployees
    FROM
        Employee
    JOIN
        Department ON Employee.department_id = Department.department_id
    GROUP BY
        department_name
    ORDER BY
        NumberOfEmployees DESC;
END
GO

-- 6;

CREATE PROCEDURE ReassignManager
    @EmployeeID INT,
    @NewManagerID INT
AS
BEGIN
    UPDATE Employee
    SET manager_id = @NewManagerID
    WHERE employee_id = @EmployeeID;
      PRINT 'Manager reassigned successfully'
END;
GO

-- 7;

CREATE PROCEDURE ReassignHierarchy
    @EmployeeID INT,
    @NewDepartmentID INT,
    @NewManagerID INT
AS
BEGIN
    UPDATE Employee
    SET department_id = @NewDepartmentID,
        manager_id = @NewManagerID
    WHERE employee_id = @EmployeeID;

    PRINT 'Hierarchy updated successfully';
END;
GO

-- 8;

CREATE PROCEDURE NotifyStructureChange
    @AffectedEmployees VARCHAR(500),
    @Message VARCHAR(200)
AS
BEGIN
    -- Insert notification
    INSERT INTO Notification (message_content, urgency, notification_type)
    VALUES (@Message, 'High', 'Structure Change');

    DECLARE @NotificationID INT = SCOPE_IDENTITY();

    -- Send to all affected employees at once
    INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status, delivered_at)
    SELECT
        CAST(value AS INT),
        @NotificationID,
        'Sent',
        GETDATE()
    FROM STRING_SPLIT(@AffectedEmployees, ',');

    SELECT 'Notification sent to all affected employees' AS Message;
END
GO

-- 9;

CREATE PROCEDURE ViewOrgHierarchy
AS
BEGIN
    SELECT
        e.employee_id AS 'Employee ID',
        e.full_name AS 'Employee Name',
        m.full_name AS 'Manager Name',
        d.department_name AS 'Department',
        p.position_title AS 'Position',
        eh.hierarchy_level AS 'Hierarchy Level'
    FROM Employee e
    LEFT JOIN Employee m ON e.manager_id = m.employee_id
    LEFT JOIN Department d ON e.department_id = d.department_id
    LEFT JOIN Position p ON e.position_id = p.position_id
    LEFT JOIN EmployeeHierarchy eh ON e.employee_id = eh.employee_id
    ORDER BY eh.hierarchy_level, e.employee_id;
END
GO

-- 10;

CREATE PROCEDURE AssignShiftToEmployee
@EmployeeID INT,
@ShiftID INT,
@StartDate DATE,
@EndDate DATE
AS
BEGIN
INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date)
VALUES (@EmployeeID, @ShiftID, @StartDate, @EndDate);

SELECT 'Shift assigned successfully' AS Message;
END;
go

-- 11;

CREATE PROCEDURE UpdateShiftStatus
    @ShiftAssignmentID INT,
    @Status VARCHAR(20)
AS
BEGIN
    UPDATE ShiftAssignment
    SET status = @Status
    WHERE assignment_id = @ShiftAssignmentID;

    PRINT 'Shift status updated successfully';
END;
GO

-- 12;

CREATE PROCEDURE AssignShiftToDepartment
    @DepartmentID INT,
    @ShiftID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    INSERT INTO ShiftAssignment(employee_id, shift_id, start_date, end_date)
    SELECT employee_id, @ShiftID, @StartDate, @EndDate
    FROM Employee
    WHERE department_id = @DepartmentID;

    PRINT 'Shift assigned to department successfully';
END;
GO

-- 13;

CREATE PROCEDURE AssignCustomShift
    @EmployeeID INT,
    @ShiftName VARCHAR(50),
    @ShiftType VARCHAR(50),
    @StartTime TIME,
    @EndTime TIME,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    -- Create shift
    INSERT INTO ShiftSchedule(name, type, start_time, end_time)
    VALUES(@ShiftName, @ShiftType, @StartTime, @EndTime);

    DECLARE @ShiftID INT = SCOPE_IDENTITY();

    -- Assign created shift to employee
    INSERT INTO ShiftAssignment(employee_id, shift_id, start_date, end_date)
    VALUES(@EmployeeID, @ShiftID, @StartDate, @EndDate);

    PRINT 'Custom shift assigned successfully';
END;
GO

-- 14;

CREATE PROCEDURE ConfigureSplitShift
    @ShiftName VARCHAR(50),
    @FirstSlotStart TIME,
    @FirstSlotEnd TIME,
    @SecondSlotStart TIME,
    @SecondSlotEnd TIME
AS
BEGIN
    INSERT INTO ShiftSchedule(name, start_time, end_time)
    VALUES(@ShiftName, @FirstSlotStart, @FirstSlotEnd);

    INSERT INTO ShiftSchedule(name, start_time, end_time)
    VALUES(@ShiftName, @SecondSlotStart, @SecondSlotEnd);

    PRINT 'Split shift configured successfully';
END;
GO

-- 15;

CREATE PROCEDURE EnableFirstInLastOut
    @Enable BIT
AS
BEGIN
    IF @Enable = 1
    BEGIN
        SELECT 'First In/Last Out attendance processing enabled' AS Message;
    END
    ELSE
    BEGIN
        SELECT 'First In/Last Out attendance processing disabled' AS Message;
    END
END
GO

-- 16;

CREATE PROCEDURE TagAttendanceSource
    @AttendanceID INT,
    @SourceType VARCHAR(20),
    @DeviceID INT,
    @Latitude DECIMAL(10,7),
    @Longitude DECIMAL(10,7)
AS
BEGIN
    INSERT INTO AttendanceSource(attendance_id, device_id, source_type, latitude, longitude)
    VALUES(@AttendanceID, @DeviceID, @SourceType, @Latitude, @Longitude);

    PRINT 'Attendance source tagged successfully';
END;
GO

-- 17;

CREATE PROCEDURE SyncOfflineAttendance
    @DeviceID INT,
    @EmployeeID INT,
    @ClockTime DATETIME,
    @Type VARCHAR(10)
AS
BEGIN
    INSERT INTO Attendance(employee_id, entry_time, login_method)
    VALUES(@EmployeeID, @ClockTime, @Type);

    INSERT INTO AttendanceSource(attendance_id, device_id, source_type)
    VALUES(SCOPE_IDENTITY(), @DeviceID, @Type);

    PRINT 'Offline attendance synced successfully';
END;
GO

-- 18;

CREATE PROCEDURE LogAttendanceEdit
    @AttendanceID INT,
    @EditedBy INT,
    @OldValue DATETIME,
    @NewValue DATETIME,
    @EditTimestamp DATETIME
AS
BEGIN
    DECLARE @Reason VARCHAR(600);
    SET @Reason = 'Changed from ' + CONVERT(VARCHAR(30), @OldValue, 120) + ' to ' + CONVERT(VARCHAR(30), @NewValue, 120);

    INSERT INTO AttendanceLog (attendance_id, actor, timestamp, reason)
    VALUES (@AttendanceID, @EditedBy, @EditTimestamp, @Reason);

    SELECT 'Attendance edit logged successfully' AS Message;
END
GO


--19;

CREATE PROCEDURE ApplyHolidayOverrides
    @HolidayID INT,
    @EmployeeID INT
AS
BEGIN
    INSERT INTO Employee_Exception (employee_id, exception_id)
    VALUES (@EmployeeID, @HolidayID);

    SELECT 'Holiday override applied successfully' AS ConfirmationMessage;
END
GO

--20;

CREATE PROCEDURE ManageUserAccounts
    @UserID INT,
    @Role VARCHAR(50),
    @Action VARCHAR(20)
AS
BEGIN
    DECLARE @RoleID INT;

    SELECT @RoleID = role_id FROM Role WHERE role_name = @Role;
    IF @RoleID IS NULL
    BEGIN
        SELECT 'Error: Role not found' AS ConfirmationMessage;
        RETURN;
    END

    IF @Action = 'ADD'
        INSERT INTO Employee_Role (employee_id, role_id, assigned_date)
        VALUES (@UserID, @RoleID, GETDATE());

    IF @Action = 'REMOVE'
        DELETE FROM Employee_Role
        WHERE employee_id = @UserID AND role_id = @RoleID;

    SELECT 'User account managed successfully' AS ConfirmationMessage;
END
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

-- 1: Payroll Generation and Management
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

-- 2: Adjust Payroll Items
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

-- 3: Calculate Net Salary
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

-- 4: Apply Payroll Policies
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

-- 5: Monthly Payroll Summary
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

-- 6: Add Allowance/Deduction
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

-- 7: Employee Payroll History
CREATE PROCEDURE GetEmployeePayrollHistory
    @EmployeeID INT
AS
BEGIN
    SELECT *
    FROM Payroll
    WHERE employee_id = @EmployeeID;
END;
GO

-- 8: Get Bonus Eligible Employees
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

-- 9: Update Salary Type
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

-- 10: Get Payroll by Department
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

-- 11: Validate Attendance Before Payroll
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

-- 12: Sync Attendance to Payroll
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

-- 13: Sync Approved Permissions to Payroll
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

-- 14: Configure Pay Grades
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

-- 15: Configure Shift Allowances
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

-- 16: Enable Multi-Currency Payroll
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

-- 17: Manage Tax Rules
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

-- 18: Approve Payroll Configuration Changes
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

-- 19: Configure Signing Bonus
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

-- 20: Configure Termination/Resignation Benefits
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

-- 21: Configure Insurance Brackets
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

-- 22: Update Insurance Brackets
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

-- 23: Configure Payroll Policies
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

-- 24: Define Pay Grades
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

-- 25: Configure Escalation Workflow
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

-- 26: Define Pay Type
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

-- 27: Configure Overtime Rules
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

-- 28: Configure Shift Allowances
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


--29: Configure Signing Bonus Policy
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

--32: Generate Tax Statement
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

--33: Approve Payroll Configuration
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

--34: Modify Past Payroll Entries
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
GO

-------------------------------------------------------------
-- 1) ReviewLeaveRequest
-------------------------------------------------------------
CREATE PROCEDURE ReviewLeaveRequest
    @LeaveRequestID INT,
    @ManagerID INT,
    @Decision VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE LeaveRequest
    SET status = @Decision,
        approval_timing = ISNULL(approval_timing, GETDATE())
    WHERE request_id = @LeaveRequestID;
    INSERT INTO ManagerNotes (employee_id, manager_id, note_content, created_at)
    SELECT employee_id,
           @ManagerID,
           'Leave request ' + CAST(request_id AS VARCHAR(20)) + ' ' + @Decision,
           GETDATE()
    FROM LeaveRequest
    WHERE request_id = @LeaveRequestID;
    SELECT
        @LeaveRequestID AS LeaveRequestID,
        @ManagerID      AS ManagerID,
        @Decision       AS Decision;
END;
GO

-------------------------------------------------------------
-- 2) AssignShift
-------------------------------------------------------------
CREATE PROCEDURE AssignShift
    @EmployeeID INT,
    @ShiftID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status)
    VALUES (
        @EmployeeID,
        @ShiftID,
        CAST(GETDATE() AS DATE),
        CAST(GETDATE() AS DATE),
        'Assigned'
    );

    SELECT 'Shift assigned successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 3) ViewTeamAttendance
-------------------------------------------------------------
CREATE PROCEDURE ViewTeamAttendance
    @ManagerID INT,
    @DateRangeStart DATE,
    @DateRangeEnd DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        A.attendance_id AS AttendanceID,
        A.employee_id   AS EmployeeID,
        E.full_name     AS EmployeeName,
        A.shift_id      AS ShiftID,
        A.entry_time    AS EntryTime,
        A.exit_time     AS ExitTime,
        A.duration      AS Duration,
        A.login_method  AS LoginMethod,
        A.logout_method AS LogoutMethod,
        A.exception_id  AS ExceptionID
    FROM Attendance AS A
    INNER JOIN Employee AS E
        ON A.employee_id = E.employee_id
    WHERE
        E.manager_id = @ManagerID
        AND CAST(A.entry_time AS DATE) BETWEEN @DateRangeStart AND @DateRangeEnd
    ORDER BY
        E.employee_id,
        A.entry_time;
END;
GO

-------------------------------------------------------------
-- 4) SendTeamNotification
-------------------------------------------------------------
CREATE PROCEDURE SendTeamNotification
    @ManagerID INT,
    @MessageContent VARCHAR(255),
    @UrgencyLevel VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NotificationID INT;
    INSERT INTO Notification (message_content, timestamp, urgency, read_status, notification_type)
    VALUES (@MessageContent, GETDATE(), @UrgencyLevel, 'Unread', 'TeamNotification');

    SET @NotificationID = SCOPE_IDENTITY();
    INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status, delivered_at)
    SELECT
        E.employee_id,
        @NotificationID,
        'Sent',
        GETDATE()
    FROM Employee AS E
    WHERE E.manager_id = @ManagerID;

    SELECT 'Notification sent successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 5) ApproveMissionCompletion
-------------------------------------------------------------
CREATE PROCEDURE ApproveMissionCompletion
    @MissionID INT,
    @ManagerID INT,
    @Remarks VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Mission
    SET status = 'Completed'
    WHERE mission_id = @MissionID
      AND manager_id = @ManagerID;
    INSERT INTO ManagerNotes (employee_id, manager_id, note_content, created_at)
    SELECT
        employee_id,
        @ManagerID,
        ISNULL(@Remarks, 'Mission completion approved.'),
        GETDATE()
    FROM Mission
    WHERE mission_id = @MissionID;

    SELECT 'Mission completion approved successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 6) RequestReplacement
-------------------------------------------------------------
CREATE PROCEDURE RequestReplacement
    @EmployeeID INT,
    @Reason VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO ManagerNotes (employee_id, manager_id, note_content, created_at)
    SELECT
        @EmployeeID,
        manager_id,
        'Replacement requested: ' + @Reason,
        GETDATE()
    FROM Employee
    WHERE employee_id = @EmployeeID;

    SELECT 'Replacement request submitted successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 7) ViewDepartmentSummary
-------------------------------------------------------------
CREATE PROCEDURE ViewDepartmentSummary
    @DepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        D.department_id   AS DepartmentID,
        D.department_name AS DepartmentName,
        COUNT(DISTINCT E.employee_id) AS EmployeeCount,
        COUNT(DISTINCT M.mission_id)  AS ActiveProjects
    FROM Department AS D
    LEFT JOIN Employee AS E
        ON E.department_id = D.department_id
    LEFT JOIN Mission AS M
        ON M.employee_id = E.employee_id
       AND M.status = 'Active'
    WHERE D.department_id = @DepartmentID
    GROUP BY
        D.department_id,
        D.department_name;
END;
GO

-------------------------------------------------------------
-- 8) ReassignShift
-------------------------------------------------------------
CREATE PROCEDURE ReassignShift
    @EmployeeID INT,
    @OldShiftID INT,
    @NewShiftID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ShiftAssignment
    SET shift_id = @NewShiftID
    WHERE employee_id = @EmployeeID
      AND shift_id    = @OldShiftID
      AND status IN ('Active','Assigned');

    SELECT 'Shift reassigned successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 9) GetPendingLeaveRequests
-------------------------------------------------------------
CREATE PROCEDURE GetPendingLeaveRequests
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        LR.request_id         AS LeaveRequestID,
        LR.employee_id        AS EmployeeID,
        E.full_name           AS EmployeeName,
        LR.leave_id           AS LeaveID,
        L.leave_type          AS LeaveType,
        LR.justification,
        LR.duration,
        LR.approval_timing,
        LR.status
    FROM LeaveRequest AS LR
    INNER JOIN Employee AS E
        ON LR.employee_id = E.employee_id
    LEFT JOIN Leave AS L
        ON LR.leave_id = L.leave_id
    WHERE E.manager_id = @ManagerID
      AND LR.status    = 'Pending'
    ORDER BY LR.approval_timing, LR.request_id;
END;
GO

-------------------------------------------------------------
-- 10) GetTeamStatistics
-------------------------------------------------------------
CREATE PROCEDURE GetTeamStatistics
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        @ManagerID AS ManagerID,
        COUNT(DISTINCT E.employee_id) AS TeamSize,
        AVG( (PG.min_salary + PG.max_salary) / 2.0 ) AS AverageSalary,
        COUNT(DISTINCT E.employee_id) AS SpanOfControl
    FROM Employee AS E
    LEFT JOIN PayGrade AS PG
        ON PG.pay_grade_id = E.pay_grade
    WHERE E.manager_id = @ManagerID;
END;
GO

-------------------------------------------------------------
-- 11) ViewTeamProfiles
-------------------------------------------------------------
CREATE PROCEDURE ViewTeamProfiles
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.employee_id      AS EmployeeID,
        E.full_name        AS FullName,
        E.position_id      AS PositionID,
        E.department_id    AS DepartmentID,
        E.hire_date        AS HireDate,
        E.employment_status AS EmploymentStatus,
        E.account_status    AS AccountStatus
    FROM Employee AS E
    WHERE E.manager_id = @ManagerID
    ORDER BY E.full_name;
END;
GO

-------------------------------------------------------------
-- 12) GetTeamSummary
-------------------------------------------------------------
CREATE PROCEDURE GetTeamSummary
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.position_id   AS PositionID,
        E.department_id AS DepartmentID,
        COUNT(*)        AS EmployeeCount,
        AVG(DATEDIFF(YEAR, E.hire_date, GETDATE())) AS AverageTenureYears
    FROM Employee AS E
    WHERE E.manager_id = @ManagerID
    GROUP BY
        E.position_id,
        E.department_id;
END;
GO

-------------------------------------------------------------
-- 13) FilterTeamProfiles
-------------------------------------------------------------
CREATE PROCEDURE FilterTeamProfiles
    @ManagerID INT,
    @Skill VARCHAR(50),
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
        E.employee_id   AS EmployeeID,
        E.full_name     AS FullName,
        E.position_id   AS PositionID,
        E.department_id AS DepartmentID
    FROM Employee AS E
    LEFT JOIN Employee_Skill AS ES
        ON ES.employee_id = E.employee_id
    LEFT JOIN Skill AS S
        ON S.skill_id = ES.skill_id
    LEFT JOIN Employee_Role AS ER
        ON ER.employee_id = E.employee_id
    WHERE E.manager_id = @ManagerID
      AND (
            (@Skill IS NOT NULL AND @Skill <> '' AND S.skill_name = @Skill)
         OR (@RoleID IS NOT NULL AND ER.role_id = @RoleID)
          )
    ORDER BY E.full_name;
END;
GO

-------------------------------------------------------------
-- 14) ViewTeamCertifications
-------------------------------------------------------------
CREATE PROCEDURE ViewTeamCertifications
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.employee_id    AS EmployeeID,
        E.full_name      AS FullName,
        S.skill_name     AS SkillName,
        V.verification_type AS CertificationName,
        V.issue_date     AS CertificationDate
    FROM Employee AS E
    LEFT JOIN Employee_Skill AS ES
        ON ES.employee_id = E.employee_id
    LEFT JOIN Skill AS S
        ON S.skill_id = ES.skill_id
    LEFT JOIN Employee_Verification AS EV
        ON EV.employee_id = E.employee_id
    LEFT JOIN Verification AS V
        ON V.verification_id = EV.verification_id
    WHERE E.manager_id = @ManagerID
    ORDER BY
        E.full_name,
        S.skill_name,
        V.verification_type;
END;
GO

-------------------------------------------------------------
-- 15) AddManagerNotes
-------------------------------------------------------------
CREATE PROCEDURE AddManagerNotes
    @EmployeeID INT,
    @ManagerID INT,
    @Note VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ManagerNotes (employee_id, manager_id, note_content, created_at)
    VALUES (@EmployeeID, @ManagerID, @Note, GETDATE());

    SELECT 'Manager note added successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 16) RecordManualAttendance
-------------------------------------------------------------
CREATE PROCEDURE RecordManualAttendance
    @EmployeeID INT,
    @Date DATE,
    @ClockIn TIME,
    @ClockOut TIME,
    @Reason VARCHAR(200),
    @RecordedBy INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EntryTime DATETIME;
    DECLARE @ExitTime DATETIME;
    DECLARE @Duration INT;
    DECLARE @AttendanceID INT;

    SET @EntryTime = CAST(@Date AS DATETIME) + CAST(@ClockIn AS DATETIME);
    SET @ExitTime  = CAST(@Date AS DATETIME) + CAST(@ClockOut AS DATETIME);

    SET @Duration = DATEDIFF(MINUTE, @EntryTime, @ExitTime);

    INSERT INTO Attendance (
        employee_id,
        shift_id,
        entry_time,
        exit_time,
        duration,
        login_method,
        logout_method,
        exception_id
    )
    VALUES (
        @EmployeeID,
        NULL,
        @EntryTime,
        @ExitTime,
        @Duration,
        'Manual',
        'Manual',
        NULL
    );

    SET @AttendanceID = SCOPE_IDENTITY();

    INSERT INTO AttendanceLog (attendance_id, actor, timestamp, reason)
    VALUES (@AttendanceID, @RecordedBy, GETDATE(), @Reason);

    SELECT 'Manual attendance recorded successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 17) ReviewMissedPunches
-------------------------------------------------------------
CREATE PROCEDURE ReviewMissedPunches
    @ManagerID INT,
    @Date DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        A.attendance_id AS AttendanceID,
        A.employee_id   AS EmployeeID,
        E.full_name     AS EmployeeName,
        A.entry_time    AS EntryTime,
        A.exit_time     AS ExitTime,
        A.login_method  AS LoginMethod,
        A.logout_method AS LogoutMethod,
        A.exception_id  AS ExceptionID
    FROM Attendance AS A
    INNER JOIN Employee AS E
        ON A.employee_id = E.employee_id
    INNER JOIN Exception AS EX
        ON EX.exception_id = A.exception_id
    WHERE E.manager_id = @ManagerID
      AND CAST(A.entry_time AS DATE) = @Date
      AND EX.category = 'Missed Punch'
    ORDER BY A.entry_time;
END;
GO

-------------------------------------------------------------
-- 18) ApproveTimeRequest
-------------------------------------------------------------
CREATE PROCEDURE ApproveTimeRequest
    @RequestID INT,
    @ManagerID INT,
    @Decision VARCHAR(20),
    @Comments VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE AttendanceCorrectionRequest
    SET
        status      = @Decision,
        recorded_by = @ManagerID,
        reason      = @Comments
    WHERE request_id = @RequestID;

    SELECT 'Time management request processed successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 19) ViewLeaveRequest
-------------------------------------------------------------
CREATE PROCEDURE ViewLeaveRequest
    @LeaveRequestID INT,
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        LR.request_id      AS LeaveRequestID,
        LR.employee_id     AS EmployeeID,
        E.full_name        AS EmployeeName,
        LR.leave_id        AS LeaveID,
        L.leave_type       AS LeaveType,
        LR.justification,
        LR.duration,
        LR.approval_timing,
        LR.status
    FROM LeaveRequest AS LR
    INNER JOIN Employee AS E
        ON LR.employee_id = E.employee_id
    LEFT JOIN Leave AS L
        ON LR.leave_id = L.leave_id
    WHERE LR.request_id = @LeaveRequestID
      AND E.manager_id  = @ManagerID;
END;
GO

-------------------------------------------------------------
-- 20) ApproveLeaveRequest (Line Manager)
-------------------------------------------------------------
CREATE PROCEDURE ApproveLeaveRequestt
    @LeaveRequestID INT,
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE LeaveRequest
    SET status          = 'Approved',
        approval_timing = ISNULL(approval_timing, GETDATE())
    WHERE request_id = @LeaveRequestID;

    INSERT INTO ManagerNotes (employee_id, manager_id, note_content, created_at)
    SELECT
        employee_id,
        @ManagerID,
        'Leave request ' + CAST(request_id AS VARCHAR(20)) + ' approved',
        GETDATE()
    FROM LeaveRequest
    WHERE request_id = @LeaveRequestID;

    SELECT 'Leave request approved successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 21) RejectLeaveRequest
-------------------------------------------------------------
CREATE PROCEDURE RejectLeaveRequest
    @LeaveRequestID INT,
    @ManagerID INT,
    @Reason VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE LeaveRequest
    SET status          = 'Rejected',
        approval_timing = ISNULL(approval_timing, GETDATE()),
        justification   = ISNULL(justification, '') +
                          CASE WHEN justification IS NULL OR justification = '' THEN '' ELSE ' | ' END +
                          'Manager reason: ' + @Reason
    WHERE request_id = @LeaveRequestID;

    INSERT INTO ManagerNotes (employee_id, manager_id, note_content, created_at)
    SELECT
        employee_id,
        @ManagerID,
        'Leave request ' + CAST(request_id AS VARCHAR(20)) +
        ' rejected. Reason: ' + @Reason,
        GETDATE()
    FROM LeaveRequest
    WHERE request_id = @LeaveRequestID;

    SELECT 'Leave request rejected successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 22) DelegateLeaveApproval
-------------------------------------------------------------
CREATE PROCEDURE DelegateLeaveApproval
    @ManagerID INT,
    @DelegateID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Note VARCHAR(500);

    SET @Note =
        'Delegated leave approval to manager ID ' + CAST(@DelegateID AS VARCHAR(20)) +
        ' from ' + CONVERT(VARCHAR(10), @StartDate, 120) +
        ' to '   + CONVERT(VARCHAR(10), @EndDate, 120);

    -- Log delegation as a manager note
    INSERT INTO ManagerNotes (employee_id, manager_id, note_content, created_at)
    VALUES (@ManagerID, @ManagerID, @Note, GETDATE());

    SELECT 'Leave approval authority delegated successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 23) FlagIrregularLeave
-------------------------------------------------------------
CREATE PROCEDURE FlagIrregularLeave
    @EmployeeID INT,
    @ManagerID INT,
    @PatternDescription VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ManagerNotes (employee_id, manager_id, note_content, created_at)
    VALUES (@EmployeeID, @ManagerID, @PatternDescription, GETDATE());

    SELECT 'Irregular leave pattern flagged successfully.' AS Message;
END;
GO

-------------------------------------------------------------
-- 24) NotifyNewLeaveRequest
-------------------------------------------------------------
CREATE OR ALTER PROCEDURE NotifyNewLeaveRequest
    @ManagerID INT,
    @RequestID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MessageContent VARCHAR(255);
    DECLARE @NotificationID INT;

    SET @MessageContent =
        'New leave request assigned. Request ID: ' + CAST(@RequestID AS VARCHAR(20));

    INSERT INTO Notification (message_content, timestamp, urgency, read_status, notification_type)
    VALUES (@MessageContent, GETDATE(), 'Normal', 'Unread', 'LeaveRequest');

    SET @NotificationID = SCOPE_IDENTITY();

    INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status, delivered_at)
    VALUES (@ManagerID, @NotificationID, 'Sent', GETDATE());

    SELECT @MessageContent AS NotificationMessage;
END;
GO

-- 1) SubmitLeaveRequest
CREATE PROCEDURE SubmitLeaveRequest
    @EmployeeID INT,
    @LeaveTypeID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Reason VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LeaveRequest (employee_id, leave_id, justification, duration, approval_timing, status)
    VALUES (@EmployeeID, @LeaveTypeID, @Reason, DATEDIFF(DAY, @StartDate, @EndDate) + 1, GETDATE(), 'Pending');
    PRINT 'Leave request submitted successfully.';
END;
GO

-- 2) GetLeaveBalance
CREATE PROCEDURE GetLeaveBalance
    @EmployeeID INT
AS
BEGIN
    SELECT
        l.leave_type AS 'Leave Type',
        le.entitlement AS 'Remaining Days'
    FROM LeaveEntitlement le
    INNER JOIN Leave l ON le.leave_type_id = l.leave_id
    WHERE le.employee_id = @EmployeeID;
END
GO

-- 3) RecordAttendance
CREATE PROCEDURE RecordAttendance
    @EmployeeID INT,
    @ShiftID INT,
    @EntryTime TIME,
    @ExitTime TIME
AS
BEGIN
    INSERT INTO Attendance (employee_id, shift_id, entry_time, exit_time)
    VALUES (@EmployeeID, @ShiftID, @EntryTime, @ExitTime);

    SELECT 'Attendance recorded successfully' AS ConfirmationMessage;
END;
GO

-- 4) SubmitReimbursement
CREATE PROCEDURE SubmitReimbursement
    @EmployeeID INT,
    @ExpenseType VARCHAR(50),
    @Amount DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Reimbursement (employee_id, type, claim_type, current_status)
VALUES (
    @EmployeeID,
    @ExpenseType,
    @ExpenseType + ' | Amount: ' + CAST(@Amount AS VARCHAR(20)),
    'Pending'
);

    SELECT 'Reimbursement request submitted successfully' AS ConfirmationMessage;
END;
GO

-- 5) AddEmployeeSkill
CREATE PROCEDURE AddEmployeeSkill
    @EmployeeID INT,
    @SkillName VARCHAR(50)
AS
BEGIN
    DECLARE @SkillID INT;

    SELECT @SkillID = skill_id
    FROM Skill
    WHERE skill_name = @SkillName;

    INSERT INTO Employee_Skill (employee_id, skill_id)
    VALUES (@EmployeeID, @SkillID);

    SELECT 'Skill added successfully' AS ConfirmationMessage;
END;
GO

-- 6) ViewAssignedShifts
CREATE PROCEDURE ViewAssignedShifts
    @EmployeeID INT
AS
BEGIN
    SELECT
        ss.shift_date,
        ss.start_time,
        ss.end_time,
        ss.location
    FROM
        ShiftAssignment sa
    INNER JOIN
        ShiftSchedule ss ON sa.shift_id = ss.shift_id
    WHERE
        sa.employee_id = @EmployeeID;
END;
GO

-- 7) ViewMyContracts
CREATE PROCEDURE ViewMyContracts
    @EmployeeID INT
AS
BEGIN
    SELECT
        c.contract_id,
        c.type,
        c.start_date,
        c.end_date,
        c.current_state
    FROM
        Contract c
    INNER JOIN
        Employee e ON c.contract_id = e.contract_id
    WHERE
        e.employee_id = @EmployeeID;
END;
GO

-- 8) ViewMyPayroll
CREATE PROCEDURE ViewMyPayroll
    @EmployeeID INT
AS
BEGIN
    SELECT
        payroll_id,
        period_start,
        period_end,
        base_amount,
        adjustments,
        contributions,
        taxes,
        net_salary,
        payment_date
    FROM
        Payroll
    WHERE
        employee_id = @EmployeeID;
END;
GO

-- 9) UpdatePersonalDetails
CREATE PROCEDURE UpdatePersonalDetails
    @EmployeeID INT,
    @Phone VARCHAR(20),
    @Address VARCHAR(150)
AS
BEGIN
    UPDATE Employee
    SET phone = @Phone,
        address = @Address
    WHERE employee_id = @EmployeeID;

    SELECT 'Contact details updated successfully' AS ConfirmationMessage;
END;
GO

-- 10) ViewMyMissions
CREATE PROCEDURE ViewMyMissions
    @EmployeeID INT
AS
BEGIN
    SELECT
        mission_id,
        destination,
        start_date,
        end_date,
        status
    FROM
        Mission
    WHERE
        employee_id = @EmployeeID;
END;
GO

-- 11) ViewEmployeeProfile
CREATE PROCEDURE ViewEmployeeProfile
    @EmployeeID INT
AS
BEGIN
    SELECT
        e.employee_id,
        e.first_name,
        e.last_name,
        e.email,
        e.phone,
        e.address,
        e.date_of_birth,
        e.hire_date,
        e.employment_status,
        d.department_name,
        p.position_title
    FROM
        Employee e
    LEFT JOIN
        Department d ON e.department_id = d.department_id
    LEFT JOIN
        Position p ON e.position_id = p.position_id
    WHERE
        e.employee_id = @EmployeeID;
END;
GO

-- 12) UpdateContactInformation
CREATE PROCEDURE UpdateContactInformation
    @EmployeeID INT,
    @RequestType VARCHAR(50),
    @NewValue VARCHAR(100)
AS
BEGIN
    IF @RequestType = 'Phone'
    BEGIN
        UPDATE Employee
        SET phone = @NewValue
        WHERE employee_id = @EmployeeID;
    END
    ELSE IF @RequestType = 'Address'
    BEGIN
        UPDATE Employee
        SET address = @NewValue
        WHERE employee_id = @EmployeeID;
    END

    SELECT 'Contact information updated successfully' AS ConfirmationMessage;
END;
GO

-- 13) ViewEmploymentTimeline
CREATE PROCEDURE ViewEmploymentTimeline
    @EmployeeID INT
AS
BEGIN
    SELECT
        e.hire_date,
        c.type AS contract_type,
        c.start_date,
        c.end_date,
        c.current_state
    FROM
        Employee e
    LEFT JOIN
        Contract c ON e.contract_id = c.contract_id
    WHERE
        e.employee_id = @EmployeeID;
END;
GO

-- 14) UpdateEmergencyContact
CREATE PROCEDURE UpdateEmergencyContact
    @EmployeeID INT,
    @ContactName VARCHAR(100),
    @Relation VARCHAR(50),
    @Phone VARCHAR(20)
AS
BEGIN
    UPDATE Employee
    SET emergency_contact_name = @ContactName,
        relationship = @Relation,
        emergency_contact_phone = @Phone
    WHERE employee_id = @EmployeeID;

    SELECT 'Emergency contact updated successfully' AS ConfirmationMessage;
END;
GO

-- 15) RequestHRDocument
CREATE PROCEDURE RequestHRDocument
    @EmployeeID INT,
    @DocumentType VARCHAR(50)
AS
BEGIN
    INSERT INTO Verification (verification_type, issuer, issue_date)
    VALUES (@DocumentType, 'HR Department', GETDATE());

    DECLARE @VerificationID INT = SCOPE_IDENTITY();

    INSERT INTO Employee_Verification (employee_id, verification_id)
    VALUES (@EmployeeID, @VerificationID);

    SELECT 'HR document request submitted successfully' AS ConfirmationMessage;
END;
GO

-- 16) NotifyProfileUpdate
CREATE PROCEDURE NotifyProfileUpdate
    @EmployeeID INT,
    @notificationType VARCHAR(50)
AS
BEGIN
    INSERT INTO Notification (message_content, notification_type, urgency)
    VALUES ('Profile updated', @notificationType, 'Normal');

    DECLARE @NotificationID INT = SCOPE_IDENTITY();

    INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status, delivered_at)
    VALUES (@EmployeeID, @NotificationID, 'Sent', GETDATE());

    SELECT 'Notification sent successfully' AS ConfirmationMessage;
END;
GO

--17) LogFlexibleAttendance
CREATE PROCEDURE LogFlexibleAttendance
    @EmployeeID INT,
    @Date DATE,
    @CheckIn TIME,
    @CheckOut TIME
AS
BEGIN
    DECLARE @TotalHours INT = DATEDIFF(HOUR, @CheckIn, @CheckOut);
    DECLARE @EntryDateTime DATETIME = CAST(@Date AS DATETIME) + CAST(@CheckIn AS DATETIME);
    DECLARE @ExitDateTime  DATETIME = CAST(@Date AS DATETIME) + CAST(@CheckOut AS DATETIME);

    INSERT INTO Attendance (employee_id, entry_time, exit_time, duration)
    VALUES (@EmployeeID, @EntryDateTime, @ExitDateTime, @TotalHours);

    PRINT 'Attendance logged successfully. Total working hours: ' + CAST(@TotalHours AS VARCHAR);
END;
GO

-- 18) NotifyMissedPunch
    CREATE PROCEDURE NotifyMissedPunch
    @EmployeeID INT,
    @Date DATE
AS
BEGIN
    INSERT INTO Notification (message_content, notification_type, urgency)
    VALUES ('You missed a punch on ' + CAST(@Date AS VARCHAR), 'Missed Punch', 'High');

    DECLARE @NotificationID INT = SCOPE_IDENTITY();

    INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status, delivered_at)
    VALUES (@EmployeeID, @NotificationID, 'Sent', GETDATE());

    SELECT 'Notification sent for missed punch' AS NotificationMessage;
END;
GO

-- 19) RecordMultiplePunches
CREATE PROCEDURE RecordMultiplePunches
    @EmployeeID INT,
    @ClockInOutTime DATETIME,
    @Type VARCHAR(10)
AS
BEGIN
    IF @Type = 'IN'
    BEGIN
        INSERT INTO Attendance (employee_id, entry_time)
        VALUES (@EmployeeID, @ClockInOutTime);

        SELECT 'Clocked In Successfully';
    END
    IF @Type = 'OUT'
    BEGIN
        UPDATE Attendance
        SET exit_time = @ClockInOutTime,
            duration = DATEDIFF(MINUTE, entry_time, @ClockInOutTime)
        WHERE attendance_id = (
            SELECT TOP 1 attendance_id
            FROM Attendance
            WHERE employee_id = @EmployeeID
                AND exit_time IS NULL
            ORDER BY entry_time DESC
        );

        SELECT 'Clocked Out Successfully';
    END
END
GO

-- 20) SubmitCorrectionRequest
CREATE PROCEDURE SubmitCorrectionRequest
    @EmployeeID INT,
    @Date DATE,
    @CorrectionType VARCHAR(50),
    @Reason VARCHAR(200)
AS
BEGIN
    -- Insert a new correction request
    INSERT INTO AttendanceCorrectionRequest (employee_id, date, correction_type, reason, status, recorded_by)
    VALUES (@EmployeeID, @Date, @CorrectionType, @Reason, 'Pending', @EmployeeID);

    -- Confirmation message
    SELECT 'Correction request submitted successfully' AS Message;
END
GO

-- 21) ViewRequestStatus
CREATE PROCEDURE ViewRequestStatus
    @EmployeeID INT
AS
BEGIN
    SELECT
        request_id AS 'Request ID',
        'Correction Request' AS 'Request Type',
        date AS 'Date',
        correction_type AS 'Details',
        reason AS 'Reason',
        status AS 'Status'
    FROM AttendanceCorrectionRequest
    WHERE employee_id = @EmployeeID
    ORDER BY request_id DESC;
END
GO

-- 22) AttachLeaveDocuments
CREATE PROCEDURE AttachLeaveDocuments
    @LeaveRequestID INT,
    @FilePath VARCHAR(200)
AS
BEGIN
    INSERT INTO LeaveDocument (leave_request_id, file_path)
    VALUES (@LeaveRequestID, @FilePath);
    SELECT 'Document attached successfully' AS Message;
END
GO

-- 23) ModifyLeaveRequest
CREATE PROCEDURE ModifyLeaveRequest
    @LeaveRequestID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Reason VARCHAR(100)
AS
BEGIN
    DECLARE @Duration INT;
    SET @Duration = DATEDIFF(DAY, @StartDate, @EndDate) + 1;
    UPDATE LeaveRequest
    SET justification = @Reason,
        duration = @Duration
    WHERE request_id = @LeaveRequestID;

    SELECT 'Leave request modified successfully' AS Message;
END
GO

-- 24) CancelLeaveRequest
CREATE PROCEDURE CancelLeaveRequest
    @LeaveRequestID INT
AS
BEGIN
    UPDATE LeaveRequest
    SET status = 'Cancelled'
    WHERE request_id = @LeaveRequestID;

    SELECT 'Leave request cancelled successfully' AS Message;
END
GO

-- 25) ViewLeaveBalance
CREATE PROCEDURE ViewLeaveBalance
    @EmployeeID INT
AS
BEGIN
    SELECT
        l.leave_type AS 'Leave Type',
        le.entitlement AS 'Remaining Days'
    FROM LeaveEntitlement le
    INNER JOIN Leave l ON le.leave_type_id = l.leave_id
    WHERE le.employee_id = @EmployeeID;
END
GO

-- 26) ViewLeaveHistory
CREATE PROCEDURE ViewLeaveHistory
    @EmployeeID INT
AS
BEGIN
    SELECT
        request_id AS 'Request ID',
        l.leave_type AS 'Leave Type',
        justification AS 'Reason',
        duration AS 'Duration (Days)',
        status AS 'Status',
        approval_timing AS 'Approval Date'
    FROM LeaveRequest lr
    INNER JOIN Leave l ON lr.leave_id = l.leave_id
    WHERE lr.employee_id = @EmployeeID
    ORDER BY request_id DESC;
END
GO

-- 27) SubmitLeaveAfterAbsence
CREATE PROCEDURE SubmitLeaveAfterAbsence
    @EmployeeID INT,
    @LeaveTypeID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Reason VARCHAR(100)
AS
BEGIN
    DECLARE @Duration INT;
    SET @Duration = DATEDIFF(DAY, @StartDate, @EndDate) + 1;
    INSERT INTO LeaveRequest (employee_id, leave_id, justification, duration, status)
    VALUES (@EmployeeID, @LeaveTypeID, @Reason, @Duration, 'Pending');
    SELECT 'Leave request submitted successfully' AS Message;
END
GO

-- 28) NotifyLeaveStatusChange
CREATE PROCEDURE NotifyLeaveStatusChange
    @EmployeeID INT,
    @RequestID INT,
    @Status VARCHAR(20)
AS
BEGIN
    DECLARE @Message VARCHAR(500);
    SET @Message = 'Your leave request #' + CAST(@RequestID AS VARCHAR(10)) + ' has been ' + @Status;

    INSERT INTO Notification (message_content, urgency, notification_type)
    VALUES (@Message, 'Medium', 'Leave Status');

    DECLARE @NotificationID INT;
    SET @NotificationID = SCOPE_IDENTITY();

    INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status, delivered_at)
    VALUES (@EmployeeID, @NotificationID, 'Sent', GETDATE());

    SELECT @Message AS 'Notification';
END
GO
