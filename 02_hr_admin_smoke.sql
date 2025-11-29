USE HRMS_DB;
GO

---------------------------------------------------------
-- 1) CreateContract
---------------------------------------------------------
EXEC CreateContract
    @EmployeeID = 2,
    @Type       = 'Full-Time',
    @StartDate  = '2024-01-01',
    @EndDate    = '2025-01-01';

---------------------------------------------------------
-- 2) RenewContract
---------------------------------------------------------
EXEC RenewContract
    @ContractID  = 1,
    @NewEndDate  = '2026-01-01';

---------------------------------------------------------
-- 3) ApproveLeaveRequest
---------------------------------------------------------
EXEC ApproveLeaveRequest
    @LeaveRequestID = 1,
    @ApproverID     = 2,
    @Status         = 'Approved';

---------------------------------------------------------
-- 4) AssignMission
---------------------------------------------------------
EXEC AssignMission
    @EmployeeID  = 2,
    @ManagerID   = 1,
    @Destination = 'Cairo',
    @StartDate   = '2024-12-01',
    @EndDate     = '2024-12-05';

---------------------------------------------------------
-- 5) ReviewReimbursement
---------------------------------------------------------
EXEC ReviewReimbursement
    @ClaimID    = 1,
    @ApproverID = 2,
    @Decision   = 'Approved';

---------------------------------------------------------
-- 6) GetActiveContracts
---------------------------------------------------------
EXEC GetActiveContracts;

---------------------------------------------------------
-- 7) GetTeamByManager
---------------------------------------------------------
EXEC GetTeamByManager
    @ManagerID = 1;

---------------------------------------------------------
-- 8) UpdateLeavePolicy
---------------------------------------------------------
EXEC UpdateLeavePolicy
    @PolicyID         = 1,
    @EligibilityRules = 'All full-time employees',
    @NoticePeriod     = 7;

---------------------------------------------------------
-- 9) GetExpiringContracts
---------------------------------------------------------
EXEC GetExpiringContracts
    @DaysBefore = 30;

---------------------------------------------------------
-- 10) AssignDepartmentHead
---------------------------------------------------------
EXEC AssignDepartmentHead
    @DepartmentID = 2,
    @ManagerID    = 2;

---------------------------------------------------------
-- 11) CreateEmployeeProfile
---------------------------------------------------------
EXEC CreateEmployeeProfile
    @FirstName      = 'Test',
    @LastName       = 'Employee',
    @DepartmentID   = 2,
    @RoleID         = 3,
    @HireDate       = '2024-12-01',
    @Email          = 'test.employee@company.com',
    @Phone          = '+1-555-0999',
    @NationalID     = 'TEST999',
    @DateOfBirth    = '1995-05-05',
    @CountryOfBirth = 'Egypt';

---------------------------------------------------------
-- 12) UpdateEmployeeProfile
---------------------------------------------------------
EXEC UpdateEmployeeProfile
    @EmployeeID = 2,
    @FieldName  = 'phone',
    @NewValue   = '+1-555-0200';

---------------------------------------------------------
-- 13) SetProfileCompleteness
---------------------------------------------------------
EXEC SetProfileCompleteness
    @EmployeeID             = 2,
    @CompletenessPercentage = 90;

---------------------------------------------------------
-- 14) GenerateProfileReport
---------------------------------------------------------
EXEC GenerateProfileReport
    @FilterField = 'department_id',
    @FilterValue = '2';

---------------------------------------------------------
-- 15) CreateShiftType
---------------------------------------------------------
EXEC CreateShiftType
    @Name           = 'Morning Shift',
    @Type           = 'Fixed',
    @Start_Time     = '09:00',
    @End_Time       = '17:00',
    @Break_Duration = 60,
    @Shift_Date     = '2024-12-01',
    @Status         = 'Active';

---------------------------------------------------------
-- 17) AssignRotationalShift
---------------------------------------------------------
EXEC AssignRotationalShift
    @EmployeeID = 2,
    @ShiftCycle = 1,
    @StartDate  = '2024-12-01',
    @EndDate    = '2024-12-07',
    @Status     = 'Active';

---------------------------------------------------------
-- 18) NotifyShiftExpiry
---------------------------------------------------------
EXEC NotifyShiftExpiry
    @EmployeeID        = 2,
    @ShiftAssignmentID = 1,
    @ExpiryDate        = '2024-12-07';

---------------------------------------------------------
-- 19) DefineShortTimeRules
---------------------------------------------------------
EXEC DefineShortTimeRules
    @RuleName          = 'Standard Short Time',
    @LateMinutes       = 15,
    @EarlyLeaveMinutes = 30,
    @PenaltyType       = 'SalaryDeduction';

---------------------------------------------------------
-- 20) SetGracePeriod
---------------------------------------------------------
EXEC SetGracePeriod
    @Minutes = 10;

---------------------------------------------------------
-- 21) DefinePenaltyThreshold
---------------------------------------------------------
EXEC DefinePenaltyThreshold
    @LateMinutes   = 30,
    @DeductionType = 'FixedAmount';

---------------------------------------------------------
-- 22) DefinePermissionLimits
---------------------------------------------------------
EXEC DefinePermissionLimits
    @MinHours = 1,
    @MaxHours = 8;

---------------------------------------------------------
-- 23) EscalatePendingRequests
---------------------------------------------------------
EXEC EscalatePendingRequests
    @Deadline = '2024-12-31 23:59:59';

---------------------------------------------------------
-- 24) LinkVacationToShift
---------------------------------------------------------
EXEC LinkVacationToShift
    @VacationLeaveID = 1,
    @EmployeeID      = 2;

---------------------------------------------------------
-- 25) ConfigureLeavePolicies
---------------------------------------------------------
EXEC ConfigureLeavePolicies;

---------------------------------------------------------
-- 26) AuthenticateLeaveAdmin
---------------------------------------------------------
EXEC AuthenticateLeaveAdmin
    @AdminID  = 2,
    @Password = 'Can validate all HR documents';

---------------------------------------------------------
-- 27) ApplyLeaveConfiguration
---------------------------------------------------------
EXEC ApplyLeaveConfiguration;

---------------------------------------------------------
-- 28) UpdateLeaveEntitlements
---------------------------------------------------------
EXEC UpdateLeaveEntitlements
    @EmployeeID = 2;

---------------------------------------------------------
-- 29) ConfigureLeaveEligibility
---------------------------------------------------------
EXEC ConfigureLeaveEligibility
    @LeaveType    = 'Annual',
    @MinTenure    = 12,
    @EmployeeType = 'Full-Time';

---------------------------------------------------------
-- 30) ManageLeaveTypes
---------------------------------------------------------
EXEC ManageLeaveTypes
    @LeaveType    = 'Annual',
    @Description  = 'Annual paid leave';

---------------------------------------------------------
-- 31) AssignLeaveEntitlement
---------------------------------------------------------
EXEC AssignLeaveEntitlement
    @EmployeeID  = 2,
    @LeaveType   = 'Annual',
    @Entitlement = 21.00;

---------------------------------------------------------
-- 32) ConfigureLeaveRules
---------------------------------------------------------
EXEC ConfigureLeaveRules
    @LeaveType    = 'Annual',
    @MaxDuration  = 21,
    @NoticePeriod = 7,
    @WorkflowType = 'Standard';

---------------------------------------------------------
-- 33) ConfigureSpecialLeave
---------------------------------------------------------
EXEC ConfigureSpecialLeave
    @LeaveType = 'Sick',
    @Rules     = 'Requires medical certificate';

---------------------------------------------------------
-- 34) SetLeaveYearRules
---------------------------------------------------------
EXEC SetLeaveYearRules
    @StartDate = '2024-01-01',
    @EndDate   = '2024-12-31';

---------------------------------------------------------
-- 35) AdjustLeaveBalance
---------------------------------------------------------
EXEC AdjustLeaveBalance
    @EmployeeID = 2,
    @LeaveType  = 'Annual',
    @Adjustment = 1.50;

---------------------------------------------------------
-- 36) ManageLeaveRoles
---------------------------------------------------------
EXEC ManageLeaveRoles
    @RoleID     = 2,
    @Permission = 'Leave Management';

---------------------------------------------------------
-- 37) FinalizeLeaveRequest
---------------------------------------------------------
EXEC FinalizeLeaveRequest
    @LeaveRequestID = 1;

---------------------------------------------------------
-- 38) OverrideLeaveDecision
---------------------------------------------------------
EXEC OverrideLeaveDecision
    @LeaveRequestID = 1,
    @Reason         = 'Manual override for special case';

---------------------------------------------------------
-- 39) BulkProcessLeaveRequests
---------------------------------------------------------
EXEC BulkProcessLeaveRequests
    @LeaveRequestIDs = '1,2,3';

---------------------------------------------------------
-- 40) VerifyMedicalLeave
---------------------------------------------------------
EXEC VerifyMedicalLeave
    @LeaveRequestID = 1,
    @DocumentID     = 1;

---------------------------------------------------------
-- 41) SyncLeaveBalances
---------------------------------------------------------
EXEC SyncLeaveBalances
    @LeaveRequestID = 1;

---------------------------------------------------------
-- 42) ProcessLeaveCarryForward
---------------------------------------------------------
EXEC ProcessLeaveCarryForward
    @Year = 2024;

---------------------------------------------------------
-- 43) SyncLeaveToAttendance
---------------------------------------------------------
EXEC SyncLeaveToAttendance
    @LeaveRequestID = 1;

---------------------------------------------------------
-- 44) UpdateInsuranceBrackets
---------------------------------------------------------
EXEC UpdateInsuranceBrackets
    @BracketID              = 1,
    @NewMinSalary           = 10000.00,
    @NewMaxSalary           = 30000.00,
    @NewEmployeeContribution= 5.00,
    @NewEmployerContribution= 10.00,
    @UpdatedBy              = 2;

---------------------------------------------------------
-- 45) ApprovePolicyUpdate
---------------------------------------------------------
EXEC ApprovePolicyUpdate
    @PolicyID  = 1,
    @ApprovedBy = 2;