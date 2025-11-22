-- =============================================
-- File: 03_leave.sql
-- Project: HRMS_DB - Milestone 2

-- Purpose: Leave types, leave policies, leave requests,
--          entitlements, leave documents

-- Dependencies: 01_core_hr.sql, 02_contracts_missions.sql
-- Run order: Schema step 3
-- =============================================

USE HRMS_DB;
GO

CREATE TABLE Leave (
    leave_id INT IDENTITY(1,1) PRIMARY KEY,
    leave_type VARCHAR(60) NOT NULL,
    leave_description VARCHAR(480)
);
GO

CREATE TABLE VacationLeave (
    leave_id INT PRIMARY KEY,
    carry_over_days INT,
    approving_manager INT,
    FOREIGN KEY (leave_id) REFERENCES Leave(leave_id)
);
GO

CREATE TABLE SickLeave (
    leave_id INT PRIMARY KEY,
    medical_cert_required BIT,
    physician_id INT,
    FOREIGN KEY (leave_id) REFERENCES Leave(leave_id)
);
GO


CREATE TABLE ProbationLeave (
    leave_id INT PRIMARY KEY,
    eligibility_start_date DATE,
    probation_period INT,
    FOREIGN KEY (leave_id) REFERENCES Leave(leave_id)
);
GO

CREATE TABLE HolidayLeave (
    leave_id INT PRIMARY KEY,
    holiday_name VARCHAR(90),
    official_recognition BIT,
    regional_scope VARCHAR(89),
    FOREIGN KEY (leave_id) REFERENCES Leave(leave_id)
);
GO

CREATE TABLE LeavePolicy (
    policy_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100),
    purpose VARCHAR(500),
    eligibility_rules VARCHAR(500),
    notice_period INT,
    special_leave_type VARCHAR(50),
    reset_on_new_year BIT
);
GO

CREATE TABLE LeaveRequest (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT,
    leave_id INT,
    justification VARCHAR(700),
    duration INT,
    approval_timing DATETIME,
    status VARCHAR(60) DEFAULT 'Pending',
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (leave_id) REFERENCES Leave(leave_id)
);
GO

CREATE TABLE LeaveEntitlement (
    employee_id INT,
    leave_type_id INT,
    entitlement DECIMAL(8,3),
    PRIMARY KEY (employee_id, leave_type_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (leave_type_id) REFERENCES Leave(leave_id)
);
GO

CREATE TABLE LeaveDocument (
    document_id INT IDENTITY(1,1) PRIMARY KEY,
    leave_request_id INT,
    file_path VARCHAR(255),
    uploaded_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (leave_request_id) REFERENCES LeaveRequest(request_id)
);
GO