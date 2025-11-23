-- =============================================
-- File: 02_hr_admin.sql
-- Project: HRMS_DB - Milestone 2

-- Purpose: Stored procedures for "As an HR Admin" user stories

-- Note: Names must match the Milestone 2 specification exactly
-- =============================================

USE HRMS_DB;
GO

-- 1:
CREATE PROCEDURE CreateContract
    @EmployeeID INT,
    @Type VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE, 
AS
BEGIN

    SET NOCOUNT ON;

    -- Insert new contract
    INSERT INTO Contract (type, start_date, end_date, current_state)
    VALUES (@Type, @StartDate, @EndDate, 'Active');

    -- Link contract to employee
    UPDATE Employee
    SET contract_id = SCOPE_IDENTITY()
    WHERE employee_id = @EmployeeID;

    SELECT 'Contract created successfully for Employee ID: ' + CAST(@EmployeeID AS VARCHAR) + 
       '. Contract ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR) AS Message;

END;

