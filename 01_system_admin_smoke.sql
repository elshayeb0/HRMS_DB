USE HRMS_DB;
GO

PRINT '========== SYSTEM ADMIN PROCEDURES SMOKE TEST ==========';

---------------------------------------------------------
-- BASIC TEST CONTEXT
---------------------------------------------------------
DECLARE @Today DATE = '2024-12-01';   -- fixed date to avoid DATEADD issues

-- from your data
DECLARE @TestEmployeeID      INT = 2;   -- Sarah Johnson
DECLARE @AnotherEmployeeID   INT = 3;   -- Ahmed Hassan
DECLARE @ManagerID           INT = 1;   -- John Smith (CEO)
DECLARE @DeptID              INT = 2;   -- Human Resources

-- lookup from existing data (may be NULL if tables are empty)
DECLARE @ShiftID             INT;
DECLARE @ShiftAssignmentID   INT;
DECLARE @AttendanceID        INT;
DECLARE @HolidayID           INT;
DECLARE @DeviceID            INT;

SET @ShiftID           = (SELECT TOP 1 shift_id        FROM ShiftSchedule);
SET @ShiftAssignmentID = (SELECT TOP 1 assignment_id   FROM ShiftAssignment);
SET @AttendanceID      = (SELECT TOP 1 attendance_id   FROM Attendance);
SET @HolidayID         = (SELECT TOP 1 exception_id    FROM [Exception]);
SET @DeviceID          = (SELECT TOP 1 device_id       FROM Device);




---------------------------------------------------------
-- 1) ViewEmployeeInfo
---------------------------------------------------------
PRINT '1) ViewEmployeeInfo';
EXEC ViewEmployeeInfo
    @EmployeeID = @TestEmployeeID;
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 2) AddEmployee
---------------------------------------------------------
PRINT '2) AddEmployee';
EXEC AddEmployee
    @FullName               = 'Smoke Test User',
    @NationalID             = 'SMOKE123',
    @DateOfBirth            = '1990-01-01',
    @CountryOfBirth         = 'Testland',
    @Phone                  = '+000-000-0000',
    @Email                  = 'smoke.user@company.com',
    @Address                = '123 Test Street',
    @EmergencyContactName   = 'Test Contact',
    @EmergencyContactPhone  = '+000-000-0001',
    @Relationship           = 'Friend',
    @Biography              = 'Smoke test employee.',
    @EmploymentProgress     = 'In Progress',
    @AccountStatus          = 'Active',
    @EmploymentStatus       = 'Active',
    @HireDate               = @Today,
    @IsActive               = 1,
    @ProfileCompletion      = 50,
    @DepartmentID           = 1,
    @PositionID             = 1,
    @ManagerID              = @ManagerID,
    @ContractID             = NULL,
    @TaxFormID              = 1,
    @SalaryTypeID           = 1,
    @PayGrade               = '1';   -- PayGrade is VARCHAR(50) param
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 3) UpdateEmployeeInfo
---------------------------------------------------------
PRINT '3) UpdateEmployeeInfo';
EXEC UpdateEmployeeInfo
    @EmployeeID = @TestEmployeeID,
    @Email      = 'updated.sarah.johnson@company.com',
    @Phone      = '+1-555-0299',
    @Address    = 'Updated HR address';
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 4) AssignRole
---------------------------------------------------------
PRINT '4) AssignRole';
EXEC AssignRole
    @EmployeeID = @TestEmployeeID,
    @RoleID     = 2;   -- HR Admin
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 5) GetDepartmentEmployeeStats
---------------------------------------------------------
PRINT '5) GetDepartmentEmployeeStats';
EXEC GetDepartmentEmployeeStats;
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 6) ReassignManager
---------------------------------------------------------
PRINT '6) ReassignManager';
EXEC ReassignManager
    @EmployeeID   = @AnotherEmployeeID,
    @NewManagerID = @ManagerID;
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 7) ReassignHierarchy
---------------------------------------------------------
PRINT '7) ReassignHierarchy';
EXEC ReassignHierarchy
    @EmployeeID       = @AnotherEmployeeID,
    @NewDepartmentID  = @DeptID,
    @NewManagerID     = @ManagerID;
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 8) NotifyStructureChange
---------------------------------------------------------
PRINT '8) NotifyStructureChange';
EXEC NotifyStructureChange
    @AffectedEmployees = '2,3,4',
    @Message           = 'Org structure updated in smoke test.';
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 9) ViewOrgHierarchy
---------------------------------------------------------
PRINT '9) ViewOrgHierarchy';
EXEC ViewOrgHierarchy;
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 10) AssignShiftToEmployee
---------------------------------------------------------
PRINT '10) AssignShiftToEmployee';
EXEC AssignShiftToEmployee
    @EmployeeID = @TestEmployeeID,
    @ShiftID    = @ShiftID,
    @StartDate  = '2024-12-01',
    @EndDate    = '2024-12-07';
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 11) UpdateShiftStatus
---------------------------------------------------------
PRINT '11) UpdateShiftStatus';
EXEC UpdateShiftStatus
    @ShiftAssignmentID = @ShiftAssignmentID,
    @Status            = 'Approved';
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 12) AssignShiftToDepartment
---------------------------------------------------------
PRINT '12) AssignShiftToDepartment';
EXEC AssignShiftToDepartment
    @DepartmentID = @DeptID,
    @ShiftID      = @ShiftID,
    @StartDate    = '2024-12-01',
    @EndDate      = '2024-12-14';
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 13) AssignCustomShift
---------------------------------------------------------
PRINT '13) AssignCustomShift';
EXEC AssignCustomShift
    @EmployeeID = @TestEmployeeID,
    @ShiftName  = 'Custom Smoke Shift',
    @ShiftType  = 'Custom',
    @StartTime  = '09:00',
    @EndTime    = '17:00',
    @StartDate  = '2024-12-05',
    @EndDate    = '2024-12-07';
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 14) ConfigureSplitShift
---------------------------------------------------------
PRINT '14) ConfigureSplitShift';
EXEC ConfigureSplitShift
    @ShiftName       = 'Split Smoke Shift',
    @FirstSlotStart  = '09:00',
    @FirstSlotEnd    = '12:00',
    @SecondSlotStart = '13:00',
    @SecondSlotEnd   = '17:00';
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 15) EnableFirstInLastOut
---------------------------------------------------------
PRINT '15) EnableFirstInLastOut';
EXEC EnableFirstInLastOut @Enable = 1;
EXEC EnableFirstInLastOut @Enable = 0;
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 16) TagAttendanceSource
---------------------------------------------------------
PRINT '16) TagAttendanceSource';
EXEC TagAttendanceSource
    @AttendanceID = @AttendanceID,
    @SourceType   = 'Device',
    @DeviceID     = @DeviceID,
    @Latitude     = 30.0444200,
    @Longitude    = 31.2357120;
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 17) SyncOfflineAttendance


---------------------------------------------------------
-- 18) LogAttendanceEdit
---------------------------------------------------------


---------------------------------------------------------
-- 19) ApplyHolidayOverrides
---------------------------------------------------------
PRINT '19) ApplyHolidayOverrides';
EXEC ApplyHolidayOverrides
    @HolidayID  = @HolidayID,
    @EmployeeID = @TestEmployeeID;
PRINT '--------------------------------------------------';

---------------------------------------------------------
-- 20) ManageUserAccounts
---------------------------------------------------------
PRINT '20) ManageUserAccounts - ADD then REMOVE Payroll Specialist';
EXEC ManageUserAccounts
    @UserID = @TestEmployeeID,
    @Role   = 'Payroll Specialist',
    @Action = 'ADD';

EXEC ManageUserAccounts
    @UserID = @TestEmployeeID,
    @Role   = 'Payroll Specialist',
    @Action = 'REMOVE';
PRINT '--------------------------------------------------';

PRINT '========== END SYSTEM ADMIN PROCEDURES SMOKE TEST ==========';