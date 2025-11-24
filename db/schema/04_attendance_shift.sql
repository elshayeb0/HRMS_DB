-- =============================================
-- File: 04_attendance_shift.sql
-- Project: HRMS_DB - Milestone 2

-- Purpose: Attendance, attendance logs, correction requests,
--          shift schedules, shift assignments, exceptions,
--          devices, attendance sources, shift cycles

-- Dependencies: 01_core_hr.sql
-- Run order: Schema step 4
-- =============================================

USE HRMS_DB;
GO

CREATE TABLE ShiftSchedule (
    shift_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(60),
    type VARCHAR(60),
    start_time TIME,
    end_time TIME,
    break_duration INT,
    shift_date DATE,
    status VARCHAR(80),
    location VARCHAR(200)
);
GO

CREATE TABLE ShiftAssignment (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT,
    shift_id INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(60),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id)
);
GO

CREATE TABLE Exception (
    exception_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(200),
    category VARCHAR(60),
    date DATE,
    status VARCHAR(60)
);
GO

CREATE TABLE Attendance (
    attendance_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT,
    shift_id INT,
    entry_time DATETIME,
    exit_time DATETIME,
    duration INT,
    login_method VARCHAR(60),
    logout_method VARCHAR(110),
    exception_id INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id),
    FOREIGN KEY (exception_id) REFERENCES Exception(exception_id)
);
GO

CREATE TABLE AttendanceLog (
    attendance_log_id INT IDENTITY(1,1) PRIMARY KEY,
    attendance_id INT,
    actor INT,
    timestamp DATETIME,
    reason VARCHAR(600),
    FOREIGN KEY (attendance_id) REFERENCES Attendance(attendance_id)
);
GO

CREATE TABLE AttendanceCorrectionRequest (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT,
    date DATE,
    correction_type VARCHAR(50),
    reason VARCHAR(500),
    status VARCHAR(50),
    recorded_by INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (recorded_by) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Employee_Exception (
    employee_id INT,
    exception_id INT,
    PRIMARY KEY (employee_id, exception_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (exception_id) REFERENCES Exception(exception_id)
);
GO

CREATE TABLE Device (
    device_id INT IDENTITY(1,1) PRIMARY KEY,
    device_type VARCHAR(60),
    terminal_id VARCHAR(70),
    latitude DECIMAL(11,6),
    longitude DECIMAL(12,8),
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE AttendanceSource (
    attendance_id INT,
    device_id INT,
    source_type VARCHAR(60),
    latitude DECIMAL(10,9),
    longitude DECIMAL(12,8),
    recorded_at DATETIME,
    PRIMARY KEY (attendance_id, device_id),
    FOREIGN KEY (attendance_id) REFERENCES Attendance(attendance_id),
    FOREIGN KEY (device_id) REFERENCES Device(device_id)
);
GO

CREATE TABLE ShiftCycle (
    cycle_id INT IDENTITY(1,1) PRIMARY KEY,
    cycle_name VARCHAR(50),
    description VARCHAR(500)
);
GO

CREATE TABLE ShiftCycleAssignment (
    cycle_id INT,
    shift_id INT,
    order_number INT,
    PRIMARY KEY (cycle_id, shift_id),
    FOREIGN KEY (cycle_id) REFERENCES ShiftCycle(cycle_id),
    FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id)
);
GO