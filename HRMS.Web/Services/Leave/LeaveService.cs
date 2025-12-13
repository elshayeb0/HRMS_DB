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
    }
}