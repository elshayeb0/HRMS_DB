using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace HRMS.Web.Data.Entities.Query;

public class LeaveHistoryRow
{
    [Column("Request ID")]
    public int Request_ID { get; set; }

    [Column("Leave Type")]
    public string? Leave_Type { get; set; }

    [Column("Reason")]
    public string? Reason { get; set; }

    [Column("Duration (Days)")]
    public int? Duration__Days_ { get; set; }

    [Column("Status")]
    public string? Status { get; set; }

    [Column("Approval Date")]
    public DateTime? Approval_Date { get; set; }
}