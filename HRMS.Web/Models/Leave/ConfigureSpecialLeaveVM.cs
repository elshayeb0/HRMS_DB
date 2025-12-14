using System.ComponentModel.DataAnnotations;

namespace HRMS.Web.Models.Leave
{
    public class ConfigureSpecialLeaveVM
    {
        [Required]
        public string LeaveType { get; set; } = "";

        [Required]
        [StringLength(200)]
        public string Rules { get; set; } = "";
    }
}