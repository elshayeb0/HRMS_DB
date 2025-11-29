USE HRMS_DB;
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
