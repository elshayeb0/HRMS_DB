-- Payroll schema: payroll records, salary types, policies, and related entities.
USE HRMS_DB;
GO

CREATE TABLE Payroll ( -- payroll run per employee per period
    payroll_id INT IDENTITY(1,1) PRIMARY KEY, -- unique payroll record
    employee_id INT, -- FK to employee being paid
    taxes DECIMAL(11,3), -- tax amount for the period
    period_start DATE, -- start date of payroll period
    period_end DATE, -- end date of payroll period
    base_amount DECIMAL(11,3), -- base salary before adjustments
    adjustments DECIMAL(11,3), -- manual adjustments applied
    contributions DECIMAL(11,3), -- employer/employee contributions
    actual_pay DECIMAL(11,3), -- gross pay after adjustments
    net_salary DECIMAL(11,3), -- net salary after deductions
    payment_date DATE, -- date payment issued
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) -- enforce employee existence
);
GO -- complete Payroll definition


CREATE TABLE Currency ( -- supported currencies
    CurrencyCode VARCHAR(11) PRIMARY KEY, -- ISO or custom code
    CurrencyName VARCHAR(65) NOT NULL UNIQUE, -- descriptive currency name
    ExchangeRate DECIMAL(13,5) NOT NULL, -- exchange rate to base currency
    CreatedDate DATETIME DEFAULT GETDATE(), -- timestamp of creation
    LastUpdated DATETIME DEFAULT GETDATE() -- last update timestamp
);
GO -- complete Currency definition

CREATE TABLE SalaryType ( -- salary payment archetypes
    salary_type_id INT IDENTITY(1,1) PRIMARY KEY, -- unique salary type id
    type VARCHAR(40) NOT NULL, -- type label (Hourly/Monthly/Contract)
    payment_frequency VARCHAR(60), -- pay cadence descriptor
    currency VARCHAR(65), -- FK to CurrencyName
    FOREIGN KEY (currency) REFERENCES Currency(CurrencyName) -- enforce currency existence
);
GO -- complete SalaryType definition

ALTER TABLE Employee -- attach salary type to employee
ADD CONSTRAINT FK_Employee_SalaryType FOREIGN KEY (salary_type_id) REFERENCES SalaryType(salary_type_id);
GO -- finalize Employee alteration

CREATE TABLE HourlySalaryType ( -- details for hourly salary types
    salary_type_id INT PRIMARY KEY, -- PK/FK to SalaryType
    hourly_rate DECIMAL(11,3), -- wage per hour
    max_monthly_hours INT, -- maximum hours per month
    FOREIGN KEY (salary_type_id) REFERENCES SalaryType(salary_type_id) -- enforce salary type existence
);
GO -- complete HourlySalaryType definition

CREATE TABLE MonthlySalaryType ( -- details for monthly salary types
    salary_type_id INT PRIMARY KEY, -- PK/FK to SalaryType
    tax_rule VARCHAR(150), -- tax rule applied
    contribution_scheme VARCHAR(150), -- benefits or pension scheme
    FOREIGN KEY (salary_type_id) REFERENCES SalaryType(salary_type_id) -- enforce salary type existence
);
GO -- complete MonthlySalaryType definition



CREATE TABLE ContractSalaryType ( -- details for contract-based pay
    salary_type_id INT PRIMARY KEY, -- PK/FK to SalaryType
    contract_value DECIMAL(11,3), -- total contract value
    installment_details VARCHAR(505), -- payment schedule details
    FOREIGN KEY (salary_type_id) REFERENCES SalaryType(salary_type_id) -- enforce salary type existence
);
GO -- complete ContractSalaryType definition

CREATE TABLE AllowanceDeduction ( -- allowances and deductions tied to payroll
    ad_id INT IDENTITY(1,1) PRIMARY KEY, -- unique allowance/deduction id
    payroll_id INT, -- FK to Payroll
    employee_id INT, -- FK to Employee
    type VARCHAR(60), -- type (allowance or deduction)
    amount DECIMAL(11,3), -- monetary value
    currency VARCHAR(65), -- FK to CurrencyName
    duration INT, -- applicable duration (e.g., months)
    timezone VARCHAR(60), -- timezone context for timing rules
    FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id), -- enforce payroll existence
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (currency) REFERENCES Currency(CurrencyName) -- enforce currency existence
);
GO -- complete AllowanceDeduction definition


CREATE TABLE PayrollPolicy ( -- overarching payroll policies
    policy_id INT IDENTITY(1,1) PRIMARY KEY, -- unique policy id
    effective_date DATE, -- date policy starts
    type VARCHAR(50), -- policy type/category
    description VARCHAR(MAX) -- explanation of policy
);
GO -- complete PayrollPolicy definition

CREATE TABLE OvertimePolicy ( -- overtime-specific rules
    policy_id INT PRIMARY KEY, -- PK/FK to PayrollPolicy
    weekday_rate_multiplier DECIMAL(3,2), -- overtime multiplier on weekdays
    weekend_rate_multiplier DECIMAL(3,2), -- overtime multiplier on weekends
    max_hours_per_month INT, -- cap on overtime hours
    FOREIGN KEY (policy_id) REFERENCES PayrollPolicy(policy_id) -- enforce policy existence
);
GO -- complete OvertimePolicy definition

CREATE TABLE LatenessPolicy ( -- lateness penalties
    policy_id INT PRIMARY KEY, -- PK/FK to PayrollPolicy
    grace_period_mins INT, -- allowed minutes late before penalty
    deduction_rate DECIMAL(6,2), -- deduction applied for lateness
    FOREIGN KEY (policy_id) REFERENCES PayrollPolicy(policy_id) -- enforce policy existence
);
GO -- complete LatenessPolicy definition

CREATE TABLE BonusPolicy ( -- rules for bonuses
    policy_id INT PRIMARY KEY, -- PK/FK to PayrollPolicy
    bonus_type VARCHAR(60), -- type of bonus
    eligibility_criteria VARCHAR(MAX), -- who qualifies
    amount DECIMAL(10,2), -- bonus amount or rate
    FOREIGN KEY (policy_id) REFERENCES PayrollPolicy(policy_id) -- enforce policy existence
);
GO -- complete BonusPolicy definition

CREATE TABLE DeductionPolicy ( -- rules for deductions
    policy_id INT PRIMARY KEY, -- PK/FK to PayrollPolicy
    deduction_reason VARCHAR(150), -- reason for deduction
    calculation_mode VARCHAR(60), -- how deduction is calculated
    FOREIGN KEY (policy_id) REFERENCES PayrollPolicy(policy_id) -- enforce policy existence
);
GO -- complete DeductionPolicy definition

CREATE TABLE PayrollPolicy_ID ( -- link payroll runs to policies
    payroll_id INT, -- FK to Payroll
    policy_id INT, -- FK to PayrollPolicy
    PRIMARY KEY (payroll_id, policy_id), -- composite PK prevents duplicates
    FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id), -- enforce payroll existence
    FOREIGN KEY (policy_id) REFERENCES PayrollPolicy(policy_id) -- enforce policy existence
);
GO -- complete PayrollPolicy_ID definition

CREATE TABLE Payroll_Log ( -- audit trail for payroll changes
    payroll_log_id INT IDENTITY(1,1) PRIMARY KEY, -- unique log entry id
    payroll_id INT, -- FK to Payroll
    actor INT, -- identifier of user making change
    change_date DATETIME, -- timestamp of change
    modification_type VARCHAR(50), -- type of modification
    FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id) -- enforce payroll existence
);
GO -- complete Payroll_Log definition

CREATE TABLE PayrollPeriod ( -- payroll period master
    payroll_period_id INT IDENTITY(1,1) PRIMARY KEY, -- unique period id
    payroll_id INT, -- FK to Payroll
    start_date DATE, -- start date of period
    end_date DATE, -- end date of period
    status VARCHAR(50), -- status of the period
    FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id) -- enforce payroll existence
);
GO -- complete PayrollPeriod definition


CREATE TABLE TaxForm ( -- tax forms available to employees
    tax_form_id INT IDENTITY(1,1) PRIMARY KEY, -- unique tax form id
    jurisdiction VARCHAR(150), -- jurisdiction of the form
    validity_period INT, -- days of validity
    form_content VARCHAR(MAX) -- description or serialized form template
);
GO -- complete TaxForm definition

ALTER TABLE Employee -- attach tax form FK
ADD CONSTRAINT FK_Employee_TaxForm FOREIGN KEY (tax_form_id) REFERENCES TaxForm(tax_form_id);
GO -- finalize Employee alteration for tax forms

CREATE TABLE PayGrade ( -- pay grade ladder
    pay_grade_id INT IDENTITY(1,1) PRIMARY KEY, -- unique pay grade id
    grade_name VARCHAR(60) NOT NULL, -- grade label
    min_salary DECIMAL(11,3), -- lower salary bound
    max_salary DECIMAL(11,3) -- upper salary bound
);
GO -- complete PayGrade definition

ALTER TABLE Employee -- attach pay grade FK
ADD CONSTRAINT FK_Employee_PayGrade FOREIGN KEY (pay_grade) REFERENCES PayGrade(pay_grade_id);
GO -- finalize Employee alteration for pay grade

CREATE TABLE PayrollSpecialist ( -- payroll specialist assignments
    employee_id INT PRIMARY KEY, -- FK/PK to employee fulfilling role
    assigned_region VARCHAR(100), -- region handled
    processing_frequency VARCHAR(50), -- cadence of processing
    last_processed_period DATE, -- last period processed
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) -- enforce employee existence
);
GO -- complete PayrollSpecialist definition
