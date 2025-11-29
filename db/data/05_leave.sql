
USE HRMS_DB;
GO

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
