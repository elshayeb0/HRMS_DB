using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;

namespace HRMS.Web.Models.Employees
{
    // SP ViewOrgHierarchy returns aliased columns with spaces.
    // We map them explicitly.
    [Keyless]
    public class OrgHierarchyRow
    {
        [Column("Employee ID")]
        public int EmployeeID { get; set; }

        [Column("Employee Name")]
        public string? EmployeeName { get; set; }

        [Column("Manager Name")]
        public string? ManagerName { get; set; }

        [Column("Department")]
        public string? Department { get; set; }

        [Column("Position")]
        public string? Position { get; set; }

        [Column("Hierarchy Level")]
        public int? HierarchyLevel { get; set; }
    }
}