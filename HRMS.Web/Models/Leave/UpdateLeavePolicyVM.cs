using System.ComponentModel.DataAnnotations;

namespace HRMS.Web.Models.Leave
{
    public class UpdateLeavePolicyVM
    {
        [Required]
        public int PolicyId { get; set; }

        [Required, StringLength(200)]
        public string EligibilityRules { get; set; } = "";

        [Range(0, 365)]
        public int NoticePeriod { get; set; }
    }
}