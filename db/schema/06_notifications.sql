

USE HRMS_DB;
GO

CREATE TABLE Notification (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    message_content VARCHAR(500),
    timestamp DATETIME DEFAULT GETDATE(),
    urgency VARCHAR(20),
    read_status BIT DEFAULT 0,
    notification_type VARCHAR(50)
);
GO

CREATE TABLE Employee_Notification (
    employee_id INT,
    notification_id INT,
    delivery_status VARCHAR(50),
    delivered_at DATETIME,
    PRIMARY KEY (employee_id, notification_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (notification_id) REFERENCES Notification(notification_id)
);
GO

CREATE TABLE ApprovalWorkflow (
    workflow_id INT IDENTITY(1,1) PRIMARY KEY,
    workflow_type VARCHAR(60),
    threshold_amount DECIMAL(11,2),
    approver_role VARCHAR(60),
    created_by INT,
    status VARCHAR(60)
);
GO

CREATE TABLE ApprovalWorkflowStep (
    workflow_id INT,
    step_number INT,
    role_id INT,
    action_required VARCHAR(150),
    PRIMARY KEY (workflow_id, step_number),
    FOREIGN KEY (workflow_id) REFERENCES ApprovalWorkflow(workflow_id),
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);
GO

CREATE TABLE ManagerNotes (
    note_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT,
    manager_id INT,
    note_content VARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Verification (
    verification_id INT IDENTITY(1,1) PRIMARY KEY,
    verification_type VARCHAR(50),
    issuer VARCHAR(100),
    issue_date DATE,
    expiry_period INT
);
GO

CREATE TABLE Employee_Verification (
    employee_id INT,
    verification_id INT,
    PRIMARY KEY (employee_id, verification_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (verification_id) REFERENCES Verification(verification_id)
);
GO
