using System.ComponentModel.DataAnnotations;

namespace HRMS.Web.Models.Leave
{
    public class OverrideLeaveDecisionVM
    {
        [Range(1, int.MaxValue)]
        public int LeaveRequestId { get; set; }

        [Required, StringLength(200)]
        public string Reason { get; set; } = "";
    }
}