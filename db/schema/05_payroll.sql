-- =============================================
-- File: 05_payroll.sql
-- Project: HRMS_DB - Milestone 2

-- Purpose: Payroll, salary types + subtypes, currencies,
--          allowances/deductions, payroll policies + subtypes,
--          payroll logs, payroll periods

-- Dependencies: 01_core_hr.sql, 02_contracts_missions.sql
-- Run order: Schema step 5
-- =============================================

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


CREATE TABLE SalaryType (
    salary_type_id INT IDENTITY(1,1) PRIMARY KEY,
    type VARCHAR(40) NOT NULL,
    payment_frequency VARCHAR(60),
    currency VARCHAR(20),
    FOREIGN KEY (currency) REFERENCES Currency(CurrencyCode)
);
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

CREATE TABLE Currency (
    CurrencyCode VARCHAR(11) PRIMARY KEY,
    CurrencyName VARCHAR(65) NOT NULL,
    ExchangeRate DECIMAL(13,5) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    LastUpdated DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE AllowanceDeduction (
    ad_id INT IDENTITY(1,1) PRIMARY KEY,
    payroll_id INT,
    employee_id INT,
    type VARCHAR(60),
    amount DECIMAL(11,3),
    currency VARCHAR(12),
    duration INT,
    timezone VARCHAR(60),
    FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (currency) REFERENCES Currency(CurrencyCode)
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

CREATE TABLE PayGrade (
    pay_grade_id INT IDENTITY(1,1) PRIMARY KEY,
    grade_name VARCHAR(60) NOT NULL,
    min_salary DECIMAL(11,3),
    max_salary DECIMAL(11,3)
);
GO

CREATE TABLE PayrollSpecialist (
    employee_id INT PRIMARY KEY,
    assigned_region VARCHAR(100),
    processing_frequency VARCHAR(50),
    last_processed_period DATE,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO