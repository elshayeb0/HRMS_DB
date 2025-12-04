-- Core HR schema: employees, positions, departments, roles, skills, and reporting links.
USE HRMS_DB;
GO

-- Catalog of defined job positions.
CREATE TABLE Position ( -- base table for job positions
    position_id INT IDENTITY(1,1) PRIMARY KEY,
    position_title VARCHAR(150) NOT NULL,
    responsibilities VARCHAR(400),
    status VARCHAR(30) DEFAULT 'Active'
);
GO

-- Organizational departments with optional head assignment.
CREATE TABLE Department ( -- defines organizational departments
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    department_name VARCHAR(80) NOT NULL,
    purpose VARCHAR(400),
    department_head_id INT NULL
)
GO

-- Master employee record with links to organizational and compensation references.
CREATE TABLE Employee ( -- central employee master data
    employee_id INT IDENTITY(1,1) PRIMARY KEY, -- surrogate employee key
    first_name VARCHAR(30), -- given name
    last_name VARCHAR(30), -- family name
    full_name VARCHAR(60), -- concatenated display name
    national_id VARCHAR(20), -- national ID or SSN
    date_of_birth DATE, -- birth date
    country_of_birth VARCHAR(30), -- birth country
    phone VARCHAR(20), -- primary phone
    email VARCHAR(80) UNIQUE, -- unique email address
    address VARCHAR(150), -- mailing/home address
    emergency_contact_name VARCHAR(80), -- emergency contact person
    emergency_contact_phone VARCHAR(20), -- phone for emergency contact
    relationship VARCHAR(25), -- relation to emergency contact
    biography VARCHAR(MAX), -- free-text bio
    profile_image VARCHAR(255), -- path or URL to profile image
    employment_progress VARCHAR(65), -- onboarding/progression status
    account_status VARCHAR(30) DEFAULT 'Active', -- account enablement flag
    employment_status VARCHAR(30) DEFAULT 'Active', -- HR employment state
    hire_date DATE, -- official hire date
    is_active BIT DEFAULT 1, -- active flag for quick filters
    profile_completion INT DEFAULT 0, -- completion percentage tracker
    department_id INT, -- FK to Department
    position_id INT, -- FK to Position
    manager_id INT, -- self-referencing FK for reporting manager
    contract_id INT, -- FK to contract record (defined elsewhere)
    tax_form_id INT, -- FK to chosen tax form
    salary_type_id INT, -- FK to salary type definition
    pay_grade INT, -- FK to pay grade
    FOREIGN KEY (department_id) REFERENCES Department(department_id), -- enforce department link
    FOREIGN KEY (position_id) REFERENCES Position(position_id), -- enforce position link
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id) -- enforce manager link
);
GO -- complete Employee definition

-- Department head back-reference added after Employee exists.
ALTER TABLE Department -- extend Department after Employee exists
ADD CONSTRAINT FK_Department_Head FOREIGN KEY (department_head_id) REFERENCES Employee(employee_id); -- allow nullable head assignment
GO -- finalize Department alteration

-- HR admin privileges tied to specific employees.
CREATE TABLE HRAdministrator ( -- privileges for HR administrators
    employee_id INT PRIMARY KEY, -- FK and PK referencing employee
    approval_level INT, -- numeric approval authority
    record_access_scope VARCHAR(90), -- scope of records accessible
    document_validation_rights VARCHAR(89), -- allowed document actions
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) -- enforce employee link
);
GO -- complete HRAdministrator definition

-- System admin privileges scoped per employee.
CREATE TABLE SystemAdministrator ( -- system admin entitlements
    employee_id INT PRIMARY KEY, -- FK and PK to employee
    system_privilege_level INT, -- level of system-wide privileges
    configurable_fields VARCHAR(MAX), -- fields this admin may configure
    audit_visibility_scope VARCHAR(100), -- audit scope visibility
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) -- enforce employee link
);
GO -- complete SystemAdministrator definition

-- Application roles.
CREATE TABLE Role ( -- catalog of application roles
    role_id INT IDENTITY(1,1) PRIMARY KEY, -- role key
    role_name VARCHAR(60) NOT NULL, -- name of the role
    purpose VARCHAR(150) -- optional description
);
GO -- complete Role definition

-- Allowed actions per role.
CREATE TABLE RolePermission ( -- permissions mapped to roles
    role_id INT, -- FK to Role
    permission_name VARCHAR(100), -- permission identifier
    allowed_action VARCHAR(100), -- action permitted for the permission
    PRIMARY KEY (role_id, permission_name), -- composite PK ensures uniqueness per role/permission
    FOREIGN KEY (role_id) REFERENCES Role(role_id) -- enforce role existence
);
GO -- complete RolePermission definition

-- Many-to-many between employees and roles.
CREATE TABLE Employee_Role ( -- junction table for employees and roles
    employee_id INT, -- FK to Employee
    role_id INT, -- FK to Role
    assigned_date DATETIME DEFAULT GETDATE(), -- timestamp of assignment
    PRIMARY KEY (employee_id, role_id), -- composite PK avoids duplicates
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (role_id) REFERENCES Role(role_id) -- enforce role existence
);
GO -- complete Employee_Role definition

-- Employee hierarchy for reporting chains.
CREATE TABLE EmployeeHierarchy ( -- stores reporting relationships
    employee_id INT, -- subordinate employee
    manager_id INT, -- supervising manager
    hierarchy_level INT, -- level depth for hierarchy traversal
    PRIMARY KEY (employee_id, manager_id), -- composite PK avoids duplicates per relationship
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (manager_id) REFERENCES Employee(employee_id) -- enforce manager existence
);
GO -- complete EmployeeHierarchy definition

-- Skill catalog.
CREATE TABLE Skill ( -- master list of skills
    skill_id INT IDENTITY(1,1) PRIMARY KEY, -- unique skill id
    skill_name VARCHAR(100) NOT NULL, -- skill name
    description VARCHAR(500) -- optional description
);
GO -- complete Skill definition

-- Line manager metadata for employees leading teams.
CREATE TABLE LineManager ( -- additional data for line managers
    employee_id INT PRIMARY KEY, -- FK/PK referencing employee who is a manager
    team_size INT, -- number of direct reports
    supervised_departments VARCHAR(200), -- departments managed
    approval_limit DECIMAL(10,2), -- monetary approval cap
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) -- enforce employee existence
);
GO -- complete LineManager definition

-- Employee skill assignments with proficiency levels.
CREATE TABLE Employee_Skill ( -- junction for employee skills
    employee_id INT, -- FK to Employee
    skill_id INT, -- FK to Skill
    proficiency_level VARCHAR(50), -- proficiency indicator
    PRIMARY KEY (employee_id, skill_id), -- composite PK per employee-skill pair
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id) -- enforce skill existence
);
GO -- complete Employee_Skill definition
