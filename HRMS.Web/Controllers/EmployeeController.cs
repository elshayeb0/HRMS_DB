using HRMS.Web.Data;
using HRMS.Web.Models.Employees;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace HRMS.Web.Controllers
{
    [Authorize]
    public class EmployeeController : Controller
    {
        private readonly AppDbContext _context;

        public EmployeeController(AppDbContext context)
        {
            _context = context;
        }

        // ============================
        // 1) System Admin - Add Employee
        // ============================
        [Authorize(Roles = "SystemAdmin")]
        [HttpGet]
        public IActionResult Create()
        {
            return View(new AddEmployeeViewModel());
        }

        [Authorize(Roles = "SystemAdmin")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(AddEmployeeViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            // ContractID/TaxFormID/SalaryTypeID can be null (SP accepts INT, SQL allows NULL insert if column allows).
            // ManagerID can be null (top-level employee).
            var p = new List<SqlParameter>
            {
                new("@FullName", SqlDbType.VarChar, 200) { Value = model.FullName },
                new("@NationalID", SqlDbType.VarChar, 50) { Value = model.NationalID },
                new("@DateOfBirth", SqlDbType.Date) { Value = model.DateOfBirth.Date },
                new("@CountryOfBirth", SqlDbType.VarChar, 100) { Value = model.CountryOfBirth },
                new("@Phone", SqlDbType.VarChar, 50) { Value = model.Phone },
                new("@Email", SqlDbType.VarChar, 100) { Value = model.Email },
                new("@Address", SqlDbType.VarChar, 255) { Value = model.Address },
                new("@EmergencyContactName", SqlDbType.VarChar, 100) { Value = model.EmergencyContactName },
                new("@EmergencyContactPhone", SqlDbType.VarChar, 50) { Value = model.EmergencyContactPhone },
                new("@Relationship", SqlDbType.VarChar, 50) { Value = model.Relationship },
                new("@Biography", SqlDbType.VarChar) { Value = (object?)model.Biography ?? DBNull.Value },
                new("@EmploymentProgress", SqlDbType.VarChar, 100) { Value = (object?)model.EmploymentProgress ?? "Onboarding" },
                new("@AccountStatus", SqlDbType.VarChar, 50) { Value = (object?)model.AccountStatus ?? "Active" },
                new("@EmploymentStatus", SqlDbType.VarChar, 50) { Value = (object?)model.EmploymentStatus ?? "Active" },
                new("@HireDate", SqlDbType.Date) { Value = model.HireDate.Date },
                new("@IsActive", SqlDbType.Bit) { Value = model.IsActive },
                new("@ProfileCompletion", SqlDbType.Int) { Value = model.ProfileCompletion },
                new("@DepartmentID", SqlDbType.Int) { Value = model.DepartmentID },
                new("@PositionID", SqlDbType.Int) { Value = model.PositionID },
                new("@ManagerID", SqlDbType.Int) { Value = (object?)model.ManagerID ?? DBNull.Value },
                new("@ContractID", SqlDbType.Int) { Value = (object?)model.ContractID ?? DBNull.Value },
                new("@TaxFormID", SqlDbType.Int) { Value = (object?)model.TaxFormID ?? DBNull.Value },
                new("@SalaryTypeID", SqlDbType.Int) { Value = (object?)model.SalaryTypeID ?? DBNull.Value },
                new("@PayGrade", SqlDbType.VarChar, 50) { Value = model.PayGrade }
            };

            // AddEmployee returns a SELECT SCOPE_IDENTITY() as EmployeeID
            // ExecuteSqlRaw does NOT read result sets, so we use DbConnection to read the scalar.
            int newEmployeeId = await ExecuteAddEmployeeAndReturnIdAsync(p);

            TempData["Success"] = $"Employee created successfully. New EmployeeID = {newEmployeeId}";
            return RedirectToAction(nameof(Create));
        }

        private async Task<int> ExecuteAddEmployeeAndReturnIdAsync(IEnumerable<SqlParameter> parameters)
        {
            await using var conn = _context.Database.GetDbConnection();
            if (conn.State != ConnectionState.Open)
                await conn.OpenAsync();

            await using var cmd = conn.CreateCommand();
            cmd.CommandText = "AddEmployee";
            cmd.CommandType = CommandType.StoredProcedure;

            foreach (var sp in parameters)
                cmd.Parameters.Add(sp);

            var result = await cmd.ExecuteScalarAsync();
            if (result == null || result == DBNull.Value)
                throw new InvalidOperationException("AddEmployee did not return a new EmployeeID.");

            // SCOPE_IDENTITY returns decimal in SQL Server
            return Convert.ToInt32(result);
        }

        // ============================
        // 2) HR Admin - Update Employee Info
        // ============================
        [Authorize(Roles = "HRAdmin")]
        [HttpGet]
        public IActionResult EditInfo()
        {
            return View(new UpdateEmployeeInfoViewModel());
        }

        [Authorize(Roles = "HRAdmin")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EditInfo(UpdateEmployeeInfoViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var p1 = new SqlParameter("@EmployeeID", SqlDbType.Int) { Value = model.EmployeeID };
            var p2 = new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = model.Email };
            var p3 = new SqlParameter("@Phone", SqlDbType.VarChar, 20) { Value = model.Phone };
            var p4 = new SqlParameter("@Address", SqlDbType.VarChar, 150) { Value = model.Address };

            await _context.Database.ExecuteSqlRawAsync(
                "EXEC UpdateEmployeeInfo @EmployeeID, @Email, @Phone, @Address",
                p1, p2, p3, p4
            );

            model.Message = "Employee information updated successfully.";
            return View(model);
        }

        // ============================
        // 3) System Admin - View Org Hierarchy
        // ============================
        [Authorize(Roles = "SystemAdmin")]
        [HttpGet]
        public async Task<IActionResult> Hierarchy()
        {
            // ViewOrgHierarchy has NO parameters and returns a result set
            var rows = await _context.Set<OrgHierarchyRow>()
                .FromSqlRaw("EXEC ViewOrgHierarchy")
                .AsNoTracking()
                .ToListAsync();

            return View(rows);
        }
    }
}