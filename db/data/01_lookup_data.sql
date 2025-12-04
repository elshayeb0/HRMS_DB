USE HRMS_DB;
GO

-- Seed departments with purposes; heads left null for initial load.
INSERT INTO Department (department_name, purpose, department_head_id) VALUES
('Executive', 'Company leadership and strategic direction', NULL), -- executive leadership team
('Human Resources', 'Employee management and development', NULL), -- HR department
('Information Technology', 'Technology infrastructure and support', NULL), -- IT group
('Finance', 'Financial management and reporting', NULL), -- finance department
('Sales', 'Revenue generation and client relations', NULL), -- sales organization
('Marketing', 'Brand and market development', NULL); -- marketing organization

-- Seed positions aligned to departments.
INSERT INTO Position (position_title, responsibilities, status) VALUES
('CEO', 'Overall company strategy and operations', 'Active'), -- chief executive role
('HR Manager', 'Human resources management and policy implementation', 'Active'), -- HR lead
('IT Manager', 'Information technology infrastructure management', 'Active'), -- IT lead
('Finance Manager', 'Financial planning and accounting oversight', 'Active'), -- finance lead
('Software Engineer', 'Software development and maintenance', 'Active'), -- engineering IC
('HR Specialist', 'Recruitment and employee relations', 'Active'), -- HR specialist
('Accountant', 'Financial record keeping and reporting', 'Active'), -- accounting staff
('Sales Manager', 'Sales team leadership and strategy', 'Active'), -- sales leadership
('Marketing Specialist', 'Marketing campaigns and brand management', 'Active'), -- marketing IC
('System Administrator', 'IT systems maintenance and security', 'Active'); -- infrastructure admin

-- Seed supported currencies with exchange rates.
INSERT INTO Currency (CurrencyCode, CurrencyName, ExchangeRate) VALUES
('USD', 'US Dollar', 1.00000), -- base currency
('EUR', 'Euro', 0.92000), -- euro reference rate
('GBP', 'British Pound', 0.79000), -- pound reference rate
('EGP', 'Egyptian Pound', 30.90000), -- EGP rate
('SAR', 'Saudi Riyal', 3.75000); -- SAR rate

-- Seed salary types tied to currencies and payment cadence.
INSERT INTO SalaryType (type, payment_frequency, currency) VALUES
('Monthly', 'Monthly', 'US Dollar'), -- monthly USD salary
('Hourly', 'Bi-Weekly', 'US Dollar'), -- hourly USD paid bi-weekly
('Contract', 'Milestone', 'US Dollar'), -- milestone-based USD contract
('Monthly', 'Monthly', 'Egyptian Pound'), -- monthly EGP salary
('Hourly', 'Weekly', 'Euro'); -- hourly EUR paid weekly

-- Hourly salary type specifics.
INSERT INTO HourlySalaryType (salary_type_id, hourly_rate, max_monthly_hours) VALUES
(2, 45.000, 160), -- USD hourly rate
(5, 38.000, 160); -- EUR hourly rate

-- Monthly salary type specifics.
INSERT INTO MonthlySalaryType (salary_type_id, tax_rule, contribution_scheme) VALUES
(1, 'Federal and State progressive tax', 'Standard 401k matching'), -- US monthly tax and benefits
(4, 'Egyptian progressive tax rates', 'Social insurance contribution'); -- EGP monthly tax and benefits

-- Contract salary type specifics.
INSERT INTO ContractSalaryType (salary_type_id, contract_value, installment_details) VALUES
(3, 75000.000, 'Quarterly payments of $18,750'); -- USD contract with quarterly installments


-- Pay grade ladder values.
INSERT INTO PayGrade (grade_name, min_salary, max_salary) VALUES
('Entry Level', 30000.000, 45000.000), -- entry-level range
('Junior', 45000.000, 65000.000), -- junior range
('Mid-Level', 65000.000, 90000.000), -- mid-level range
('Senior', 90000.000, 130000.000), -- senior range
('Lead', 130000.000, 180000.000), -- lead range
('Executive', 180000.000, 300000.000); -- executive range


-- Tax form templates by jurisdiction.
INSERT INTO TaxForm (jurisdiction, validity_period, form_content) VALUES
('Federal US', 365, 'W-4 Employee Withholding Certificate'), -- US federal form
('Egypt', 365, 'Egyptian Tax Declaration Form'), -- Egypt tax form
('Saudi Arabia', 365, 'KSA Tax Registration Form'), -- KSA tax form
('UK', 365, 'P45 - Details of employee leaving work'); -- UK P45 form
