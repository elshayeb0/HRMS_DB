-- =============================================
-- File: 01_core_hr.sql
-- Project: HRMS_DB - Milestone 2

-- Purpose: Core HR entities (Employee, Department, Position,
--          Role, RolePermission, Employee_Role, Hierarchy, Skills)

-- Dependencies: 00_create_database.sql
-- Run order: Schema step 1
-- =============================================

USE HRMS_DB;
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
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (contract_id) REFERENCES Contract(contract_id),
    FOREIGN KEY (tax_form_id) REFERENCES TaxForm(tax_form_id),
    FOREIGN KEY (salary_type_id) REFERENCES SalaryType(salary_type_id),
    FOREIGN KEY (pay_grade) REFERENCES PayGrade(pay_grade_id)
);
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
    FOREIGN KEY (department_head_id) REFERENCES Employee(employee_id)
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