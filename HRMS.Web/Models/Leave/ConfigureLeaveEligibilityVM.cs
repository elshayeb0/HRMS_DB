using System.ComponentModel.DataAnnotations;

namespace HRMS.Web.Models.Leave
{
    public class ConfigureLeaveEligibilityVM
    {
        [Required]
        public string LeaveType { get; set; } = "";

        [Range(0, 600)]
        public int MinTenure { get; set; }

        [Required, StringLength(50)]
        public string EmployeeType { get; set; } = "";
    }
}