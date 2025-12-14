using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HRMS.Web.Data;
using HRMS.Web.Data.Entities.Query;
using HRMS.Web.Models.Leave;
using Microsoft.EntityFrameworkCore;

namespace HRMS.Web.Services.Leave
{
    public interface ILeaveService
    {
        Task<int> SubmitLeaveRequestAsync(int employeeId, int leaveTypeId, DateTime startDate, DateTime endDate, string reason);
        Task AttachDocumentsAsync(int leaveRequestId, IEnumerable<string> filePaths);

        Task<List<LeaveHistoryRowVM>> GetLeaveHistoryAsync(int employeeId);
        Task<List<LeaveBalanceRowVM>> GetLeaveBalanceAsync(int employeeId);
        Task<List<PendingLeaveRequestRow>> GetPendingLeaveRequestsAsync(int managerId);
        Task<bool> ApproveLeaveRequestAsync(int managerId, int leaveRequestId);
        Task<bool> RejectLeaveRequestAsync(int managerId, int leaveRequestId, string reason);
        Task FlagIrregularLeaveAsync(int employeeId, int managerId, string patternDescription);

        Task UpdateLeavePolicyAsync(int policyId, string eligibilityRules, int noticePeriod);
        Task ConfigureLeaveEligibilityAsync(string leaveType, int minTenure, string employeeType);
    }

    public class LeaveService : ILeaveService
    {
        private readonly AppDbContext _db;

        public LeaveService(AppDbContext db)
        {
            _db = db;
        }

        public async Task<int> SubmitLeaveRequestAsync(int employeeId, int leaveTypeId, DateTime startDate, DateTime endDate, string reason)
        {
            await _db.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC SubmitLeaveRequest
                    @EmployeeID={employeeId},
                    @LeaveTypeID={leaveTypeId},
                    @StartDate={startDate.Date},
                    @EndDate={endDate.Date},
                    @Reason={reason}
            ");

            var requestId = await _db.LeaveRequests
                .Where(lr => lr.employee_id == employeeId)
                .OrderByDescending(lr => lr.request_id)
                .Select(lr => lr.request_id)
                .FirstAsync();

            return requestId;
        }

        public async Task AttachDocumentsAsync(int leaveRequestId, IEnumerable<string> filePaths)
        {
            foreach (var path in filePaths)
            {
                await _db.Database.ExecuteSqlInterpolatedAsync($@"
                    EXEC AttachLeaveDocuments
                        @LeaveRequestID={leaveRequestId},
                        @FilePath={path}
                ");
            }
        }

        public async Task<List<LeaveHistoryRowVM>> GetLeaveHistoryAsync(int employeeId)
        {
            var rows = await _db.Set<LeaveHistoryRow>()
                .FromSqlInterpolated($@"EXEC ViewLeaveHistory @EmployeeID={employeeId}")
                .AsNoTracking()
                .ToListAsync();

            return rows.Select(r => new LeaveHistoryRowVM
            {
                RequestId = r.Request_ID,
                LeaveType = r.Leave_Type ?? "-",          // string? -> string
                Reason = r.Reason ?? "-",                 // string? -> string
                DurationDays = r.Duration__Days_ ?? 0,     // int? -> int
                Status = r.Status ?? "-",                 // string? -> string
                ApprovalDate = r.Approval_Date            // DateTime? stays DateTime?
            }).ToList();
        }

        public async Task<List<LeaveBalanceRowVM>> GetLeaveBalanceAsync(int employeeId)
        {
            var rows = await _db.Set<LeaveBalanceRow>()
                .FromSqlInterpolated($@"EXEC ViewLeaveBalance @EmployeeID={employeeId}")
                .AsNoTracking()
                .ToListAsync();

            return rows.Select(r => new LeaveBalanceRowVM
            {
                LeaveType = r.Leave_Type ?? "-",
                RemainingDays = r.Remaining_Days ?? 0m     // decimal? -> decimal
            }).ToList();
        }

        public async Task<List<PendingLeaveRequestRow>> GetPendingLeaveRequestsAsync(int managerId)
        {
            return await _db.Set<PendingLeaveRequestRow>()
                .FromSqlInterpolated($@"EXEC GetPendingLeaveRequests @ManagerID={managerId}")
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task<bool> ApproveLeaveRequestAsync(int managerId, int leaveRequestId)
        {
            // Guard: request must belong to manager’s team and be Pending
            var allowed = await _db.LeaveRequests
                .AnyAsync(lr =>
                    lr.request_id == leaveRequestId
                    && lr.status == "Pending"
                    && lr.employee != null
                    && lr.employee.manager_id == managerId);

            if (!allowed) return false;

            // Use your existing stored procedure name (typo included)
            await _db.Database.ExecuteSqlInterpolatedAsync($@"
        EXEC ApproveLeaveRequestt
            @LeaveRequestID={leaveRequestId},
            @ManagerID={managerId}
    ");

            return true;
        }

        public async Task<bool> RejectLeaveRequestAsync(int managerId, int leaveRequestId, string reason)
        {
            if (string.IsNullOrWhiteSpace(reason))
                reason = "Rejected by manager.";

            var allowed = await _db.LeaveRequests
                .AnyAsync(lr =>
                    lr.request_id == leaveRequestId
                    && lr.status == "Pending"
                    && lr.employee != null
                    && lr.employee.manager_id == managerId);

            if (!allowed) return false;

            await _db.Database.ExecuteSqlInterpolatedAsync($@"
        EXEC RejectLeaveRequest
            @LeaveRequestID={leaveRequestId},
            @ManagerID={managerId},
            @Reason={reason}
    ");

            return true;
        }

        public async Task FlagIrregularLeaveAsync(int employeeId, int managerId, string patternDescription)
        {
            await _db.Database.ExecuteSqlInterpolatedAsync($@"
        EXEC FlagIrregularLeave
            @EmployeeID={employeeId},
            @ManagerID={managerId},
            @PatternDescription={patternDescription}
    ");
        }

        public async Task UpdateLeavePolicyAsync(int policyId, string eligibilityRules, int noticePeriod)
        {
            await _db.Database.ExecuteSqlInterpolatedAsync($@"
        EXEC UpdateLeavePolicy
            @PolicyID={policyId},
            @EligibilityRules={eligibilityRules},
            @NoticePeriod={noticePeriod}
    ");
        }

        public async Task ConfigureLeaveEligibilityAsync(string leaveType, int minTenure, string employeeType)
        {
            await _db.Database.ExecuteSqlInterpolatedAsync($@"
        EXEC ConfigureLeaveEligibility
            @LeaveType={leaveType},
            @MinTenure={minTenure},
            @EmployeeType={employeeType}
    ");
        }
    }
}