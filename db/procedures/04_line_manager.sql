-- =============================================
-- File: 04_line_manager.sql
-- Author: Ziad Elshayeb
-- Project: HRMS_DB - Milestone 2

-- Purpose: Stored procedures for "As a Line Manager" user stories

-- Note: Names must match the Milestone 2 specification exactly
-- =============================================

USE HRMS_DB;
GO

-- =============================================
-- Procedure: 1) ReviewLeaveRequest
-- Purpose : Approve or deny a leave request
-- =============================================
CREATE PROCEDURE ReviewLeaveRequest
    @LeaveRequestID INT,
    @ManagerID INT,
    @Decision VARCHAR(20)
AS
BEGIN
    UPDATE LeaveRequest
    SET
        ManagerID = @ManagerID,
        Decision = @Decision
    WHERE LeaveRequestID = @LeaveRequestID;

    SELECT
        @LeaveRequestID AS LeaveRequestID,
        @ManagerID AS ManagerID,
        @Decision AS Decision;
END;
GO

-- =============================================
-- Procedure: 2) AssignShift
-- Purpose : Assign an employee to a work shift
-- =============================================
CREATE PROCEDURE AssignShift
    @EmployeeID INT,
    @ShiftID INT
AS
BEGIN
    INSERT INTO EmployeeShift (EmployeeID, ShiftID)
    VALUES (@EmployeeID, @ShiftID);

    SELECT 'Shift assigned successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 3) ViewTeamAttendance
-- Purpose : View attendance summary of team members for a given manager and date range
-- =============================================
CREATE PROCEDURE ViewTeamAttendance
    @ManagerID INT,
    @DateRangeStart DATE,
    @DateRangeEnd DATE
AS
BEGIN
    SELECT
        A.attendance_id AS AttendanceID,
        A.employee_id AS EmployeeID,
        E.full_name AS EmployeeName,
        A.shift_id AS ShiftID,
        A.entry_time AS EntryTime,
        A.exit_time AS ExitTime,
        A.duration AS Duration,
        A.login_method AS LoginMethod,
        A.logout_method AS LogoutMethod,
        A.exception_id AS ExceptionID
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

-- =============================================
-- Procedure: 4) SendTeamNotification
-- Purpose : Send a notification to all team members under a manager
-- =============================================
CREATE PROCEDURE SendTeamNotification
    @ManagerID INT,
    @MessageContent VARCHAR(255),
    @UrgencyLevel VARCHAR(50)
AS
BEGIN
    INSERT INTO Notification (EmployeeID, ManagerID, MessageContent, UrgencyLevel, SentAt)
    SELECT
        E.employee_id,
        @ManagerID,
        @MessageContent,
        @UrgencyLevel,
        GETDATE()
    FROM Employee AS E
    WHERE E.manager_id = @ManagerID;

    SELECT 'Notification sent successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 5) ApproveMissionCompletion
-- Purpose : Approve completion of a mission assigned to an employee
-- =============================================
CREATE PROCEDURE ApproveMissionCompletion
    @MissionID INT,
    @ManagerID INT,
    @Remarks VARCHAR(200)
AS
BEGIN
    UPDATE Mission
    SET
        ManagerID = @ManagerID,
        CompletionRemarks = @Remarks,
        CompletionStatus = 'Approved',
        CompletionDate = GETDATE()
    WHERE MissionID = @MissionID;

    SELECT 'Mission completion approved successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 6) RequestReplacement
-- Purpose : Request a replacement for an unavailable employee
-- =============================================
CREATE PROCEDURE RequestReplacement
    @EmployeeID INT,
    @Reason VARCHAR(150)
AS
BEGIN
    INSERT INTO ReplacementRequest (EmployeeID, Reason, RequestDate, Status)
    VALUES (@EmployeeID, @Reason, GETDATE(), 'Pending');

    SELECT 'Replacement request submitted successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 7) ViewDepartmentSummary
-- Purpose : Retrieve department summary including active projects
-- =============================================
CREATE PROCEDURE ViewDepartmentSummary
    @DepartmentID INT
AS
BEGIN
    SELECT
        D.department_id AS DepartmentID,
        D.department_name AS DepartmentName,
        COUNT(DISTINCT E.employee_id) AS EmployeeCount,
        COUNT(DISTINCT M.mission_id) AS ActiveProjects
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

-- =============================================
-- Procedure: 8) ReassignShift
-- Purpose : Reassign a shift for an employee
-- =============================================
CREATE PROCEDURE ReassignShift
    @EmployeeID INT,
    @OldShiftID INT,
    @NewShiftID INT
AS
BEGIN
    UPDATE EmployeeShift
    SET ShiftID = @NewShiftID
    WHERE EmployeeID = @EmployeeID
      AND ShiftID = @OldShiftID;

    SELECT 'Shift reassigned successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 9) GetPendingLeaveRequests
-- Purpose : Retrieve list of pending leave requests for a manager
-- =============================================
CREATE PROCEDURE GetPendingLeaveRequests
    @ManagerID INT
AS
BEGIN
    SELECT
        L.LeaveRequestID,
        L.EmployeeID,
        E.full_name AS EmployeeName,
        L.StartDate,
        L.EndDate,
        L.Reason,
        L.Decision
    FROM LeaveRequest AS L
    INNER JOIN Employee AS E
        ON L.EmployeeID = E.employee_id
    WHERE E.manager_id = @ManagerID
      AND L.Decision = 'Pending'
    ORDER BY L.StartDate;
END;
GO
-- =============================================
-- Procedure: 10) GetTeamStatistics
-- Purpose : View team-level statistics and reporting metrics
-- =============================================
CREATE PROCEDURE GetTeamStatistics
    @ManagerID INT
AS
BEGIN
    SELECT
        @ManagerID AS ManagerID,
        COUNT(DISTINCT E.employee_id) AS TeamSize,
        AVG(E.salary) AS AverageSalary,
        COUNT(DISTINCT E.employee_id) AS SpanOfControl
    FROM Employee AS E
    WHERE E.manager_id = @ManagerID;
END;
GO

-- =============================================
-- Procedure: 11) ViewTeamProfiles
-- Purpose : View basic profiles of team members (excluding sensitive data)
-- =============================================
CREATE PROCEDURE ViewTeamProfiles
    @ManagerID INT
AS
BEGIN
    SELECT
        E.employee_id AS EmployeeID,
        E.full_name AS FullName,
        E.position_id AS PositionID,
        E.department_id AS DepartmentID,
        E.hire_date AS HireDate,
        E.employment_state AS EmploymentState
    FROM Employee AS E
    WHERE E.manager_id = @ManagerID
    ORDER BY E.full_name;
END;
GO

-- =============================================
-- Procedure: 12) GetTeamSummary
-- Purpose : View summary of team (roles, tenure, departments)
-- =============================================
CREATE PROCEDURE GetTeamSummary
    @ManagerID INT
AS
BEGIN
    SELECT
        E.position_id AS PositionID,
        E.department_id AS DepartmentID,
        COUNT(*) AS EmployeeCount,
        AVG(DATEDIFF(YEAR, E.hire_date, GETDATE())) AS AverageTenureYears
    FROM Employee AS E
    WHERE E.manager_id = @ManagerID
    GROUP BY
        E.position_id,
        E.department_id;
END;
GO

-- =============================================
-- Procedure: 13) FilterTeamProfiles
-- Purpose : Filter team members by skill or role
-- =============================================
CREATE PROCEDURE FilterTeamProfiles
    @ManagerID INT,
    @Skill VARCHAR(50),
    @RoleID INT
AS
BEGIN
    SELECT
        E.employee_id AS EmployeeID,
        E.full_name AS FullName,
        E.position_id AS PositionID,
        E.department_id AS DepartmentID
    FROM Employee AS E
    LEFT JOIN EmployeeSkill AS ES
        ON ES.employee_id = E.employee_id
    WHERE E.manager_id = @ManagerID
      AND (ES.skill_name = @Skill OR E.position_id = @RoleID)
    ORDER BY E.full_name;
END;
GO

-- =============================================
-- Procedure: 14) ViewTeamCertifications
-- Purpose : View certifications and skills of team members
-- =============================================
CREATE PROCEDURE ViewTeamCertifications
    @ManagerID INT
AS
BEGIN
    SELECT
        E.employee_id AS EmployeeID,
        E.full_name AS FullName,
        ES.skill_name AS SkillName,
        C.certification_name AS CertificationName,
        EC.certification_date AS CertificationDate
    FROM Employee AS E
    LEFT JOIN EmployeeSkill AS ES
        ON ES.employee_id = E.employee_id
    LEFT JOIN EmployeeCertification AS EC
        ON EC.employee_id = E.employee_id
    LEFT JOIN Certification AS C
        ON C.certification_id = EC.certification_id
    WHERE E.manager_id = @ManagerID
    ORDER BY
        E.full_name,
        ES.skill_name,
        C.certification_name;
END;
GO

-- =============================================
-- Procedure: 15) AddManagerNotes
-- Purpose : Add manager-specific notes (visible only to HR)
-- =============================================
CREATE PROCEDURE AddManagerNotes
    @EmployeeID INT,
    @ManagerID INT,
    @Note VARCHAR(500)
AS
BEGIN
    INSERT INTO ManagerNotes (EmployeeID, ManagerID, NoteContent, NoteDate)
    VALUES (@EmployeeID, @ManagerID, @Note, GETDATE());

    SELECT 'Manager note added successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 16) RecordManualAttendance
-- Purpose : Record attendance manually with an audit trail for missing punches
-- =============================================
CREATE PROCEDURE RecordManualAttendance
    @EmployeeID INT,
    @Date DATE,
    @ClockIn TIME,
    @ClockOut TIME,
    @Reason VARCHAR(200),
    @RecordedBy INT
AS
BEGIN
    DECLARE @EntryTime DATETIME;
    DECLARE @ExitTime DATETIME;
    DECLARE @Duration INT;
    DECLARE @AttendanceID INT;

    -- Build full entry and exit datetime values from date and time
    SET @EntryTime = CAST(@Date AS DATETIME) + CAST(@ClockIn AS DATETIME);
    SET @ExitTime  = CAST(@Date AS DATETIME) + CAST(@ClockOut AS DATETIME);

    -- Calculate duration in minutes
    SET @Duration = DATEDIFF(MINUTE, @EntryTime, @ExitTime);

    -- Insert the manual attendance record
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

    -- Get the generated attendance_id for audit trail
    SET @AttendanceID = SCOPE_IDENTITY();

    -- Insert into AttendanceLog to keep an audit trail
    INSERT INTO AttendanceLog (attendance_id, actor, timestamp, reason)
    VALUES (@AttendanceID, @RecordedBy, GETDATE(), @Reason);

    SELECT 'Manual attendance recorded successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 17) ReviewMissedPunches
-- Purpose : View automatically flagged missed punches for team members
-- =============================================
CREATE PROCEDURE ReviewMissedPunches
    @ManagerID INT,
    @Date DATE
AS
BEGIN
    SELECT
        A.attendance_id AS AttendanceID,
        A.employee_id AS EmployeeID,
        E.full_name AS EmployeeName,
        A.entry_time AS EntryTime,
        A.exit_time AS ExitTime,
        A.login_method AS LoginMethod,
        A.logout_method AS LogoutMethod,
        A.exception_id AS ExceptionID
    FROM Attendance AS A
    INNER JOIN Employee AS E
        ON A.employee_id = E.employee_id
    INNER JOIN AttendanceException AS EX
        ON EX.exception_id = A.exception_id
    WHERE E.manager_id = @ManagerID
      AND CAST(A.entry_time AS DATE) = @Date
      AND EX.exception_type = 'Missed Punch'
    ORDER BY A.entry_time;
END;
GO

-- =============================================
-- Procedure: 18) ApproveTimeRequest
-- Purpose : Approve or reject time management requests
-- =============================================
CREATE PROCEDURE ApproveTimeRequest
    @RequestID INT,
    @ManagerID INT,
    @Decision VARCHAR(20),
    @Comments VARCHAR(200)
AS
BEGIN
    UPDATE TimeRequest
    SET
        ManagerID = @ManagerID,
        Decision = @Decision,
        Comments = @Comments,
        DecisionDate = GETDATE()
    WHERE RequestID = @RequestID;

    SELECT 'Time management request processed successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 19) GetLeaveRequestDetails
-- Purpose : Review leave request assigned to a manager (view details only)

-- Note    : Implements user story 19 (named ReviewLeaveRequest in spec),
--           but uses a unique procedure name to avoid conflict with procedure 1.
-- =============================================
CREATE PROCEDURE GetLeaveRequestDetails
    @LeaveRequestID INT,
    @ManagerID INT
AS
BEGIN
    SELECT
        L.LeaveRequestID,
        L.EmployeeID,
        E.full_name AS EmployeeName,
        L.StartDate,
        L.EndDate,
        L.Reason,
        L.Decision
    FROM LeaveRequest AS L
    INNER JOIN Employee AS E
        ON L.EmployeeID = E.employee_id
    WHERE
        L.LeaveRequestID = @LeaveRequestID
        AND E.manager_id = @ManagerID;
END;
GO

-- =============================================
-- Procedure: 20) ApproveLeaveRequest
-- Purpose : Approve a leave request assigned to a manager
-- =============================================
CREATE PROCEDURE ApproveLeaveRequest
    @LeaveRequestID INT,
    @ManagerID INT
AS
BEGIN
    UPDATE LeaveRequest
    SET
        Decision = 'Approved',
        ManagerID = @ManagerID,
        DecisionDate = GETDATE()
    WHERE LeaveRequestID = @LeaveRequestID;

    SELECT 'Leave request approved successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 21) RejectLeaveRequest
-- Purpose : Reject a leave request assigned to a manager
-- =============================================
CREATE PROCEDURE RejectLeaveRequest
    @LeaveRequestID INT,
    @ManagerID INT,
    @Reason VARCHAR(200)
AS
BEGIN
    UPDATE LeaveRequest
    SET
        Decision = 'Rejected',
        ManagerID = @ManagerID,
        Comments = @Reason,
        DecisionDate = GETDATE()
    WHERE LeaveRequestID = @LeaveRequestID;

    SELECT 'Leave request rejected successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 22) DelegateLeaveApproval
-- Purpose : Delegate leave approval authority to another manager
-- =============================================
CREATE PROCEDURE DelegateLeaveApproval
    @ManagerID INT,
    @DelegateID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    INSERT INTO LeaveApprovalDelegation (
        ManagerID,
        DelegateID,
        StartDate,
        EndDate
    )
    VALUES (
        @ManagerID,
        @DelegateID,
        @StartDate,
        @EndDate
    );

    SELECT 'Leave approval authority delegated successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 23) FlagIrregularLeave
-- Purpose : Flag irregular leave patterns in team members
-- =============================================
CREATE PROCEDURE FlagIrregularLeave
    @EmployeeID INT,
    @ManagerID INT,
    @PatternDescription VARCHAR(200)
AS
BEGIN
    INSERT INTO ManagerNotes (EmployeeID, ManagerID, NoteContent, NoteDate)
    VALUES (@EmployeeID, @ManagerID, @PatternDescription, GETDATE());

    SELECT 'Irregular leave pattern flagged successfully.' AS Message;
END;
GO

-- =============================================
-- Procedure: 24) NotifyNewLeaveRequest
-- Purpose : Receive notification when a new leave request is assigned to a manager
-- =============================================
CREATE PROCEDURE NotifyNewLeaveRequest
    @ManagerID INT,
    @RequestID INT
AS
BEGIN
    DECLARE @MessageContent VARCHAR(255);

    SET @MessageContent = 'New leave request assigned. Request ID: ' + CAST(@RequestID AS VARCHAR(20));

    INSERT INTO Notification (EmployeeID, ManagerID, MessageContent, UrgencyLevel, SentAt)
    VALUES (
        NULL,
        @ManagerID,
        @MessageContent,
        'Normal',
        GETDATE()
    );

    SELECT @MessageContent AS NotificationMessage;
END;
GO