-- Contracts and missions schema: contract types, missions, reimbursements, insurances, and terminations.
USE HRMS_DB;
GO

CREATE TABLE Contract ( -- base contract metadata
    contract_id INT IDENTITY(1,1) PRIMARY KEY, -- unique contract id
    type VARCHAR(80) NOT NULL, -- contract category (full-time, part-time, etc.)
    start_date DATE NOT NULL, -- start date of the contract
    end_date DATE, -- optional end date
    current_state VARCHAR(80) DEFAULT 'Active' -- status flag with default
);
GO -- complete Contract definition

ALTER TABLE Employee -- attach contract FK to employees
ADD CONSTRAINT FK_Employee_Contract FOREIGN KEY (contract_id) REFERENCES Contract(contract_id);
GO -- finalize Employee alteration

CREATE TABLE FullTimeContract ( -- details specific to full-time agreements
    contract_id INT PRIMARY KEY, -- FK and PK referencing Contract
    leave_entitlement INT, -- annual leave allowance
    insurance_eligibility BIT, -- eligibility flag for insurance
    weekly_working_hours INT, -- expected weekly hours
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id) -- enforce contract existence
);
GO -- complete FullTimeContract definition


CREATE TABLE PartTimeContract ( -- details for part-time contracts
    contract_id INT PRIMARY KEY, -- FK and PK referencing Contract
    working_hours INT, -- expected weekly hours
    hourly_rate DECIMAL(10,2), -- pay rate per hour
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id) -- enforce contract existence
);
GO -- complete PartTimeContract definition

CREATE TABLE ConsultantContract ( -- data for consulting agreements
    contract_id INT PRIMARY KEY, -- FK and PK referencing Contract
    project_scope VARCHAR(MAX), -- scope of work description
    fees DECIMAL(10,2), -- consulting fee amount
    payment_schedule VARCHAR(100), -- schedule for fee payments
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id) -- enforce contract existence
);
GO -- complete ConsultantContract definition

CREATE TABLE InternshipContract ( -- fields for internships
    contract_id INT PRIMARY KEY, -- FK and PK referencing Contract
    mentoring VARCHAR(80), -- mentoring arrangement
    evaluation VARCHAR(480), -- evaluation notes or criteria
    stipend_related DECIMAL(10,4), -- stipend or allowance value
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id) -- enforce contract existence
);
GO -- complete InternshipContract definition

CREATE TABLE Mission ( -- employee missions or business trips
    mission_id INT IDENTITY(1,1) PRIMARY KEY, -- mission identifier
    destination VARCHAR(100), -- mission destination
    start_date DATE, -- departure date
    end_date DATE, -- return/end date
    status VARCHAR(50), -- mission state
    employee_id INT, -- FK to employee on mission
    manager_id INT, -- FK to manager overseeing mission
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id) -- enforce manager existence
);
GO -- complete Mission definition

CREATE TABLE Reimbursement ( -- reimbursement claims
    reimbursement_id INT IDENTITY(1,1) PRIMARY KEY, -- reimbursement identifier
    type VARCHAR(80), -- reimbursement category
    claim_type VARCHAR(80), -- specific claim type
    approval_date DATE, -- date approved
    current_status VARCHAR(80), -- workflow state
    employee_id INT, -- FK to claiming employee
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) -- enforce employee existence
);
GO -- complete Reimbursement definition

CREATE TABLE Insurance ( -- insurance policies
    insurance_id INT IDENTITY(1,1) PRIMARY KEY, -- insurance identifier
    type VARCHAR(80), -- insurance product type
    contribution_rate DECIMAL(6,3), -- contribution rate/percentage
    coverage VARCHAR(MAX) -- description of coverage
);
GO -- complete Insurance definition

CREATE TABLE Termination ( -- contract termination records
    termination_id INT IDENTITY(1,1) PRIMARY KEY, -- termination identifier
    date DATE, -- termination date
    reason VARCHAR(500), -- description of termination reason
    contract_id INT, -- FK to terminated contract
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id) -- enforce contract existence
);
GO -- complete Termination definition
