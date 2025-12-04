USE HRMS_DB;
GO

-- 1. ViewEmployeeInfo: Return the full employee record for a given ID.

CREATE PROCEDURE ViewEmployeeInfo
    @EmployeeID INT
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE employee_id = @EmployeeID;
END;
GO

-- 2. AddEmployee: Insert a new employee and return the generated ID.


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

-- 3. UpdateEmployeeInfo: Update contact details for an employee.

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

-- 4. AssignRole: Attach a role to an employee if not already assigned.

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

-- 5. GetDepartmentEmployeeStats: Return employee counts per department.

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

-- 6. ReassignManager: Update an employee's manager link.

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

-- 7. ReassignHierarchy: Change both department and manager for an employee.

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

-- 8. NotifyStructureChange: Broadcast a structure-change notification to a list of employees.

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

-- 9. ViewOrgHierarchy: Display employees with manager, department, and position context.

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

-- 10. AssignShiftToEmployee: Assign an existing shift to a specific employee for a date range.

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
GO

-- 11. UpdateShiftStatus: Update the status of a shift assignment.

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

-- 12. AssignShiftToDepartment: Assign one shift to every employee in a department.

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

-- 13. AssignCustomShift: Create a shift and assign it to a single employee.

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

-- 14. ConfigureSplitShift: Create two back-to-back shift slots under one name.

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

-- 15. EnableFirstInLastOut: Toggle messaging for first-in/last-out attendance handling.

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

-- 16. TagAttendanceSource: Record where an attendance punch originated.

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

-- 17. SyncOfflineAttendance: Insert offline punches and their capture source.

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

-- 18. LogAttendanceEdit: Record an attendance edit with before/after values.

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


-- 19. ApplyHolidayOverrides: Link an employee to a holiday exception entry.

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

-- 20. ManageUserAccounts: Add or remove a role for an employee account.

CREATE PROCEDURE ManageUserAccounts
    @UserID INT,
    @Role VARCHAR(50),
    @Action VARCHAR(20)
AS
BEGIN
    DECLARE @RoleID INT;

    SELECT @RoleID = role_id FROM Role WHERE role_name = @Role;

    -- CRITICAL FIX: Check if role exists
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
