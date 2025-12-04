-- Attendance and shift tracking schema: schedules, assignments, logs, and devices.
USE HRMS_DB;
GO

-- Shift definitions including timing and allowances.
CREATE TABLE ShiftSchedule ( -- master list of shifts
    shift_id INT IDENTITY(1,1) PRIMARY KEY, -- unique shift id
    name VARCHAR(60), -- shift label
    type VARCHAR(60), -- shift category (e.g., standard/night)
    start_time TIME, -- shift start time
    end_time TIME, -- shift end time
    break_duration INT, -- allocated break length in minutes
    shift_date DATE, -- date when the shift applies
    status VARCHAR(80), -- status of the shift
    location VARCHAR(200), -- location for the shift
    allowance_amount DECIMAL(10,2) DEFAULT 0 -- optional allowance tied to the shift
);
GO -- complete ShiftSchedule definition

-- Assignment of employees to specific shifts for a date range.
CREATE TABLE ShiftAssignment ( -- assignments of employees to shifts
    assignment_id INT IDENTITY(1,1) PRIMARY KEY, -- unique assignment id
    employee_id INT, -- FK to Employee
    shift_id INT, -- FK to ShiftSchedule
    start_date DATE, -- assignment start date
    end_date DATE, -- assignment end date
    status VARCHAR(60), -- assignment status
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id) -- enforce shift existence
);
GO -- complete ShiftAssignment definition

-- Catalog of exceptions (e.g., holidays, outages) affecting attendance.
CREATE TABLE Exception ( -- list of exception days/items
    exception_id INT IDENTITY(1,1) PRIMARY KEY, -- unique exception id
    name VARCHAR(200), -- name/label of exception
    category VARCHAR(60), -- exception category (holiday, outage)
    date DATE, -- date of exception
    status VARCHAR(60) -- current status
);
GO -- complete Exception definition

-- Captured attendance per employee and shift with optional exception.
CREATE TABLE Attendance ( -- recorded attendance events
    attendance_id INT IDENTITY(1,1) PRIMARY KEY, -- unique attendance id
    employee_id INT, -- FK to Employee
    shift_id INT, -- FK to ShiftSchedule
    entry_time DATETIME, -- clock-in timestamp
    exit_time DATETIME, -- clock-out timestamp
    duration INT, -- total duration in minutes
    login_method VARCHAR(60), -- how the user logged in
    logout_method VARCHAR(110), -- how the user logged out
    exception_id INT, -- optional FK to Exception
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id), -- enforce shift existence
    FOREIGN KEY (exception_id) REFERENCES Exception(exception_id) -- enforce exception existence
);
GO -- complete Attendance definition

-- Audit log for attendance changes.
CREATE TABLE AttendanceLog ( -- audit trail of attendance edits
    attendance_log_id INT IDENTITY(1,1) PRIMARY KEY, -- unique log entry id
    attendance_id INT, -- FK to Attendance entry
    actor INT, -- FK to Employee who made change
    timestamp DATETIME, -- when the change was made
    reason VARCHAR(600), -- reason for the adjustment
    FOREIGN KEY (attendance_id) REFERENCES Attendance(attendance_id), -- enforce attendance existence
    FOREIGN KEY (actor) REFERENCES Employee(employee_id) -- enforce actor existence
);
GO -- complete AttendanceLog definition

-- Requests to correct attendance entries.
CREATE TABLE AttendanceCorrectionRequest ( -- corrections submitted by employees
    request_id INT IDENTITY(1,1) PRIMARY KEY, -- unique request id
    employee_id INT, -- FK to employee needing correction
    date DATE, -- date being corrected
    correction_type VARCHAR(50), -- type of correction requested
    reason VARCHAR(500), -- justification text
    status VARCHAR(50), -- current request status
    recorded_by INT, -- FK to employee who recorded the request
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (recorded_by) REFERENCES Employee(employee_id) -- enforce recorder existence
);
GO -- complete AttendanceCorrectionRequest definition

-- Map employees to exceptions that apply to them.
CREATE TABLE Employee_Exception ( -- junction of employees to exceptions
    employee_id INT, -- FK to employee
    exception_id INT, -- FK to exception
    PRIMARY KEY (employee_id, exception_id), -- composite PK prevents duplicates
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id), -- enforce employee existence
    FOREIGN KEY (exception_id) REFERENCES Exception(exception_id) -- enforce exception existence
);
GO -- complete Employee_Exception definition

-- Devices used for clock-in/out tracking.
CREATE TABLE Device ( -- devices tied to attendance events
    device_id INT IDENTITY(1,1) PRIMARY KEY, -- unique device id
    device_type VARCHAR(60), -- type of device (mobile, kiosk)
    terminal_id VARCHAR(70), -- device identifier
    latitude DECIMAL(11,6), -- device latitude
    longitude DECIMAL(12,8), -- device longitude
    employee_id INT, -- FK to employee assigned to device
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) -- enforce employee existence
);
GO -- complete Device definition

-- Source data for attendance events, including geolocation.
CREATE TABLE AttendanceSource ( -- links attendance to capture source
    attendance_id INT, -- FK to Attendance
    device_id INT, -- FK to Device
    source_type VARCHAR(60), -- channel/source of attendance (GPS, RFID)
    latitude DECIMAL(10,9), -- captured latitude
    longitude DECIMAL(12,8), -- captured longitude
    recorded_at DATETIME, -- capture timestamp
    PRIMARY KEY (attendance_id, device_id), -- composite PK to prevent duplicates
    FOREIGN KEY (attendance_id) REFERENCES Attendance(attendance_id), -- enforce attendance existence
    FOREIGN KEY (device_id) REFERENCES Device(device_id) -- enforce device existence
);
GO -- complete AttendanceSource definition

-- Shift rotation templates.
CREATE TABLE ShiftCycle ( -- rotation template header
    cycle_id INT IDENTITY(1,1) PRIMARY KEY, -- unique cycle id
    cycle_name VARCHAR(50), -- human-readable cycle name
    description VARCHAR(500) -- explanation of rotation
);
GO -- complete ShiftCycle definition

-- Ordering of shifts within a cycle.
CREATE TABLE ShiftCycleAssignment ( -- map shifts into cycles
    cycle_id INT, -- FK to ShiftCycle
    shift_id INT, -- FK to ShiftSchedule
    order_number INT, -- order in the cycle
    PRIMARY KEY (cycle_id, shift_id), -- composite PK prevents duplicates
    FOREIGN KEY (cycle_id) REFERENCES ShiftCycle(cycle_id), -- enforce cycle existence
    FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id) -- enforce shift existence
);
GO -- complete ShiftCycleAssignment definition
