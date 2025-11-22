-- =============================================
-- File: 02_contracts_missions.sql
-- Project: HRMS_DB - Milestone 2

-- Purpose: Contracts, contract subtypes, missions, reimbursements,
--          insurance, termination

-- Dependencies: 01_core_hr.sql
-- Run order: Schema step 2
-- =============================================

USE HRMS_DB;
GO

CREATE TABLE Contract (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,
    type VARCHAR(80) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    current_state VARCHAR(80) DEFAULT 'Active'
);
GO

CREATE TABLE FullTimeContract (
    contract_id INT PRIMARY KEY,
    leave_entitlement INT,
    insurance_eligibility BIT,
    weekly_working_hours INT,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
);
GO


CREATE TABLE PartTimeContract (
    contract_id INT PRIMARY KEY,
    working_hours INT,
    hourly_rate DECIMAL(10,2),
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
);
GO

CREATE TABLE ConsultantContract (
    contract_id INT PRIMARY KEY,
    project_scope VARCHAR(MAX),
    fees DECIMAL(10,2),
    payment_schedule VARCHAR(100),
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
);
GO

CREATE TABLE InternshipContract (
    contract_id INT PRIMARY KEY,
    mentoring VARCHAR(80),
    evaluation VARCHAR(480),
    stipend_related DECIMAL(10,4),
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
);
GO

CREATE TABLE Mission (
    mission_id INT IDENTITY(1,1) PRIMARY KEY,
    destination VARCHAR(100),
    start_date DATE,
    end_date DATE,
    status VARCHAR(50),
    employee_id INT,
    manager_id INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Reimbursement (
    reimbursement_id INT IDENTITY(1,1) PRIMARY KEY,
    type VARCHAR(80),
    claim_type VARCHAR(80),
    approval_date DATE,
    current_status VARCHAR(80),
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Insurance (
    insurance_id INT IDENTITY(1,1) PRIMARY KEY,
    type VARCHAR(80),
    contribution_rate DECIMAL(6,3),
    coverage VARCHAR(MAX)
);
GO

CREATE TABLE Termination (
    termination_id INT IDENTITY(1,1) PRIMARY KEY,
    date DATE,
    reason VARCHAR(500),
    contract_id INT,
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
);
GO