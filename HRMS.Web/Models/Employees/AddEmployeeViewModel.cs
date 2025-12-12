using System.ComponentModel.DataAnnotations;

namespace HRMS.Web.Models.Employees
{
    // Maps EXACTLY to AddEmployee stored procedure parameters.
    public class AddEmployeeViewModel
    {
        [Required, StringLength(200)]
        public string FullName { get; set; } = string.Empty;

        [Required, StringLength(50)]
        public string NationalID { get; set; } = string.Empty;

        [Required, DataType(DataType.Date)]
        public DateTime DateOfBirth { get; set; }

        [Required, StringLength(100)]
        public string CountryOfBirth { get; set; } = string.Empty;

        [Required, StringLength(50)]
        public string Phone { get; set; } = string.Empty;

        [Required, EmailAddress, StringLength(100)]
        public string Email { get; set; } = string.Empty;

        [Required, StringLength(255)]
        public string Address { get; set; } = string.Empty;

        [Required, StringLength(100)]
        public string EmergencyContactName { get; set; } = string.Empty;

        [Required, StringLength(50)]
        public string EmergencyContactPhone { get; set; } = string.Empty;

        [Required, StringLength(50)]
        public string Relationship { get; set; } = string.Empty;

        public string? Biography { get; set; }

        [StringLength(100)]
        public string? EmploymentProgress { get; set; } = "Onboarding";

        [StringLength(50)]
        public string? AccountStatus { get; set; } = "Active";

        [StringLength(50)]
        public string? EmploymentStatus { get; set; } = "Active";

        [Required, DataType(DataType.Date)]
        public DateTime HireDate { get; set; } = DateTime.Today;

        public bool IsActive { get; set; } = true;

        public int ProfileCompletion { get; set; } = 0;

        [Required]
        public int DepartmentID { get; set; }

        [Required]
        public int PositionID { get; set; }

        public int? ManagerID { get; set; }

        public int? ContractID { get; set; }

        public int? TaxFormID { get; set; }

        public int? SalaryTypeID { get; set; }

        // SP expects VARCHAR(50) even though table is INT for pay_grade in your create script.
        // You must follow the SP signature.
        [Required, StringLength(50)]
        public string PayGrade { get; set; } = "1";
    }
}