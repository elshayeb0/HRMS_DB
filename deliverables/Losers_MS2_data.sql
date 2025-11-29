USE HRMS_DB;
GO

INSERT INTO Department (department_name, purpose, department_head_id) VALUES
('Executive', 'Company leadership and strategic direction', NULL),
('Human Resources', 'Employee management and development', NULL),
('Information Technology', 'Technology infrastructure and support', NULL),
('Finance', 'Financial management and reporting', NULL),
('Sales', 'Revenue generation and client relations', NULL),
('Marketing', 'Brand and market development', NULL);

INSERT INTO Position (position_title, responsibilities, status) VALUES
('CEO', 'Overall company strategy and operations', 'Active'),
('HR Manager', 'Human resources management and policy implementation', 'Active'),
('IT Manager', 'Information technology infrastructure management', 'Active'),
('Finance Manager', 'Financial planning and accounting oversight', 'Active'),
('Software Engineer', 'Software development and maintenance', 'Active'),
('HR Specialist', 'Recruitment and employee relations', 'Active'),
('Accountant', 'Financial record keeping and reporting', 'Active'),
('Sales Manager', 'Sales team leadership and strategy', 'Active'),
('Marketing Specialist', 'Marketing campaigns and brand management', 'Active'),
('System Administrator', 'IT systems maintenance and security', 'Active');

INSERT INTO Currency (CurrencyCode, CurrencyName, ExchangeRate) VALUES
('USD', 'US Dollar', 1.00000),
('EUR', 'Euro', 0.92000),
('GBP', 'British Pound', 0.79000),
('EGP', 'Egyptian Pound', 30.90000),
('SAR', 'Saudi Riyal', 3.75000);

INSERT INTO SalaryType (type, payment_frequency, currency) VALUES
('Monthly', 'Monthly', 'US Dollar'),
('Hourly', 'Bi-Weekly', 'US Dollar'),
('Contract', 'Milestone', 'US Dollar'),
('Monthly', 'Monthly', 'Egyptian Pound'),
('Hourly', 'Weekly', 'Euro');

INSERT INTO HourlySalaryType (salary_type_id, hourly_rate, max_monthly_hours) VALUES
(2, 45.000, 160),
(5, 38.000, 160);

INSERT INTO MonthlySalaryType (salary_type_id, tax_rule, contribution_scheme) VALUES
(1, 'Federal and State progressive tax', 'Standard 401k matching'),
(4, 'Egyptian progressive tax rates', 'Social insurance contribution');

INSERT INTO ContractSalaryType (salary_type_id, contract_value, installment_details) VALUES
(3, 75000.000, 'Quarterly payments of $18,750');


INSERT INTO PayGrade (grade_name, min_salary, max_salary) VALUES
('Entry Level', 30000.000, 45000.000),
('Junior', 45000.000, 65000.000),
('Mid-Level', 65000.000, 90000.000),
('Senior', 90000.000, 130000.000),
('Lead', 130000.000, 180000.000),
('Executive', 180000.000, 300000.000);


INSERT INTO TaxForm (jurisdiction, validity_period, form_content) VALUES
('Federal US', 365, 'W-4 Employee Withholding Certificate'),
('Egypt', 365, 'Egyptian Tax Declaration Form'),
('Saudi Arabia', 365, 'KSA Tax Registration Form'),
('UK', 365, 'P45 - Details of employee leaving work');

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

-- Contract
INSERT INTO Contract (type, start_date, end_date, current_state) VALUES
('Full-Time', '2020-01-15', NULL, 'Active'),
('Full-Time', '2021-03-01', NULL, 'Active'),
('Full-Time', '2021-06-15', NULL, 'Active'),
('Full-Time', '2022-01-10', NULL, 'Active'),
('Part-Time', '2022-08-01', '2024-08-01', 'Active'),
('Consultant', '2023-01-01', '2024-12-31', 'Active'),
('Internship', '2024-06-01', '2024-12-01', 'Active'),
('Full-Time', '2023-05-01', NULL, 'Active'),
('Full-Time', '2023-09-15', NULL, 'Active'),
('Full-Time', '2024-02-01', NULL, 'Active');

-- Contract Subtypes
INSERT INTO FullTimeContract (contract_id, leave_entitlement, insurance_eligibility, weekly_working_hours) VALUES
(1, 25, 1, 40),
(2, 22, 1, 40),
(3, 20, 1, 40),
(4, 20, 1, 40),
(8, 22, 1, 40),
(9, 20, 1, 40),
(10, 20, 1, 40);

INSERT INTO PartTimeContract (contract_id, working_hours, hourly_rate) VALUES
(5, 20, 35.00);

INSERT INTO ConsultantContract (contract_id, project_scope, fees, payment_schedule) VALUES
(6, 'IT Infrastructure Upgrade and Security Implementation', 75000.00, 'Quarterly');

INSERT INTO InternshipContract (contract_id, mentoring, evaluation, stipend_related) VALUES
(7, 'Weekly mentoring sessions with senior developer', 'Monthly performance reviews', 1500.0000);

INSERT INTO Mission (destination, start_date, end_date, status, employee_id, manager_id) VALUES
('London, UK', '2024-10-15', '2024-10-20', 'Completed', 3, 1),
('Dubai, UAE', '2024-11-01', '2024-11-05', 'Completed', 10, 1),
('Berlin, Germany', '2024-12-01', '2024-12-05', 'Approved', 5, 3),
('Paris, France', '2025-01-10', '2025-01-15', 'Pending', 8, 2);

INSERT INTO Reimbursement (type, claim_type, approval_date, current_status, employee_id) VALUES
('Travel', 'Flight and Hotel', '2024-10-25', 'Approved', 3),
('Travel', 'Meals and Transportation', '2024-11-10', 'Approved', 10),
('Medical', 'Prescription Medication', '2024-11-15', 'Pending', 5),
('Office', 'Home Office Equipment', '2024-11-20', 'Approved', 6);

INSERT INTO Insurance (type, contribution_rate, coverage) VALUES
('Health', 5.500, 'Comprehensive medical, dental, and vision coverage'),
('Life', 1.200, 'Life insurance up to 3x annual salary'),
('Disability', 2.000, 'Short and long-term disability coverage'),
('Dental', 1.500, 'Preventive and major dental procedures');


INSERT INTO Termination (date, reason, contract_id) VALUES
('2024-09-30', 'Voluntary resignation - Career advancement opportunity', 5),
('2024-08-15', 'Contract completion - End of internship period', 7);

INSERT INTO ShiftSchedule (name, type, start_time, end_time, break_duration, shift_date, status, location, allowance_amount)
VALUES
    ('Morning Shift', 'Regular', '08:00:00', '16:00:00', 60, '2024-01-15', 'Active', 'Main Office', 0.00),
    ('Evening Shift', 'Regular', '16:00:00', '00:00:00', 60, '2024-01-15', 'Active', 'Main Office', 50.00),
    ('Night Shift', 'Overnight', '00:00:00', '08:00:00', 60, '2024-01-15', 'Active', 'Main Office', 100.00),
    ('Weekend Shift', 'Weekend', '09:00:00', '17:00:00', 60, '2024-01-20', 'Active', 'Branch Office', 75.00),
    ('Holiday Shift', 'Holiday', '08:00:00', '16:00:00', 60, '2024-12-25', 'Active', 'Main Office', 150.00);


INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status) VALUES
(1, 1, '2024-11-01', NULL, 'Active'),
(2, 1, '2024-11-01', NULL, 'Active'),
(3, 1, '2024-11-01', NULL, 'Active'),
(4, 1, '2024-11-01', NULL, 'Active'),
(5, 4, '2024-11-01', NULL, 'Active'),
(8, 1, '2024-11-01', NULL, 'Active'),
(9, 1, '2024-11-01', NULL, 'Active'),
(10, 1, '2024-11-01', NULL, 'Active');


INSERT INTO Exception (name, category, date, status) VALUES
('Public Holiday - Thanksgiving', 'Holiday', '2024-11-28', 'Active'),
('Company Event', 'Special', '2024-12-15', 'Active'),
('System Maintenance', 'Technical', '2024-12-01', 'Scheduled'),
('Weather Emergency', 'Emergency', '2024-11-20', 'Resolved');

INSERT INTO Attendance (employee_id, shift_id, entry_time, exit_time, duration, login_method, logout_method, exception_id) VALUES
(1, 1, '2024-11-22 07:55:00', '2024-11-22 17:05:00', 540, 'Biometric', 'Biometric', NULL),
(2, 1, '2024-11-22 08:02:00', '2024-11-22 17:00:00', 538, 'Mobile App', 'Mobile App', NULL),
(3, 1, '2024-11-22 08:00:00', '2024-11-22 17:10:00', 550, 'Biometric', 'Biometric', NULL),
(5, 4, '2024-11-22 09:15:00', '2024-11-22 18:20:00', 545, 'Web Portal', 'Web Portal', NULL);

INSERT INTO Device (device_type, terminal_id, latitude, longitude, employee_id) VALUES
('Biometric Scanner', 'BIO-001-NYC', 40.712776, -74.005974, NULL),
('Mobile Device', 'MOB-IPHONE-Sarah', 42.360081, -71.058884, 2),
('Biometric Scanner', 'BIO-002-Cairo', 30.044420, 31.235712, NULL),
('Web Browser', 'WEB-Chrome-Michael', 47.606209, -122.332069, 5);

INSERT INTO AttendanceSource (attendance_id, device_id, source_type, latitude, longitude, recorded_at) VALUES
(1, 1, 'Biometric',  4.0712776,  -7.4005974,  '2024-11-22 07:55:00'),
(2, 2, 'Mobile',     4.2360081,  -7.1058884,  '2024-11-22 08:02:00'),
(3, 3, 'Biometric',  3.0044420,   3.1235712,  '2024-11-22 08:00:00'),
(4, 4, 'Web',        4.7606209,  -8.2332069,  '2024-11-22 09:15:00');

INSERT INTO AttendanceLog (attendance_id, actor, timestamp, reason) VALUES
(2, 2, '2024-11-22 08:02:00', 'Late arrival due to traffic'),
(4, 5, '2024-11-22 09:15:00', 'Flexible schedule adjustment');

INSERT INTO AttendanceCorrectionRequest (employee_id, date, correction_type, reason, status, recorded_by) VALUES
(5, '2024-11-21', 'Missing Punch', 'Forgot to clock out', 'Approved', 3);

INSERT INTO Employee_Exception (employee_id, exception_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1);

INSERT INTO ShiftCycle (cycle_name, description) VALUES
('Standard Week', '5-day work week with weekends off'),
('Rotating Shifts', '3-shift rotation for 24/7 coverage');

INSERT INTO ShiftCycleAssignment (cycle_id, shift_id, order_number) VALUES
(1, 1, 1),
(2, 1, 1),
(2, 2, 2),
(2, 3, 3);

INSERT INTO Leave (leave_type, leave_description) VALUES
('Vacation', 'Annual paid vacation leave'),
('Sick', 'Medical leave for illness or injury'),
('Probation', 'Leave during probation period'),
('Holiday', 'Public and company holidays'),
('Maternity', 'Maternity leave for mothers'),
('Paternity', 'Paternity leave for fathers');

INSERT INTO VacationLeave (leave_id, carry_over_days, approving_manager) VALUES
(1, 5, 1);

INSERT INTO SickLeave (leave_id, medical_cert_required, physician_id) VALUES
(2, 1, NULL);

INSERT INTO ProbationLeave (leave_id, eligibility_start_date, probation_period) VALUES
(3, '2024-09-01', 90);

INSERT INTO HolidayLeave (leave_id, holiday_name, official_recognition, regional_scope) VALUES
(4, 'New Year Day', 1, 'United States');

INSERT INTO LeavePolicy (name, purpose, eligibility_rules, notice_period, special_leave_type, reset_on_new_year) VALUES
('Standard Vacation Policy', 'Annual vacation entitlement', 'Employees after 3 months', 14, NULL, 1),
('Sick Leave Policy', 'Medical leave guidelines', 'All employees', 1, 'Sick', 0),
('Holiday Policy', 'Public holiday observance', 'All employees', 0, 'Holiday', 0);

INSERT INTO LeaveRequest (employee_id, leave_id, justification, duration, approval_timing, status) VALUES
(5, 1, 'Family vacation', 5, '2024-11-01 10:30:00', 'Approved'),
(8, 2, 'Medical appointment', 1, '2024-11-10 09:15:00', 'Approved'),
(7, 1, 'Personal time off', 3, NULL, 'Pending'),
(9, 1, 'Holiday vacation', 7, '2024-11-18 14:20:00', 'Approved');

INSERT INTO LeaveEntitlement (employee_id, leave_type_id, entitlement) VALUES
(1, 1, 25.000),
(2, 1, 22.000),
(3, 1, 20.000),
(4, 1, 20.000),
(5, 1, 20.000),
(8, 1, 20.000),
(9, 1, 20.000),
(10, 1, 20.000),
(1, 2, 10.000),
(2, 2, 10.000),
(3, 2, 10.000),
(4, 2, 10.000),
(5, 2, 10.000);

INSERT INTO LeaveDocument (leave_request_id, file_path, uploaded_at) VALUES
(2, '/documents/medical_cert_001.pdf', '2024-11-10 10:00:00');

INSERT INTO Notification (message_content, timestamp, urgency, read_status, notification_type) VALUES
('Your leave request for December 15-20 has been approved', '2024-11-22 09:30:00', 'Medium', 0, 'Leave'),
('Reminder: Complete your monthly timesheet by November 30', '2024-11-22 08:00:00', 'High', 0, 'Attendance'),
('New payroll policy update effective December 1, 2024', '2024-11-21 14:00:00', 'Medium', 1, 'Payroll'),
('Welcome to the team! Please complete your onboarding checklist', '2024-11-20 10:00:00', 'High', 1, 'Onboarding'),
('Your performance review is scheduled for December 5 at 2:00 PM', '2024-11-22 07:00:00', 'Medium', 0, 'Performance'),
('System maintenance scheduled for December 1, 2024 from 2-4 AM', '2024-11-19 16:00:00', 'Low', 1, 'System'),
('Your reimbursement request has been processed', '2024-11-22 11:00:00', 'Medium', 0, 'Finance'),
('Mandatory training: Cybersecurity Awareness - Due by December 15', '2024-11-18 09:00:00', 'High', 0, 'Training'),
('Team meeting tomorrow at 10 AM in Conference Room A', '2024-11-21 17:00:00', 'Medium', 1, 'Meeting'),
('Your contract renewal is due for review', '2024-11-22 10:30:00', 'High', 0, 'Contract');

INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status, delivered_at) VALUES
(5, 1, 'Delivered', '2024-11-22 09:30:15'),
(5, 2, 'Delivered', '2024-11-22 08:00:10'),
(1, 3, 'Delivered', '2024-11-21 14:00:05'),
(2, 3, 'Delivered', '2024-11-21 14:00:05'),
(3, 3, 'Delivered', '2024-11-21 14:00:05'),
(7, 4, 'Delivered', '2024-11-20 10:00:20'),
(8, 5, 'Delivered', '2024-11-22 07:00:08'),
(1, 6, 'Delivered', '2024-11-19 16:00:12'),
(2, 6, 'Delivered', '2024-11-19 16:00:12'),
(3, 6, 'Delivered', '2024-11-19 16:00:12'),
(5, 7, 'Delivered', '2024-11-22 11:00:05'),
(5, 8, 'Delivered', '2024-11-18 09:00:15'),
(8, 8, 'Delivered', '2024-11-18 09:00:15'),
(3, 9, 'Delivered', '2024-11-21 17:00:10'),
(5, 9, 'Delivered', '2024-11-21 17:00:10'),
(6, 10, 'Delivered', '2024-11-22 10:30:08');

INSERT INTO Payroll (employee_id, taxes, period_start, period_end, base_amount, adjustments, contributions, actual_pay, net_salary, payment_date) VALUES
(1, 8333.333, '2024-11-01', '2024-11-30', 25000.000, 0.000, 1250.000, 25000.000, 15416.667, '2024-11-30'),
(2, 3166.667, '2024-11-01', '2024-11-30', 9500.000, 500.000, 475.000, 10000.000, 6358.333, '2024-11-30'),
(3, 3166.667, '2024-11-01', '2024-11-30', 9500.000, 0.000, 475.000, 9500.000, 5858.333, '2024-11-30'),
(4, 3166.667, '2024-11-01', '2024-11-30', 9500.000, 0.000, 475.000, 9500.000, 5858.333, '2024-11-30'),
(5, 2000.000, '2024-11-01', '2024-11-30', 6000.000, 200.000, 300.000, 6200.000, 3900.000, '2024-11-30'),
(8, 2166.667, '2024-11-01', '2024-11-30', 6500.000, 0.000, 325.000, 6500.000, 4008.333, '2024-11-30'),
(9, 2166.667, '2024-11-01', '2024-11-30', 6500.000, 0.000, 325.000, 6500.000, 4008.333, '2024-11-30'),
(10, 2833.333, '2024-11-01', '2024-11-30', 8500.000, 0.000, 425.000, 8500.000, 5241.667, '2024-11-30');

INSERT INTO AllowanceDeduction (payroll_id, employee_id, type, amount, currency, duration, timezone) VALUES
(1, 1, 'Allowance', 1000.000, 'US Dollar', 30, 'EST'),
(2, 2, 'Allowance', 500.000, 'US Dollar', 30, 'EST'),
(5, 5, 'Allowance', 200.000, 'US Dollar', 30, 'PST'),
(5, 5, 'Deduction', 50.000, 'US Dollar', 30, 'PST');

INSERT INTO PayrollPolicy (effective_date, type, description) VALUES
('2024-01-01', 'Overtime', 'Overtime calculation rules'),
('2024-01-01', 'Lateness', 'Lateness penalty policy'),
('2024-01-01', 'Bonus', 'Performance bonus guidelines'),
('2024-01-01', 'Deduction', 'Standard deduction rules');

INSERT INTO OvertimePolicy (policy_id, weekday_rate_multiplier, weekend_rate_multiplier, max_hours_per_month) VALUES
(1, 1.50, 2.00, 40);

INSERT INTO LatenessPolicy (policy_id, grace_period_mins, deduction_rate) VALUES
(2, 15, 0.50);

INSERT INTO BonusPolicy (policy_id, bonus_type, eligibility_criteria, amount)
VALUES
(1, 'Performance Bonus', 'Employees with performance rating above 4.0', 5000.00),
(2, 'Annual Bonus', 'All full-time employees with 1+ year service', 3000.00),
(3, 'Project Completion Bonus', 'Team members who complete projects on time', 2500.00),
(4, 'Referral Bonus', 'Employees who refer successful hires', 1000.00);


INSERT INTO DeductionPolicy (policy_id, deduction_reason, calculation_mode) VALUES
(4, 'Unauthorized Absence', 'Per day rate');

INSERT INTO PayrollPolicy_ID (payroll_id, policy_id) VALUES
(1, 1),
(2, 1),
(5, 2);

INSERT INTO Payroll_Log (payroll_id, actor, change_date, modification_type) VALUES
(5, 3, '2024-11-15 10:30:00', 'Adjustment Added'),
(2, 2, '2024-11-10 14:20:00', 'Bonus Applied');



INSERT INTO PayrollPeriod (payroll_id, start_date, end_date, status) VALUES
(4, '2024-11-01', '2024-11-30', 'Processed'),
(5, '2024-11-01', '2024-11-30', 'Processed'),
(6, '2024-11-01', '2024-11-30', 'Processed'),
(7, '2024-11-01', '2024-11-30', 'Processed'),
(8, '2024-11-01', '2024-11-30', 'Processed');

-- =============================================
-- TERMINATION
-- =============================================

INSERT INTO Termination (date, reason, contract_id) VALUES
('2024-09-30', 'Voluntary resignation - Career advancement opportunity', 5),
('2024-08-15', 'Contract completion - End of internship period', 7);

-- Insert PayrollSpecialists
-- Note: Assumes Employee table already has these employee_ids
INSERT INTO PayrollSpecialist (employee_id, assigned_region, processing_frequency, last_processed_period)
VALUES
    (1, 'North America', 'Bi-Weekly', '2024-11-15'),
    (2, 'Europe', 'Monthly', '2024-11-01'),
    (3, 'Asia Pacific', 'Bi-Weekly', '2024-11-15'),
    (4, 'Latin America', 'Weekly', '2024-11-18'),
    (5, 'Middle East', 'Monthly', '2024-11-01');
GO

-- Insert ApprovalWorkflows
-- Note: created_by references employee_id from Employee table
INSERT INTO ApprovalWorkflow (workflow_type, threshold_amount, approver_role, created_by, status)
VALUES
    ('Expense Reimbursement', 1000.00, 'Manager', 1, 'Active'),
    ('Purchase Order', 5000.00, 'Director', 2, 'Active'),
    ('Budget Approval', 10000.00, 'VP Finance', 1, 'Active'),
    ('Payroll Adjustment', 2500.00, 'HR Manager', 3, 'Active'),
    ('Vendor Payment', 7500.00, 'Finance Manager', 2, 'Inactive'),
    ('Contract Approval', 15000.00, 'Legal', 4, 'Active');
GO

-- Insert ApprovalWorkflowSteps
-- Note: role_id must exist in Role table
INSERT INTO ApprovalWorkflowStep (workflow_id, step_number, role_id, action_required)
VALUES
    -- Expense Reimbursement workflow (workflow_id = 1)
    (1, 1, 3, 'Review expense report and receipts'),
    (1, 2, 2, 'Verify budget availability'),
    (1, 3, 5, 'Final approval and process payment'),

    -- Purchase Order workflow (workflow_id = 2)
    (2, 1, 3, 'Review purchase requisition'),
    (2, 2, 2, 'Approve vendor selection'),
    (2, 3, 1, 'Authorize purchase order'),

    -- Budget Approval workflow (workflow_id = 3)
    (3, 1, 3, 'Review budget proposal'),
    (3, 2, 2, 'Financial analysis and recommendation'),
    (3, 3, 1, 'Executive approval'),

    -- Payroll Adjustment workflow (workflow_id = 4)
    (4, 1, 5, 'Verify adjustment request'),
    (4, 2, 2, 'HR approval'),

    -- Vendor Payment workflow (workflow_id = 5)
    (5, 1, 2, 'Verify invoice and delivery'),
    (5, 2, 3, 'Approve payment'),

    -- Contract Approval workflow (workflow_id = 6)
    (6, 1, 6, 'Legal review of contract terms'),
    (6, 2, 2, 'Financial impact assessment'),
    (6, 3, 1, 'Executive sign-off');
GO