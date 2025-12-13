namespace HRMS.Web.Models.Leave;

public class LeaveHistoryRowVM
{
    public int RequestId { get; set; }
    public string LeaveType { get; set; } = "";
    public string Reason { get; set; } = "";
    public int DurationDays { get; set; }
    public string Status { get; set; } = "";
    public DateTime? ApprovalDate { get; set; }
}