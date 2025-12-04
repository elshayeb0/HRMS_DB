USE HRMS_DB; 
GO

-- Shift schedule definitions.
INSERT INTO ShiftSchedule (name, type, start_time, end_time, break_duration, shift_date, status, location, allowance_amount)
VALUES
    ('Morning Shift', 'Regular', '08:00:00', '16:00:00', 60, '2024-01-15', 'Active', 'Main Office', 0.00), -- standard morning shift
    ('Evening Shift', 'Regular', '16:00:00', '00:00:00', 60, '2024-01-15', 'Active', 'Main Office', 50.00), -- evening shift with allowance
    ('Night Shift', 'Overnight', '00:00:00', '08:00:00', 60, '2024-01-15', 'Active', 'Main Office', 100.00), -- overnight shift
    ('Weekend Shift', 'Weekend', '09:00:00', '17:00:00', 60, '2024-01-20', 'Active', 'Branch Office', 75.00), -- weekend coverage
    ('Holiday Shift', 'Holiday', '08:00:00', '16:00:00', 60, '2024-12-25', 'Active', 'Main Office', 150.00); -- holiday staffing


-- Assign employees to shifts.
INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status) VALUES
(1, 1, '2024-11-01', NULL, 'Active'),
(2, 1, '2024-11-01', NULL, 'Active'),
(3, 1, '2024-11-01', NULL, 'Active'),
(4, 1, '2024-11-01', NULL, 'Active'),
(5, 4, '2024-11-01', NULL, 'Active'),
(8, 1, '2024-11-01', NULL, 'Active'),
(9, 1, '2024-11-01', NULL, 'Active'),
(10, 1, '2024-11-01', NULL, 'Active');


-- Exception days impacting attendance.
INSERT INTO Exception (name, category, date, status) VALUES
('Public Holiday - Thanksgiving', 'Holiday', '2024-11-28', 'Active'),
('Company Event', 'Special', '2024-12-15', 'Active'),
('System Maintenance', 'Technical', '2024-12-01', 'Scheduled'),
('Weather Emergency', 'Emergency', '2024-11-20', 'Resolved');

-- Attendance events captured for assigned shifts.
INSERT INTO Attendance (employee_id, shift_id, entry_time, exit_time, duration, login_method, logout_method, exception_id) VALUES
(1, 1, '2024-11-22 07:55:00', '2024-11-22 17:05:00', 540, 'Biometric', 'Biometric', NULL),
(2, 1, '2024-11-22 08:02:00', '2024-11-22 17:00:00', 538, 'Mobile App', 'Mobile App', NULL),
(3, 1, '2024-11-22 08:00:00', '2024-11-22 17:10:00', 550, 'Biometric', 'Biometric', NULL),
(5, 4, '2024-11-22 09:15:00', '2024-11-22 18:20:00', 545, 'Web Portal', 'Web Portal', NULL);

-- Devices available for tracking attendance.
INSERT INTO Device (device_type, terminal_id, latitude, longitude, employee_id) VALUES
('Biometric Scanner', 'BIO-001-NYC', 40.712776, -74.005974, NULL),
('Mobile Device', 'MOB-IPHONE-Sarah', 42.360081, -71.058884, 2),
('Biometric Scanner', 'BIO-002-Cairo', 30.044420, 31.235712, NULL),
('Web Browser', 'WEB-Chrome-Michael', 47.606209, -122.332069, 5);

-- Map attendance events to capture sources and locations.
INSERT INTO AttendanceSource (attendance_id, device_id, source_type, latitude, longitude, recorded_at) VALUES
(1, 1, 'Biometric', 40.712776000, -74.005974000, '2024-11-22 07:55:00'),
(2, 2, 'Mobile', 42.360081000, -71.058884000, '2024-11-22 08:02:00'),
(3, 3, 'Biometric', 30.044420000, 31.235712000, '2024-11-22 08:00:00'),
(4, 4, 'Web', 47.606209000, -122.332069000, '2024-11-22 09:15:00');

INSERT INTO AttendanceLog (attendance_id, actor, timestamp, reason) VALUES
(2, 2, '2024-11-22 08:02:00', 'Late arrival due to traffic'),
(4, 5, '2024-11-22 09:15:00', 'Flexible schedule adjustment');

-- Employee-submitted corrections.
INSERT INTO AttendanceCorrectionRequest (employee_id, date, correction_type, reason, status, recorded_by) VALUES
(5, '2024-11-21', 'Missing Punch', 'Forgot to clock out', 'Approved', 3);

-- Link employees to applicable exceptions.
INSERT INTO Employee_Exception (employee_id, exception_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1);

-- Shift cycle templates.
INSERT INTO ShiftCycle (cycle_name, description) VALUES
('Standard Week', '5-day work week with weekends off'),
('Rotating Shifts', '3-shift rotation for 24/7 coverage');

-- Order shifts within each cycle.
INSERT INTO ShiftCycleAssignment (cycle_id, shift_id, order_number) VALUES
(1, 1, 1),
(2, 1, 1),
(2, 2, 2),
(2, 3, 3);
