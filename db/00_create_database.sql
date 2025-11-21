-- =============================================
-- File: 00_create_database.sql
-- Project: HRMS_DB - Milestone 2
-- Purpose: Create and select the main project database
-- Note: Run this ONCE before any other script
-- =============================================

IF DB_ID('HRMS_DB') IS NULL
BEGIN
    CREATE DATABASE HRMS_DB;
END;
GO

USE HRMS_DB;
GO