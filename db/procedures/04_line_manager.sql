USE HRMS_DB;
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