-- =============================================
-- File: 03_contracts_missions.sql
-- Project: HRMS_DB - Milestone 2

-- Purpose: Insert contracts and subtypes, missions, reimbursements,
--          insurance and termination records

-- Dependencies: 02_employees.sql
-- Run order: Data step 3
-- =============================================

USE HRMS_DB;
GO
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

