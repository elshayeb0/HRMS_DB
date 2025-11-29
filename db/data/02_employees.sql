

USE HRMS_DB;
GO

INSERT INTO Employee (
    first_name, last_name, full_name, national_id, date_of_birth, country_of_birth,
    phone, email, address, emergency_contact_name, emergency_contact_phone,
    relationship, biography, profile_image, employment_progress, account_status,
    employment_status, hire_date, is_active, profile_completion,
    department_id, position_id, manager_id, contract_id, tax_form_id, salary_type_id, pay_grade
) VALUES
-- Employee 1 (John Smith - CEO)
('John', 'Smith', 'John Smith', 'US123456789', '1975-05-15', 'United States',
 '+1-555-0101', 'john.smith@company.com', '123 Main St, New York, NY',
 'Emma Smith', '+1-555-0102', 'Spouse',
 'Company CEO with 20+ years leadership', '/profiles/jsmith.jpg',
 'Completed Onboarding', 'Active', 'Active',
 '2020-01-01', 1, 100,
 1, 1, NULL, NULL, 1, 1, 6),

-- Employee 2 (Sarah Johnson - HR Manager)
('Sarah', 'Johnson', 'Sarah Johnson', 'US987654321', '1985-08-22', 'United States',
 '+1-555-0201', 'sarah.johnson@company.com', '456 Oak Ave, Boston, MA',
 'Michael Johnson', '+1-555-0202', 'Spouse',
 'HR professional with expertise in talent management', '/profiles/sjohnson.jpg',
 'Completed Onboarding', 'Active', 'Active',
 '2021-03-01', 1, 100,
 2, 2, 1, NULL, 1, 1, 5),

-- Employee 3 (Ahmed Hassan - IT Manager)
('Ahmed', 'Hassan', 'Ahmed Hassan', 'EG112233445', '1988-03-10', 'Egypt',
 '+20-100-1234567', 'ahmed.hassan@company.com', '78 Nile St, Cairo, Egypt',
 'Fatima Hassan', '+20-100-7654321', 'Spouse',
 'IT Manager with cloud infrastructure expertise', '/profiles/ahassan.jpg',
 'Completed Onboarding', 'Active', 'Active',
 '2021-06-15', 1, 100,
 3, 3, 1, NULL, 1, 1, 5),

-- Employee 4 (Emily Davis - Finance Manager)
('Emily', 'Davis', 'Emily Davis', 'US556677889', '1990-11-30', 'United States',
 '+1-555-0301', 'emily.davis@company.com', '789 Pine Rd, Chicago, IL',
 'Robert Davis', '+1-555-0302', 'Father',
 'Finance expert with CPA certification', '/profiles/edavis.jpg',
 'Completed Onboarding', 'Active', 'Active',
 '2022-01-10', 1, 100,
 4, 4, 1, NULL, 1, 1, 5),

-- Employee 5 (Michael Brown - Software Engineer)
('Michael', 'Brown', 'Michael Brown', 'US334455667', '1992-07-18', 'United States',
 '+1-555-0401', 'michael.brown@company.com', '321 Elm St, Seattle, WA',
 'Lisa Brown', '+1-555-0402', 'Mother',
 'Full-stack developer specializing in cloud solutions', '/profiles/mbrown.jpg',
 'Completed Onboarding', 'Active', 'Active',
 '2022-08-01', 1, 95,
 3, 5, 3, NULL, 2, 2, 3),

-- Employee 6 (David Wilson - IT Consultant)
('David', 'Wilson', 'David Wilson', 'UK998877665', '1987-02-14', 'United Kingdom',
 '+44-20-12345678', 'david.wilson@company.com', '55 Baker St, London, UK',
 'Emma Wilson', '+44-20-87654321', 'Spouse',
 'IT consultant with 15 years experience', '/profiles/dwilson.jpg',
 'Completed Onboarding', 'Active', 'Active',
 '2023-01-01', 1, 100,
 3, 10, 3, NULL, 1, 3, 4),

-- Employee 7 (Maria Garcia - Intern)
('Maria', 'Garcia', 'Maria Garcia', 'US778899001', '1998-09-25', 'United States',
 '+1-555-0501', 'maria.garcia@company.com', '654 Maple Dr, Austin, TX',
 'Carlos Garcia', '+1-555-0502', 'Father',
 'Computer Science student completing internship', '/profiles/mgarcia.jpg',
 'In Progress', 'Active', 'Active',
 '2024-06-01', 1, 80,
 3, 5, 3, NULL, 1, 2, 1),

-- Employee 8 (Jennifer Lee - HR Specialist)
('Jennifer', 'Lee', 'Jennifer Lee', 'US445566778', '1989-04-20', 'United States',
 '+1-555-0601', 'jennifer.lee@company.com', '987 Cedar Ln, San Francisco, CA',
 'Kevin Lee', '+1-555-0602', 'Spouse',
 'HR specialist focused on recruitment', '/profiles/jlee.jpg',
 'Completed Onboarding', 'Active', 'Active',
 '2023-05-01', 1, 100,
 2, 6, 2, NULL, 1, 1, 3),

-- Employee 9 (Robert Martinez - Accountant)
('Robert', 'Martinez', 'Robert Martinez', 'US223344556', '1991-12-05', 'United States',
 '+1-555-0701', 'robert.martinez@company.com', '159 Birch Ave, Miami, FL',
 'Ana Martinez', '+1-555-0702', 'Spouse',
 'Certified accountant with tax expertise', '/profiles/rmartinez.jpg',
 'Completed Onboarding', 'Active', 'Active',
 '2023-09-15', 1, 100,
 4, 7, 4, NULL, 1, 1, 3),

-- Employee 10 (Lisa Anderson - Sales Manager)
('Lisa', 'Anderson', 'Lisa Anderson', 'US667788990', '1986-06-08', 'United States',
 '+1-555-0801', 'lisa.anderson@company.com', '753 Spruce St, Denver, CO',
 'Mark Anderson', '+1-555-0802', 'Spouse',
 'Sales leader with proven track record', '/profiles/landerson.jpg',
 'Completed Onboarding', 'Active', 'Active',
 '2024-02-01', 1, 100,
 5, 8, 1, NULL, 1, 1, 4);

INSERT INTO HRAdministrator (employee_id, approval_level, record_access_scope, document_validation_rights) VALUES
(2, 3, 'All departments and employees', 'Can validate all HR documents'),
(8, 2, 'HR department only', 'Can validate recruitment documents');

-- System Administrator
INSERT INTO SystemAdministrator (employee_id, system_privilege_level, configurable_fields, audit_visibility_scope) VALUES
(3, 5, 'All system settings, user permissions, database configuration', 'Full audit log access');

-- Line Manager
INSERT INTO LineManager (employee_id, team_size, supervised_departments, approval_limit) VALUES
(2, 5, 'Human Resources', 10000.00),
(3, 8, 'Information Technology', 15000.00),
(4, 4, 'Finance', 50000.00),
(10, 6, 'Sales', 20000.00);


INSERT INTO Role (role_name, purpose) VALUES
('Admin', 'Full system administrative access'),
('HR Admin', 'Human resources administrative functions'),
('Manager', 'Team and department management'),
('Employee', 'Standard employee access'),
('Payroll Specialist', 'Payroll processing and management'),
('System Admin', 'Technical system administration');

-- RolePermission
INSERT INTO RolePermission (role_id, permission_name, allowed_action) VALUES
(1, 'System Settings', 'Full Access'),
(1, 'User Management', 'Create, Read, Update, Delete'),
(2, 'Employee Records', 'Create, Read, Update'),
(2, 'Leave Management', 'Approve, Reject'),
(3, 'Team Management', 'Read, Update'),
(3, 'Attendance Review', 'Read, Approve'),
(4, 'Profile', 'Read, Update Own'),
(4, 'Leave Request', 'Create, Read Own'),
(5, 'Payroll Processing', 'Create, Read, Update'),
(6, 'System Configuration', 'Full Access');

INSERT INTO Employee_Role (employee_id, role_id, assigned_date) VALUES
(1, 1, '2020-01-15'),
(2, 2, '2021-03-01'),
(2, 3, '2021-03-01'),
(3, 6, '2021-06-15'),
(3, 3, '2021-06-15'),
(4, 3, '2022-01-10'),
(5, 4, '2022-08-01'),
(6, 4, '2023-01-01'),
(7, 4, '2024-06-01'),
(8, 4, '2023-05-01'),
(9, 5, '2023-09-15'),
(10, 3, '2024-02-01');

-- Employee Hierarchy
INSERT INTO EmployeeHierarchy (employee_id, manager_id, hierarchy_level) VALUES
(2, 1, 1),
(3, 1, 1),
(4, 1, 1),
(10, 1, 1),
(5, 3, 2),
(6, 3, 2),
(7, 3, 2),
(8, 2, 2),
(9, 4, 2);


INSERT INTO Skill (skill_name, description) VALUES
('Leadership', 'Team and organizational leadership capabilities'),
('Python Programming', 'Proficiency in Python development'),
('SQL Database Management', 'Database design and query optimization'),
('Project Management', 'Project planning and execution'),
('Communication', 'Effective written and verbal communication'),
('Financial Analysis', 'Financial data analysis and reporting'),
('Cloud Computing', 'AWS, Azure, or GCP expertise'),
('Human Resources', 'HR policies and talent management'),
('Sales Strategy', 'Sales planning and customer relationship management'),
('Cybersecurity', 'Information security and risk management');


INSERT INTO Employee_Skill (employee_id, skill_id, proficiency_level) VALUES
-- Employee 1 (John Smith - CEO)
(1, 1, 'Expert'),      -- Leadership
(1, 4, 'Expert'),      -- Project Management
(1, 5, 'Expert'),      -- Communication
(1, 6, 'Advanced'),    -- Financial Analysis

-- Employee 2 (Sarah Johnson - HR Manager)
(2, 1, 'Advanced'),    -- Leadership
(2, 4, 'Advanced'),    -- Project Management
(2, 5, 'Expert'),      -- Communication
(2, 8, 'Expert'),      -- Human Resources

-- Employee 3 (Ahmed Hassan - IT Manager)
(3, 1, 'Advanced'),    -- Leadership
(3, 2, 'Advanced'),    -- Python Programming
(3, 3, 'Expert'),      -- SQL Database Management
(3, 4, 'Advanced'),    -- Project Management
(3, 7, 'Expert'),      -- Cloud Computing
(3, 10, 'Advanced'),   -- Cybersecurity

-- Employee 4 (Emily Davis - Finance Manager)
(4, 1, 'Advanced'),    -- Leadership
(4, 3, 'Intermediate'),-- SQL Database Management
(4, 5, 'Advanced'),    -- Communication
(4, 6, 'Expert');     -- Financial Analysis

INSERT INTO Verification (verification_type, issuer, issue_date, expiry_period) VALUES
('Background Check', 'SecureCheck Inc.', '2024-01-15', 365),
('Degree Verification', 'National Clearinghouse', '2024-03-01', 0),
('Professional License', 'State Board of Accountancy', '2024-01-10', 730),
('Security Clearance', 'Federal Security Agency', '2024-06-15', 1825),
('Medical Certificate', 'Occupational Health Services', '2024-11-01', 365),
('Drug Screening', 'MedTest Labs', '2024-02-01', 365),
('Identity Verification', 'Government ID Services', '2024-01-15', 1825),
('Credit Check', 'Financial Verification Bureau', '2024-01-10', 365),
('Reference Check', 'HR Verification Services', '2024-03-01', 365),
('Work Authorization', 'Immigration Services', '2024-01-15', 730);

INSERT INTO Employee_Verification (employee_id, verification_id) VALUES
(1, 1),
(1, 2),
(1, 7),
(2, 1),
(2, 2),
(2, 9),
(3, 1),
(3, 2),
(3, 4),
(3, 7),
(4, 1),
(4, 2),
(4, 3),
(4, 8),
(5, 1),
(5, 2),
(5, 6),
(6, 1),
(6, 2),
(6, 10),
(7, 1),
(7, 5),
(7, 6),
(8, 1),
(8, 2),
(8, 9),
(9, 1),
(9, 2),
(9, 3),
(10, 1),
(10, 2),
(10, 9);


INSERT INTO ManagerNotes (employee_id, manager_id, note_content, created_at) VALUES
(5, 3, 'Michael has shown excellent progress on the cloud migration project. Recommend for promotion consideration.', '2024-11-15 10:30:00'),
(7, 3, 'Maria is a quick learner and has adapted well to the team. Consider full-time position after internship.', '2024-11-10 14:20:00'),
(8, 2, 'Jennifer has successfully completed 5 difficult recruitments this quarter. Excellent performance.', '2024-11-18 09:45:00'),
(9, 4, 'Robert needs additional training on the new accounting software. Scheduled for December.', '2024-11-12 16:00:00'),
(5, 3, 'Completed AWS certification. This adds valuable skills to the team.', '2024-10-28 11:15:00'),
(10, 1, 'Lisa exceeded Q4 sales targets by 25%. Outstanding contribution to company growth.', '2024-11-20 13:30:00'),
(7, 3, 'Mid-internship review: Maria is performing above expectations. Strong technical skills.', '2024-09-15 15:00:00'),
(8, 2, 'Handled difficult candidate negotiation professionally. Great interpersonal skills demonstrated.', '2024-10-05 10:20:00');

