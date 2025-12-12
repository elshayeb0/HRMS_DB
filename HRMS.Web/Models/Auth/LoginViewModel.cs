using System.ComponentModel.DataAnnotations;

namespace HRMS.Web.Models.Auth
{
    public class LoginViewModel
    {
        [Required, EmailAddress]
        public string Email { get; set; } = string.Empty;

        // NOTE: Your DB schema has NO password column in Employee.
        // For Milestone 3, we will authenticate using NationalID as the "password" (temporary).
        // This is clearly documented and can be replaced later when credentials table exists.
        [Required, DataType(DataType.Password)]
        public string Password { get; set; } = string.Empty;

        public string? ErrorMessage { get; set; }
    }
}