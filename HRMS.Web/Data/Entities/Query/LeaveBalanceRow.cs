using System.ComponentModel.DataAnnotations.Schema;

namespace HRMS.Web.Data.Entities.Query;

public class LeaveBalanceRow
{
    [Column("Leave Type")]
    public string? Leave_Type { get; set; }

    [Column("Remaining Days")]
    public decimal? Remaining_Days { get; set; }
}