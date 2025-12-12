using System.ComponentModel.DataAnnotations;

namespace HRMS.Web.Models.Employees
{
    // Maps EXACTLY to UpdateEmployeeInfo stored procedure parameters.
    public class UpdateEmployeeInfoViewModel
    {
        [Required]
        public int EmployeeID { get; set; }

        [Required, EmailAddress, StringLength(100)]
        public string Email { get; set; } = string.Empty;

        [Required, StringLength(20)]
        public string Phone { get; set; } = string.Empty;

        [Required, StringLength(150)]
        public string Address { get; set; } = string.Empty;

        public string? Message { get; set; }
    }
}