using System;
using System.ComponentModel.DataAnnotations;

namespace HRMS.Web.Models.Mission
{
    public class Mission
    {
        // Properties match your database columns
        public int MissionId { get; set; }

        [Required(ErrorMessage = "Destination is required")]
        [StringLength(100)]
        public string Destination { get; set; }

        [Required(ErrorMessage = "Start date is required")]
        [DataType(DataType.Date)]
        public DateTime StartDate { get; set; }

        [Required(ErrorMessage = "End date is required")]
        [DataType(DataType.Date)]
        public DateTime EndDate { get; set; }

        [StringLength(50)]
        public string Status { get; set; } // Pending, Approved, Completed, Rejected

        [Required]
        public int EmployeeId { get; set; }

        [Required]
        public int ManagerId { get; set; }

        // Additional properties for display (not in database)
        public string EmployeeName { get; set; }
        public string ManagerName { get; set; }
    }
}