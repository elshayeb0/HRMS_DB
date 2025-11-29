USE HRMS_DB;
GO

-- =============================================
-- Stored Procedure: SubmitLeaveRequest
-- Description: Submits a leave request for an employee
-- =============================================

CREATE PROCEDURE SubmitLeaveRequest
    @EmployeeID INT,
    @LeaveTypeID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Reason VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert leave request with calculated duration
    INSERT INTO LeaveRequest (employee_id, leave_id, justification, duration, approval_timing, status)
    VALUES (@EmployeeID, @LeaveTypeID, @Reason, DATEDIFF(DAY, @StartDate, @EndDate) + 1, GETDATE(), 'Pending');

    -- Confirmation message
    PRINT 'Leave request submitted successfully.';
END;
GO


-- =============================================


CREATE PROCEDURE GetLeaveBalance
    @EmployeeID INT
AS
BEGIN
    -- Get all leave entitlements for this employee
    SELECT
        l.leave_type AS 'Leave Type',
        le.entitlement AS 'Remaining Days'
    FROM LeaveEntitlement le
    INNER JOIN Leave l ON le.leave_type_id = l.leave_id
    WHERE le.employee_id = @EmployeeID;
END
GO

-- =============================================


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

-- =============================================


CREATE PROCEDURE SubmitReimbursement
    @EmployeeID INT,
    @ExpenseType VARCHAR(50),
    @Amount DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Reimbursement (employee_id, type, claim_type, current_status)
    VALUES (@EmployeeID, @ExpenseType, @ExpenseType, 'Pending');

    SELECT 'Reimbursement request submitted successfully' AS ConfirmationMessage;
END;
GO

-- =============================================



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

-- =============================================



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


-- =============================================


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

-- =============================================

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

-- =============================================

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

-- =============================================

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

-- =============================================

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

-- =============================================

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

-- =============================================
-- NEED TO BE CHECKED

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

-- =============================================

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

-- =============================================

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

-- =============================================

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

-- ============================================

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

    -- =============================================

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

-- =============================================


CREATE PROCEDURE RecordMultiplePunches
    @EmployeeID INT,
    @ClockInOutTime DATETIME,
    @Type VARCHAR(10)
AS
BEGIN
    -- Clock IN: Create a new attendance record
    IF @Type = 'IN'
    BEGIN
        INSERT INTO Attendance (employee_id, entry_time)
        VALUES (@EmployeeID, @ClockInOutTime);

        SELECT 'Clocked In Successfully';
    END

    -- Clock OUT: Update the last open attendance record
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


-- ================================================

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

-- ================================================

CREATE PROCEDURE ViewRequestStatus
    @EmployeeID INT
AS
BEGIN
    -- Get all correction requests for this employee
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

-- ================================================

CREATE PROCEDURE AttachLeaveDocuments
    @LeaveRequestID INT,
    @FilePath VARCHAR(200)
AS
BEGIN
    -- Insert the document into LeaveDocument table
    INSERT INTO LeaveDocument (leave_request_id, file_path)
    VALUES (@LeaveRequestID, @FilePath);

    -- Confirmation message
    SELECT 'Document attached successfully' AS Message;
END
GO

-- ================================================

CREATE PROCEDURE ModifyLeaveRequest
    @LeaveRequestID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Reason VARCHAR(100)
AS
BEGIN
    -- Calculate the duration in days
    DECLARE @Duration INT;
    SET @Duration = DATEDIFF(DAY, @StartDate, @EndDate) + 1;

    -- Update the leave request
    UPDATE LeaveRequest
    SET justification = @Reason,
        duration = @Duration
    WHERE request_id = @LeaveRequestID;

    -- Confirmation message
    SELECT 'Leave request modified successfully' AS Message;
END
GO

-- ================================================

CREATE PROCEDURE CancelLeaveRequest
    @LeaveRequestID INT
AS
BEGIN
    -- Update the status to Cancelled
    UPDATE LeaveRequest
    SET status = 'Cancelled'
    WHERE request_id = @LeaveRequestID;

    -- Confirmation message
    SELECT 'Leave request cancelled successfully' AS Message;
END
GO

-- ================================================

CREATE PROCEDURE ViewLeaveBalance
    @EmployeeID INT
AS
BEGIN
    -- Get all leave entitlements for this employee
    SELECT
        l.leave_type AS 'Leave Type',
        le.entitlement AS 'Remaining Days'
    FROM LeaveEntitlement le
    INNER JOIN Leave l ON le.leave_type_id = l.leave_id
    WHERE le.employee_id = @EmployeeID;
END
GO

--================================================

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

-- ================================================

CREATE PROCEDURE SubmitLeaveAfterAbsence
    @EmployeeID INT,
    @LeaveTypeID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Reason VARCHAR(100)
AS
BEGIN
    -- Calculate the duration in days
    DECLARE @Duration INT;
    SET @Duration = DATEDIFF(DAY, @StartDate, @EndDate) + 1;

    -- Insert the leave request
    INSERT INTO LeaveRequest (employee_id, leave_id, justification, duration, status)
    VALUES (@EmployeeID, @LeaveTypeID, @Reason, @Duration, 'Pending');

    -- Confirmation message
    SELECT 'Leave request submitted successfully' AS Message;
END
GO

--==============================================

CREATE PROCEDURE NotifyLeaveStatusChange
    @EmployeeID INT,
    @RequestID INT,
    @Status VARCHAR(20)
AS
BEGIN
    -- Create the notification message based on status
    DECLARE @Message VARCHAR(500);
    SET @Message = 'Your leave request #' + CAST(@RequestID AS VARCHAR(10)) + ' has been ' + @Status;

    -- Insert notification into Notification table
    INSERT INTO Notification (message_content, urgency, notification_type)
    VALUES (@Message, 'Medium', 'Leave Status');

    DECLARE @NotificationID INT;
    SET @NotificationID = SCOPE_IDENTITY();

    -- Link notification to employee
    INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status, delivered_at)
    VALUES (@EmployeeID, @NotificationID, 'Sent', GETDATE());

    -- Output the notification message
    SELECT @Message AS 'Notification';
END
GO
