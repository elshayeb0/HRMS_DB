-- Leave management schema: leave types, policies, requests, and supporting documents.
USE HRMS_DB;
GO

-- Base leave types.
CREATE TABLE Leave ( -- master leave types
    leave_id INT IDENTITY(1,1) PRIMARY KEY, -- unique leave type id
    leave_type VARCHAR(60) NOT NULL, -- display name of the leave type
    leave_description VARCHAR(480) -- description of when to use it
);
GO -- complete Leave definition

-- Vacation-specific attributes.
CREATE TABLE VacationLeave ( -- attributes attached to vacation leave
    leave_id INT PRIMARY KEY, -- PK/FK to Leave
    carry_over_days INT, -- allowed carry-over days
    approving_manager INT, -- manager responsible for approval
    FOREIGN KEY (leave_id) REFERENCES Leave(leave_id) -- enforce leave type existence
);
GO -- complete VacationLeave definition

-- Sick leave with medical documentation requirements.
CREATE TABLE SickLeave ( -- sick leave specialization
    leave_id INT PRIMARY KEY, -- PK/FK to Leave
    medical_cert_required BIT, -- flag for required medical certificate
    physician_id INT, -- optional physician reference
    FOREIGN KEY (leave_id) REFERENCES Leave(leave_id) -- enforce leave type existence
);
GO -- complete SickLeave definition


-- Probation leave eligibility window.
CREATE TABLE ProbationLeave ( -- probationary leave specialization
    leave_id INT PRIMARY KEY, -- PK/FK to Leave
    eligibility_start_date DATE, -- eligibility start date
    probation_period INT, -- length of probation in days or months
    FOREIGN KEY (leave_id) REFERENCES Leave(leave_id) -- enforce leave type existence
);
GO -- complete ProbationLeave definition

-- Holiday leave tied to recognized occasions.
CREATE TABLE HolidayLeave ( -- holiday leave specialization
    leave_id INT PRIMARY KEY, -- PK/FK to Leave
    holiday_name VARCHAR(90), -- referenced holiday name
    official_recognition BIT, -- whether officially recognized
    regional_scope VARCHAR(89), -- region where holiday applies
    FOREIGN KEY (leave_id) REFERENCES Leave(leave_id) -- enforce leave type existence
);
GO -- complete HolidayLeave definition

-- Policy definitions that govern leave usage.
CREATE TABLE LeavePolicy ( -- policy metadata
    policy_id INT IDENTITY(1,1) PRIMARY KEY, -- unique policy id
    name VARCHAR(100), -- policy name
    purpose VARCHAR(500), -- policy rationale
    eligibility_rules VARCHAR(500), -- who is eligible
    notice_period INT, -- required notice in days
    special_leave_type VARCHAR(50), -- targeted leave type if any
    reset_on_new_year BIT -- flag to reset entitlement yearly
);
GO -- complete LeavePolicy definition

-- Requests submitted by employees against leave types.
CREATE TABLE LeaveRequest ( -- employee leave requests
    request_id INT IDENTITY(1,1) PRIMARY KEY, -- unique request id
    employee_id INT, -- requesting employee FK
    leave_id INT, -- requested leave type FK
    justification VARCHAR(700), -- employee justification text
    duration INT, -- requested duration
    approval_timing DATETIME, -- date/time of approval decision
    status VARCHAR(60) DEFAULT 'Pending', -- workflow status
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (leave_id) REFERENCES Leave(leave_id) -- enforce leave type existence
);
GO -- complete LeaveRequest definition

-- Annual leave entitlement balances by employee and leave type.
CREATE TABLE LeaveEntitlement ( -- entitlement balances
    employee_id INT, -- FK to employee
    leave_type_id INT, -- FK to leave type
    entitlement DECIMAL(8,3), -- available entitlement amount
    PRIMARY KEY (employee_id, leave_type_id), -- composite PK per employee/type
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (leave_type_id) REFERENCES Leave(leave_id) -- enforce leave type existence
);
GO -- complete LeaveEntitlement definition

-- Uploaded documents attached to leave requests.
CREATE TABLE LeaveDocument ( -- uploaded documentation for leave
    document_id INT IDENTITY(1,1) PRIMARY KEY, -- unique document id
    leave_request_id INT, -- FK to LeaveRequest
    file_path VARCHAR(255), -- storage path for document
    uploaded_at DATETIME DEFAULT GETDATE(), -- timestamp of upload
    FOREIGN KEY (leave_request_id) REFERENCES LeaveRequest(request_id) -- enforce request existence
);
GO -- complete LeaveDocument definition
