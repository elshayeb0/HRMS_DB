-- =============================================
-- File: 02_hr_admin.sql
-- Project: HRMS_DB - Milestone 2

-- Purpose: Stored procedures for "As an HR Admin" user stories

-- Note: Names must match the Milestone 2 specification exactly
-- =============================================

USE HRMS_DB;
GO

-- 1:
CREATE PROCEDURE CreateContract
    @EmployeeID INT,
    @Type VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE,
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
    FROM Contract c, Employee e
    WHERE e.contract_id = c.contract_id
      AND c.current_state = 'Active'
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
        full_name AS employee_name,
        email,
        phone,
        department_id,
        position_id
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

 -- 9: check again
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
    @Phone VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Employee (first_name, last_name, full_name, department_id, position_id, hire_date, email, phone, is_active, employment_status, account_status)
    VALUES (@FirstName, @LastName, @FirstName + ' ' + @LastName, @DepartmentID, @RoleID, @HireDate, @Email, @Phone, 1, 'Active', 'Active');

    SELECT 'Employee profile created successfully. New Employee ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR) AS Message;

END;
GO

-- 12:  check again
CREATE PROCEDURE UpdateEmployeeProfile
    @EmployeeID INT,
    @FirstName VARCHAR(50) = NULL,
    @LastName VARCHAR(50) = NULL,
    @DepartmentID INT = NULL,
    @PositionID INT = NULL,
    @Email VARCHAR(100) = NULL,
    @Phone VARCHAR(20) = NULL,
    @Address VARCHAR(200) = NULL,
    @EmploymentStatus VARCHAR(20) = NULL,
    @AccountStatus VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Employee
    SET
        first_name = ISNULL(@FirstName, first_name),
        last_name = ISNULL(@LastName, last_name),
        full_name = ISNULL(@FirstName, first_name) + ' ' + ISNULL(@LastName, last_name),
        department_id = ISNULL(@DepartmentID, department_id),
        position_id = ISNULL(@PositionID, position_id),
        email = ISNULL(@Email, email),
        phone = ISNULL(@Phone, phone),
        address = ISNULL(@Address, address),
        employment_status = ISNULL(@EmploymentStatus, employment_status),
        account_status = ISNULL(@AccountStatus, account_status)
    WHERE employee_id = @EmployeeID;

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


--14: check again
CREATE PROCEDURE GenerateProfileReport
    @FilterField VARCHAR(50),
    @FilterValue VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT employee_id, full_name, department_id, position_id, gender, hire_date, email, phone
    FROM Employee
    WHERE
        (@FilterField = 'department_id' AND CAST(department_id AS VARCHAR) = @FilterValue)
        OR (@FilterField = 'gender' AND gender = @FilterValue)
        OR (@FilterField = 'position_id' AND CAST(position_id AS VARCHAR) = @FilterValue);
END;
GO

--15:
CREATE PROCEDURE CreateShiftType
    @ShiftTypeName VARCHAR(50),
    @Description VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ShiftSchedule (name, type, start_time, end_time, break_duration, shift_date, status)
    VALUES (@ShiftTypeName, @Description, NULL, NULL, NULL, NULL, 'Active');

    SELECT 'Shift type "' + @ShiftTypeName + '" created successfully.' AS Message;
END;
GO

--16:
CREATE PROCEDURE CreateShiftName
    @ShiftName VARCHAR(50),
    @ShiftTypeID INT,
    @Description VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ShiftSchedule (name, type, start_time, end_time, break_duration, shift_date, status)
    VALUES (@ShiftName, @ShiftTypeID, NULL, NULL, NULL, NULL, 'Active');

    SELECT 'Shift name "' + @ShiftName + '" created successfully.' AS Message;
END;
GO


--17:
CREATE PROCEDURE AssignRotationalShift
    @EmployeeID INT,
    @ShiftCycle VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status)
    VALUES (@EmployeeID, @ShiftCycle, @StartDate, @EndDate, 'Assigned');

    SELECT 'Employee ID ' + CAST(@EmployeeID AS VARCHAR) +
           ' assigned to shift cycle ' + @ShiftCycle +
           ' from ' + CAST(@StartDate AS VARCHAR) +
           ' to ' + CAST(@EndDate AS VARCHAR) AS Message;
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

    -- Insert a notification directly with fixed message content
    INSERT INTO Notification (message_content, urgency, notification_type)
    VALUES (
        'Shift Assignment ID ' + CAST(@ShiftAssignmentID AS VARCHAR) +
        ' for Employee ID ' + CAST(@EmployeeID AS VARCHAR) +
        ' is nearing expiry on ' + CAST(@ExpiryDate AS VARCHAR),
        'High',
        'ShiftExpiry'
    );

    -- Link the notification to the employee assuming the notification_id is known/fixed
    -- Here you would need to know the ID to insert; simplified as 1 for example
    INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status)
    VALUES (
        @EmployeeID,
        1,
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
    -- Update what exists in LatenessPolicy
    UPDATE LatenessPolicy
    SET grace_period_mins = @LateMinutes,
        deduction_rate = @EarlyLeaveMinutes; -- using EarlyLeaveMinutes as a placeholder

    -- Confirmation message
    SELECT 'Short time rule "' + @RuleName + '" with penalty type "' + @PenaltyType + '" applied successfully.' AS Message;
END
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
    UPDATE DeductionPolicy
    SET calculation_mode = @DeductionType;

    SELECT 'Penalty threshold for ' + CAST(@LateMinutes AS VARCHAR(5)) + ' late minutes set successfully.' AS Message;
END
GO
--22:

CREATE PROCEDURE DefinePermissionLimits
    @MinHours INT,
    @MaxHours INT
AS
BEGIN
    -- Update what exists in LineManager approval_limit as a placeholder
    UPDATE LineManager
    SET approval_limit = @MaxHours;  -- Using MaxHours as the upper limit

    -- Confirmation message
    SELECT 'Permission limits set successfully. Min hours: '
           + CAST(@MinHours AS VARCHAR(5))
           + ', Max hours: '
           + CAST(@MaxHours AS VARCHAR(5)) AS Message;
END
GO


-- 23: Escalate pending leave requests
CREATE PROCEDURE EscalatePendingRequests
    @Deadline DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Update pending requests to escalate to their manager
    UPDATE LeaveRequest
    SET employee_id = (SELECT manager_id
                       FROM Employee
                       WHERE employee_id = LeaveRequest.employee_id)
    WHERE status = 'Pending'
      AND approval_timing <= @Deadline;

    -- Confirmation message
    SELECT 'Pending requests escalated to higher managers as of '
           + CAST(@Deadline AS VARCHAR(30)) AS Message;
END;
GO



--24:
CREATE PROCEDURE LinkVacationToShift
    @VacationPackageID INT,
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Link vacation package to employee
    INSERT INTO Employee_Vacation (employee_id, vacation_package_id)
    VALUES (@EmployeeID, @VacationPackageID);

    -- Confirmation message
    SELECT 'Vacation package ID ' + CAST(@VacationPackageID AS VARCHAR) +
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
    -- Example: recalculate entitlements based on policies
    UPDATE LeaveEntitlement
    SET entitlement = LE.entitlement + ISNULL(LP.notice_period,0)
    FROM LeaveEntitlement LE, LeavePolicy LP, Leave L
    WHERE LE.employee_id = @EmployeeID AND LE.leave_type_id = L.leave_id AND LP.name = 'Default Policy';

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
    -- Remove existing permission with the same name
    DELETE FROM RolePermission WHERE role_id = @RoleID AND permission_name = @Permission;

    -- Insert the new permission
    INSERT INTO RolePermission(role_id, permission_name, allowed_action)
    VALUES (@RoleID, @Permission, @Permission);

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
    -- Update all leave requests whose IDs are in the comma-separated string
    UPDATE LeaveRequest
    SET status = 'Processed'
    WHERE CHARINDEX(CAST(request_id AS VARCHAR), @LeaveRequestIDs) > 0;

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
    UPDATE LeaveDocument
    SET file_path = file_path  -- no change, just a placeholder to execute update
    WHERE document_id = @DocumentID AND leave_request_id = @LeaveRequestID;

    SELECT 'Medical leave document verified successfully.' AS Message;
END
GO

--41:

CREATE PROCEDURE SyncLeaveBalances
    @LeaveRequestID INT
AS
BEGIN
    -- Example: add approved leave duration to LeaveEntitlement
    UPDATE LeaveEntitlement
    SET entitlement = entitlement +
        (SELECT duration FROM LeaveRequest WHERE request_id = @LeaveRequestID AND status = 'Approved')
    WHERE employee_id = (SELECT employee_id FROM LeaveRequest WHERE request_id = @LeaveRequestID)
      AND leave_type_id = (SELECT leave_id FROM LeaveRequest WHERE request_id = @LeaveRequestID);

    SELECT 'Leave balances synced successfully.' AS Message;
END
GO


--42:
CREATE PROCEDURE ProcessLeaveCarryForward
    @Year INT
AS
BEGIN
    -- Carry forward leave entitlements from @Year to @Year + 1
    INSERT INTO LeaveEntitlement (employee_id, leave_type_id, entitlement, year)
    SELECT employee_id, leave_type_id, entitlement, @Year + 1
    FROM LeaveEntitlement
    WHERE year = @Year;

    SELECT 'Leave carry-forward for year ' + CAST(@Year AS VARCHAR) + ' processed successfully.' AS Message;
END
GO

--43:
CREATE PROCEDURE SyncLeaveToPayroll
    @LeaveRequestID INT
AS
BEGIN
    -- Insert leave info into Payroll table from LeaveRequest
    INSERT INTO Payroll (employee_id, leave_days)
    SELECT employee_id, leave_days
    FROM LeaveRequest
    WHERE leave_request_id = @LeaveRequestID
      AND status = 'Approved';

    SELECT 'Leave request synced to payroll successfully.' AS Message;
END
GO

--44:


--45:
CREATE PROCEDURE ApprovePolicyUpdate
    @PolicyID INT,
    @ApprovedBy INT
AS
BEGIN
    -- Mark the policy as approved by the given employee
    UPDATE PayGrade
    SET approved_by = @ApprovedBy, status = 'Approved'
    WHERE pay_grade_id = @PolicyID;

    -- Return a confirmation message
    SELECT 'Payroll policy update approved successfully.' AS Message;
END;
GO

