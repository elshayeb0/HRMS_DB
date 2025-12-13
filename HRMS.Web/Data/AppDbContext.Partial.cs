using HRMS.Web.Data.Entities.Query;
using HRMS.Web.Models.Employees;
using Microsoft.EntityFrameworkCore;

namespace HRMS.Web.Data
{
    public partial class AppDbContext
    {
        partial void OnModelCreatingPartial(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<OrgHierarchyRow>(entity =>
            {
                entity.HasNoKey();
                entity.ToView(null);
            });

            // ADD THESE:
            modelBuilder.Entity<LeaveHistoryRow>(entity =>
            {
                entity.HasNoKey();
                entity.ToView(null);
            });

            modelBuilder.Entity<LeaveBalanceRow>(entity =>
            {
                entity.HasNoKey();
                entity.ToView(null);
            });
        }
    }
}