-- =============================================
-- File: 01_lookup_data.sql
-- Project: HRMS_DB - Milestone 2

-- Purpose: Insert lookup/reference data
--          (Departments, Positions, 
--           Salary types, PayGrades, Currencies, etc.)

-- Dependencies: All schema scripts
-- Run order: Data step 1
-- =============================================

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
('Monthly', 'Monthly', 'USD'),
('Hourly', 'Bi-Weekly', 'USD'),
('Contract', 'Milestone', 'USD'),
('Monthly', 'Monthly', 'EGP'),
('Hourly', 'Weekly', 'EUR');

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

