

USE HRMS_DB;
GO

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
(1, 1, 'Allowance', 1000.000, 'USD', 30, 'EST'),
(2, 2, 'Allowance', 500.000, 'USD', 30, 'EST'),
(5, 5, 'Allowance', 200.000, 'USD', 30, 'PST'),
(5, 5, 'Deduction', 50.000, 'USD', 30, 'PST');

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
    (4, 'Referral Bonus', 'Employees who refer successful hires', 1000.00),
    (5, 'Holiday Bonus', 'All active employees during holiday season', 1500.00);


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
    (101, 'North America', 'Bi-Weekly', '2024-11-15'),
    (102, 'Europe', 'Monthly', '2024-11-01'),
    (103, 'Asia Pacific', 'Bi-Weekly', '2024-11-15'),
    (104, 'Latin America', 'Weekly', '2024-11-18'),
    (105, 'Middle East', 'Monthly', '2024-11-01');
GO

-- Insert ApprovalWorkflows
-- Note: created_by references employee_id from Employee table
INSERT INTO ApprovalWorkflow (workflow_type, threshold_amount, approver_role, created_by, status)
VALUES
    ('Expense Reimbursement', 1000.00, 'Manager', 101, 'Active'),
    ('Purchase Order', 5000.00, 'Director', 102, 'Active'),
    ('Budget Approval', 10000.00, 'VP Finance', 101, 'Active'),
    ('Payroll Adjustment', 2500.00, 'HR Manager', 103, 'Active'),
    ('Vendor Payment', 7500.00, 'Finance Manager', 102, 'Inactive'),
    ('Contract Approval', 15000.00, 'Legal', 104, 'Active');
GO

-- Insert ApprovalWorkflowSteps
-- Note: role_id must exist in Role table
INSERT INTO ApprovalWorkflowStep (workflow_id, step_number, role_id, action_required)
VALUES
    -- Expense Reimbursement workflow (workflow_id = 1)
    (1, 1, 201, 'Review expense report and receipts'),
    (1, 2, 202, 'Verify budget availability'),
    (1, 3, 203, 'Final approval and process payment'),

    -- Purchase Order workflow (workflow_id = 2)
    (2, 1, 204, 'Review purchase requisition'),
    (2, 2, 205, 'Approve vendor selection'),
    (2, 3, 206, 'Authorize purchase order'),

    -- Budget Approval workflow (workflow_id = 3)
    (3, 1, 207, 'Review budget proposal'),
    (3, 2, 208, 'Financial analysis and recommendation'),
    (3, 3, 209, 'Executive approval'),

    -- Payroll Adjustment workflow (workflow_id = 4)
    (4, 1, 210, 'Verify adjustment request'),
    (4, 2, 211, 'HR approval'),

    -- Vendor Payment workflow (workflow_id = 5)
    (5, 1, 212, 'Verify invoice and delivery'),
    (5, 2, 213, 'Approve payment'),

    -- Contract Approval workflow (workflow_id = 6)
    (6, 1, 214, 'Legal review of contract terms'),
    (6, 2, 215, 'Financial impact assessment'),
    (6, 3, 216, 'Executive sign-off');
GO