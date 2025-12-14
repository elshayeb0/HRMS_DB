using System;

namespace HRMS.Web.Data.Entities.Query
{
    public class PendingLeaveRequestRow
    {
        public int LeaveRequestID { get; set; }
        public int EmployeeID { get; set; }
        public string EmployeeName { get; set; } = "";
        public int? LeaveID { get; set; }
        public string? LeaveType { get; set; }
        public string? justification { get; set; }
        public int? duration { get; set; }
        public DateTime? approval_timing { get; set; }
        public string? status { get; set; }
    }
}