USE HRMS_DB;
GO


-- Create 5 pending missions for Employee 6 (David Wilson) managed by Sarah Johnson (ID 2)
INSERT INTO Mission (destination, start_date, end_date, status, employee_id, manager_id)
VALUES 
('Tokyo, Japan', '2025-02-10', '2025-02-15', 'Pending', 6, 2),
('Sydney, Australia', '2025-02-20', '2025-02-28', 'Pending', 6, 2),
('Toronto, Canada', '2025-03-05', '2025-03-10', 'Pending', 6, 2),
('Singapore', '2025-03-15', '2025-03-20', 'Pending', 6, 2),
('Bangkok, Thailand', '2025-03-25', '2025-03-30', 'Pending', 6, 2);