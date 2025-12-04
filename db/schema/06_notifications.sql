-- Notifications and workflows schema: notifications, approval workflows, manager notes, and verifications.
USE HRMS_DB;
GO

CREATE TABLE Notification ( -- general notifications catalog
    notification_id INT IDENTITY(1,1) PRIMARY KEY, -- unique notification id
    message_content VARCHAR(500), -- notification body
    timestamp DATETIME DEFAULT GETDATE(), -- creation timestamp
    urgency VARCHAR(20), -- urgency level
    read_status BIT DEFAULT 0, -- flag showing whether it is read
    notification_type VARCHAR(50) -- category/type of notification
);
GO -- complete Notification definition

CREATE TABLE Employee_Notification ( -- link employees to notifications
    employee_id INT, -- FK to Employee
    notification_id INT, -- FK to Notification
    delivery_status VARCHAR(50), -- status of delivery
    delivered_at DATETIME, -- when delivery occurred
    PRIMARY KEY (employee_id, notification_id), -- composite PK avoids duplicates
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (notification_id) REFERENCES Notification(notification_id) -- enforce notification existence
);
GO -- complete Employee_Notification definition

CREATE TABLE ApprovalWorkflow ( -- workflow headers for approvals
    workflow_id INT IDENTITY(1,1) PRIMARY KEY, -- unique workflow id
    workflow_type VARCHAR(60), -- type of workflow (expense, leave)
    threshold_amount DECIMAL(11,2), -- monetary threshold for routing
    approver_role VARCHAR(60), -- role required to approve
    created_by INT, -- creator employee id
    status VARCHAR(60) -- current workflow status
);
GO -- complete ApprovalWorkflow definition

CREATE TABLE ApprovalWorkflowStep ( -- ordered steps inside workflows
    workflow_id INT, -- FK to ApprovalWorkflow
    step_number INT, -- sequence number
    role_id INT, -- FK to Role responsible for step
    action_required VARCHAR(150), -- action needed at this step
    PRIMARY KEY (workflow_id, step_number), -- composite PK prevents duplicates
    FOREIGN KEY (workflow_id) REFERENCES ApprovalWorkflow(workflow_id), -- enforce workflow existence
    FOREIGN KEY (role_id) REFERENCES Role(role_id) -- enforce role existence
);
GO -- complete ApprovalWorkflowStep definition

CREATE TABLE ManagerNotes ( -- manager-authored notes for employees
    note_id INT IDENTITY(1,1) PRIMARY KEY, -- unique note id
    employee_id INT, -- FK to employee receiving note
    manager_id INT, -- FK to manager writing note
    note_content VARCHAR(MAX), -- note text
    created_at DATETIME DEFAULT GETDATE(), -- when note was created
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id) -- enforce manager existence
);
GO -- complete ManagerNotes definition

CREATE TABLE Verification ( -- verification documents catalog
    verification_id INT IDENTITY(1,1) PRIMARY KEY, -- unique verification id
    verification_type VARCHAR(50), -- type (background, ID)
    issuer VARCHAR(100), -- issuing authority
    issue_date DATE, -- issuance date
    expiry_period INT -- validity duration in days/months
);
GO -- complete Verification definition

CREATE TABLE Employee_Verification ( -- assignments of verifications to employees
    employee_id INT, -- FK to employee
    verification_id INT, -- FK to verification
    PRIMARY KEY (employee_id, verification_id), -- composite PK prevents duplicates
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (verification_id) REFERENCES Verification(verification_id) -- enforce verification existence
);
GO -- complete Employee_Verification definition
