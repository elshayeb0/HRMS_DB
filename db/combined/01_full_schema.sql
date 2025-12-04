-- =============================================
-- File: 01_full_schema.sql
-- Project: HRMS_DB - Milestone 2

-- Purpose: Combined schema script for submission

-- Content: 00_create_database.sql + all db/schema/*.sql

-- Note: GENERATED FILE – do not edit manually
-- =============================================

-- Content will be assembled from individual schema files.
IF DB_ID('HRMS_DB') IS NULL
BEGIN
    CREATE DATABASE HRMS_DB;
END;
GO

USE HRMS_DB;
GO

CREATE TABLE Position (
    position_id INT IDENTITY(1,1) PRIMARY KEY,
    position_title VARCHAR(150) NOT NULL,
    responsibilities VARCHAR(400),
    status VARCHAR(30) DEFAULT 'Active'
);
GO

CREATE TABLE Department (
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    department_name VARCHAR(80) NOT NULL,
    purpose VARCHAR(400),
    department_head_id INT NULL
);
GO

CREATE TABLE Employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    full_name VARCHAR(60),
    national_id VARCHAR(20),
    date_of_birth DATE,
    country_of_birth VARCHAR(30),
    phone VARCHAR(20),
    email VARCHAR(80) UNIQUE,
    address VARCHAR(150),
    emergency_contact_name VARCHAR(80),
    emergency_contact_phone VARCHAR(20),
    relationship VARCHAR(25),
    biography VARCHAR(MAX),
    profile_image VARCHAR(255),
    employment_progress VARCHAR(65),
    account_status VARCHAR(30) DEFAULT 'Active',
    employment_status VARCHAR(30) DEFAULT 'Active',
    hire_date DATE,
    is_active BIT DEFAULT 1,
    profile_completion INT DEFAULT 0,
    department_id INT,
    position_id INT,
    manager_id INT,
    contract_id INT,
    tax_form_id INT,
    salary_type_id INT,
    pay_grade INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    FOREIGN KEY (position_id) REFERENCES Position(position_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id)
);
GO

ALTER TABLE Department
ADD CONSTRAINT FK_Department_Head FOREIGN KEY (department_head_id) REFERENCES Employee(employee_id);
GO

CREATE TABLE HRAdministrator (
    employee_id INT PRIMARY KEY,
    approval_level INT,
    record_access_scope VARCHAR(90),
    document_validation_rights VARCHAR(89),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE SystemAdministrator (
    employee_id INT PRIMARY KEY,
    system_privilege_level INT,
    configurable_fields VARCHAR(MAX),
    audit_visibility_scope VARCHAR(100),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Role (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(60) NOT NULL,
    purpose VARCHAR(150)
);
GO

CREATE TABLE RolePermission (
    role_id INT,
    permission_name VARCHAR(100),
    allowed_action VARCHAR(100),
    PRIMARY KEY (role_id, permission_name),
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);
GO

CREATE TABLE Employee_Role (
    employee_id INT,
    role_id INT,
    assigned_date DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (employee_id, role_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (role_id) REFERENCES Role(role_id)
);
GO

CREATE TABLE EmployeeHierarchy (
    employee_id INT,
    manager_id INT,
    hierarchy_level INT,
    PRIMARY KEY (employee_id, manager_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Skill (
    skill_id INT IDENTITY(1,1) PRIMARY KEY,
    skill_name VARCHAR(100) NOT NULL,
    description VARCHAR(500)
);
GO

CREATE TABLE LineManager (
    employee_id INT PRIMARY KEY,
    team_size INT,
    supervised_departments VARCHAR(200),
    approval_limit DECIMAL(10,2),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Employee_Skill (
    employee_id INT,
    skill_id INT,
    proficiency_level VARCHAR(50),
    PRIMARY KEY (employee_id, skill_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id)
);
GO



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

ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_Contract FOREIGN KEY (contract_id) REFERENCES Contract(contract_id);
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


USE HRMS_DB;
GO

CREATE TABLE ShiftSchedule (
    shift_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60),
    type VARCHAR(60),
    start_time TIME,
    end_time TIME,
    break_duration INT,
    shift_date DATE,
    status VARCHAR(80),
    location VARCHAR(200),
    allowance_amount DECIMAL(10,2) DEFAULT 0
);
GO

CREATE TABLE ShiftAssignment (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT,
    shift_id INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(60),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id)
);
GO

CREATE TABLE Exception (
    exception_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(200),
    category VARCHAR(60),
    date DATE,
    status VARCHAR(60)
);
GO

CREATE TABLE Attendance (
    attendance_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT,
    shift_id INT,
    entry_time DATETIME,
    exit_time DATETIME,
    duration INT,
    login_method VARCHAR(60),
    logout_method VARCHAR(110),
    exception_id INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id),
    FOREIGN KEY (exception_id) REFERENCES Exception(exception_id)
);
GO

CREATE TABLE AttendanceLog (
    attendance_log_id INT IDENTITY(1,1) PRIMARY KEY,
    attendance_id INT,
    actor INT,
    timestamp DATETIME,
    reason VARCHAR(600),
    FOREIGN KEY (attendance_id) REFERENCES Attendance(attendance_id),
    FOREIGN KEY (actor) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE AttendanceCorrectionRequest (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT,
    date DATE,
    correction_type VARCHAR(50),
    reason VARCHAR(500),
    status VARCHAR(50),
    recorded_by INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (recorded_by) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Employee_Exception (
    employee_id INT,
    exception_id INT,
    PRIMARY KEY (employee_id, exception_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (exception_id) REFERENCES Exception(exception_id)
);
GO

CREATE TABLE Device (
    device_id INT IDENTITY(1,1) PRIMARY KEY,
    device_type VARCHAR(60),
    terminal_id VARCHAR(70),
    latitude DECIMAL(11,6),
    longitude DECIMAL(12,8),
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE AttendanceSource (
    attendance_id INT,
    device_id INT,
    source_type VARCHAR(60),
    latitude DECIMAL(10,9),
    longitude DECIMAL(12,8),
    recorded_at DATETIME,
    PRIMARY KEY (attendance_id, device_id),
    FOREIGN KEY (attendance_id) REFERENCES Attendance(attendance_id),
    FOREIGN KEY (device_id) REFERENCES Device(device_id)
);
GO

CREATE TABLE ShiftCycle (
    cycle_id INT IDENTITY(1,1) PRIMARY KEY,
    cycle_name VARCHAR(50),
    description VARCHAR(500)
);
GO

CREATE TABLE ShiftCycleAssignment (
    cycle_id INT,
    shift_id INT,
    order_number INT,
    PRIMARY KEY (cycle_id, shift_id),
    FOREIGN KEY (cycle_id) REFERENCES ShiftCycle(cycle_id),
    FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id)
);
GO



USE HRMS_DB;
GO

CREATE TABLE Payroll (
    payroll_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT,
    taxes DECIMAL(11,3),
    period_start DATE,
    period_end DATE,
    base_amount DECIMAL(11,3),
    adjustments DECIMAL(11,3),
    contributions DECIMAL(11,3),
    actual_pay DECIMAL(11,3),
    net_salary DECIMAL(11,3),
    payment_date DATE,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO


CREATE TABLE Currency (
    CurrencyCode VARCHAR(11) PRIMARY KEY,
    CurrencyName VARCHAR(65) NOT NULL UNIQUE,
    ExchangeRate DECIMAL(13,5) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    LastUpdated DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE SalaryType (
    salary_type_id INT IDENTITY(1,1) PRIMARY KEY,
    type VARCHAR(40) NOT NULL,
    payment_frequency VARCHAR(60),
    currency VARCHAR(65),
    FOREIGN KEY (currency) REFERENCES Currency(CurrencyName)
);
GO

ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_SalaryType FOREIGN KEY (salary_type_id) REFERENCES SalaryType(salary_type_id);
GO

CREATE TABLE HourlySalaryType (
    salary_type_id INT PRIMARY KEY,
    hourly_rate DECIMAL(11,3),
    max_monthly_hours INT,
    FOREIGN KEY (salary_type_id) REFERENCES SalaryType(salary_type_id)
);
GO

CREATE TABLE MonthlySalaryType (
    salary_type_id INT PRIMARY KEY,
    tax_rule VARCHAR(150),
    contribution_scheme VARCHAR(150),
    FOREIGN KEY (salary_type_id) REFERENCES SalaryType(salary_type_id)
);
GO



CREATE TABLE ContractSalaryType (
    salary_type_id INT PRIMARY KEY,
    contract_value DECIMAL(11,3),
    installment_details VARCHAR(505),
    FOREIGN KEY (salary_type_id) REFERENCES SalaryType(salary_type_id)
);
GO

CREATE TABLE AllowanceDeduction (
    ad_id INT IDENTITY(1,1) PRIMARY KEY,
    payroll_id INT,
    employee_id INT,
    type VARCHAR(60),
    amount DECIMAL(11,3),
    currency VARCHAR(65),
    duration INT,
    timezone VARCHAR(60),
    FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (currency) REFERENCES Currency(CurrencyName)
);
GO


CREATE TABLE PayrollPolicy (
    policy_id INT IDENTITY(1,1) PRIMARY KEY,
    effective_date DATE,
    type VARCHAR(50),
    description VARCHAR(MAX)
);
GO

CREATE TABLE OvertimePolicy (
    policy_id INT PRIMARY KEY,
    weekday_rate_multiplier DECIMAL(3,2),
    weekend_rate_multiplier DECIMAL(3,2),
    max_hours_per_month INT,
    FOREIGN KEY (policy_id) REFERENCES PayrollPolicy(policy_id)
);
GO

CREATE TABLE LatenessPolicy (
    policy_id INT PRIMARY KEY,
    grace_period_mins INT,
    deduction_rate DECIMAL(6,2),
    FOREIGN KEY (policy_id) REFERENCES PayrollPolicy(policy_id)
);
GO

CREATE TABLE BonusPolicy (
    policy_id INT PRIMARY KEY,
    bonus_type VARCHAR(60),
    eligibility_criteria VARCHAR(MAX),
    amount DECIMAL(10,2),
    FOREIGN KEY (policy_id) REFERENCES PayrollPolicy(policy_id)
);
GO

CREATE TABLE DeductionPolicy (
    policy_id INT PRIMARY KEY,
    deduction_reason VARCHAR(150),
    calculation_mode VARCHAR(60),
    FOREIGN KEY (policy_id) REFERENCES PayrollPolicy(policy_id)
);
GO

CREATE TABLE PayrollPolicy_ID (
    payroll_id INT,
    policy_id INT,
    PRIMARY KEY (payroll_id, policy_id),
    FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id),
    FOREIGN KEY (policy_id) REFERENCES PayrollPolicy(policy_id)
);
GO

CREATE TABLE Payroll_Log (
    payroll_log_id INT IDENTITY(1,1) PRIMARY KEY,
    payroll_id INT,
    actor INT,
    change_date DATETIME,
    modification_type VARCHAR(50),
    FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id)
);
GO

CREATE TABLE PayrollPeriod (
    payroll_period_id INT IDENTITY(1,1) PRIMARY KEY,
    payroll_id INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id)
);
GO


CREATE TABLE TaxForm (
    tax_form_id INT IDENTITY(1,1) PRIMARY KEY,
    jurisdiction VARCHAR(150),
    validity_period INT,
    form_content VARCHAR(MAX)
);
GO

ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_TaxForm FOREIGN KEY (tax_form_id) REFERENCES TaxForm(tax_form_id);
GO

CREATE TABLE PayGrade (
    pay_grade_id INT IDENTITY(1,1) PRIMARY KEY,
    grade_name VARCHAR(60) NOT NULL,
    min_salary DECIMAL(11,3),
    max_salary DECIMAL(11,3)
);
GO

ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_PayGrade FOREIGN KEY (pay_grade) REFERENCES PayGrade(pay_grade_id);
GO

CREATE TABLE PayrollSpecialist (
    employee_id INT PRIMARY KEY,
    assigned_region VARCHAR(100),
    processing_frequency VARCHAR(50),
    last_processed_period DATE,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO



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


