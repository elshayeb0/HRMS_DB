using HRMS.Web.Models.Employees;
using Microsoft.EntityFrameworkCore;

namespace HRMS.Web.Data
{
    public partial class AppDbContext
    {
        // Register keyless type for FromSqlRaw
        partial void OnModelCreatingPartial(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<OrgHierarchyRow>(entity =>
            {
                entity.HasNoKey();
                // Not mapped to a real table/view
                entity.ToView(null);
            });
        }
    }
}