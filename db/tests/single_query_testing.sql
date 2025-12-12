USE HRMS_DB;
GO

SELECT Name
FROM sys.Tables
ORDER BY Name;

SELECT 'Employee'           AS TableName, COUNT(*) FROM Employee           UNION ALL
SELECT 'Department',                     COUNT(*) FROM Department         UNION ALL
SELECT 'Position',                       COUNT(*) FROM Position           UNION ALL
SELECT 'Role',                           COUNT(*) FROM Role               UNION ALL
SELECT 'Employee_Role',                  COUNT(*) FROM Employee_Role      UNION ALL
SELECT 'Skill',                          COUNT(*) FROM Skill              UNION ALL
SELECT 'Employee_Skill',                 COUNT(*) FROM Employee_Skill     UNION ALL
SELECT 'Verification',                   COUNT(*) FROM Verification       UNION ALL
SELECT 'Employee_Verification',          COUNT(*) FROM Employee_Verification UNION ALL
SELECT 'ShiftSchedule',                  COUNT(*) FROM ShiftSchedule      UNION ALL
SELECT 'Attendance',                     COUNT(*) FROM Attendance         UNION ALL
SELECT 'Leave',                          COUNT(*) FROM [Leave]            UNION ALL
SELECT 'LeaveRequest',                   COUNT(*) FROM LeaveRequest       UNION ALL
SELECT 'Payroll',                        COUNT(*) FROM Payroll            UNION ALL
SELECT 'AllowanceDeduction',             COUNT(*) FROM AllowanceDeduction UNION ALL
SELECT 'PayrollPolicy',                  COUNT(*) FROM PayrollPolicy      UNION ALL
SELECT 'Notification',                   COUNT(*) FROM Notification       UNION ALL
SELECT 'Employee_Notification',          COUNT(*) FROM Employee_Notification;

SELECT
    e.employee_id,
    e.full_name,
    h.manager_id,
    m.full_name AS manager_name,
    h.hierarchy_level
FROM EmployeeHierarchy h
JOIN Employee e ON h.employee_id = e.employee_id
JOIN Employee m ON h.manager_id  = m.employee_id
ORDER BY h.hierarchy_level, m.employee_id, e.employee_id;