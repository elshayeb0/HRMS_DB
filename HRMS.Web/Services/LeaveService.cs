using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HRMS.Web.Data;
using Microsoft.EntityFrameworkCore;

namespace HRMS.Web.Services.Leave
{
    public interface ILeaveService
    {
        Task<int> SubmitLeaveRequestAsync(int employeeId, int leaveTypeId, DateTime startDate, DateTime endDate, string reason);
        Task AttachDocumentsAsync(int leaveRequestId, IEnumerable<string> filePaths);
    }
}

namespace HRMS.Web.Services.Leave
{
    public class LeaveService : ILeaveService
    {
        private readonly AppDbContext _db;

        public LeaveService(AppDbContext db)
        {
            _db = db;
        }

        public async Task<int> SubmitLeaveRequestAsync(int employeeId, int leaveTypeId, DateTime startDate, DateTime endDate, string reason)
        {
            // Stored Procedure: SubmitLeaveRequest
            await _db.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC SubmitLeaveRequest
                    @EmployeeID={employeeId},
                    @LeaveTypeID={leaveTypeId},
                    @StartDate={startDate.Date},
                    @EndDate={endDate.Date},
                    @Reason={reason}
            ");

            // Get the inserted request_id (simple approach based on your current SP signature)
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
                // Stored Procedure: AttachLeaveDocuments
                await _db.Database.ExecuteSqlInterpolatedAsync($@"
                    EXEC AttachLeaveDocuments
                        @LeaveRequestID={leaveRequestId},
                        @FilePath={path}
                ");
            }
        }
    }
}