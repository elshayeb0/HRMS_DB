using HRMS.Web.Data;
using HRMS.Web.Models.Auth;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using System.Security.Claims;
using System.Data;

namespace HRMS.Web.Controllers
{
    public class AccountController : Controller
    {
        private readonly AppDbContext _context;

        public AccountController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Login()
        {
            if (User?.Identity?.IsAuthenticated == true)
                return RedirectToAction("Index", "Home");

            return View(new LoginViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            // IMPORTANT:
            // Your Employee table has no password column.
            // For Milestone 3, we authenticate by Email + NationalID as a temporary "password".
            // This is a controlled compromise for the assignment.
            var loginResult = await ValidateUserAsync(model.Email, model.Password);
            if (!loginResult.IsValid)
            {
                model.ErrorMessage = "Invalid email or password.";
                return View(model);
            }

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, loginResult.EmployeeID.ToString()),
                new Claim(ClaimTypes.Name, loginResult.FullName ?? model.Email),
                new Claim(ClaimTypes.Email, loginResult.Email ?? model.Email)
            };

            foreach (var role in loginResult.Roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }

            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var principal = new ClaimsPrincipal(identity);

            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                principal,
                new AuthenticationProperties
                {
                    IsPersistent = true,
                    AllowRefresh = true,
                    IssuedUtc = DateTimeOffset.UtcNow
                }
            );

            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction(nameof(Login));
        }

        [HttpGet]
        public IActionResult AccessDenied()
        {
            return View();
        }

        private async Task<LoginResult> ValidateUserAsync(string email, string password)
        {
            // Using DbConnection from DbContext (still "MVC-only" and university friendly).
            await using var conn = _context.Database.GetDbConnection();
            if (conn.State != ConnectionState.Open)
                await conn.OpenAsync();

            // Authenticate against Employee: email + national_id (temporary "password")
            await using var cmd = conn.CreateCommand();
            cmd.CommandText = @"
SELECT TOP 1 employee_id, full_name, email
FROM Employee
WHERE email = @Email AND national_id = @NationalID AND is_active = 1;
";
            var pEmail = new SqlParameter("@Email", SqlDbType.VarChar, 100) { Value = email };
            var pNat = new SqlParameter("@NationalID", SqlDbType.VarChar, 50) { Value = password };
            cmd.Parameters.Add(pEmail);
            cmd.Parameters.Add(pNat);

            int? employeeId = null;
            string? fullName = null;
            string? dbEmail = null;

            await using (var reader = await cmd.ExecuteReaderAsync())
            {
                if (await reader.ReadAsync())
                {
                    employeeId = reader.GetInt32(reader.GetOrdinal("employee_id"));
                    fullName = reader["full_name"] as string;
                    dbEmail = reader["email"] as string;
                }
            }

            if (employeeId is null)
                return LoginResult.Invalid();

            // Build roles from “type tables” (SystemAdministrator / HRAdministrator / LineManager / PayrollSpecialist)
            var roles = await GetUserRolesAsync(conn, employeeId.Value);

            return LoginResult.Valid(employeeId.Value, fullName, dbEmail, roles);
        }

        private static async Task<List<string>> GetUserRolesAsync(System.Data.Common.DbConnection conn, int employeeId)
        {
            var roles = new List<string>();

            // These are role-claims names you will use in [Authorize(Roles="...")]
            // Keep them stable.
            var checks = new (string Table, string RoleClaim)[]
            {
                ("SystemAdministrator", "SystemAdmin"),
                ("HRAdministrator", "HRAdmin"),
                ("LineManager", "LineManager"),
                ("PayrollSpecialist", "PayrollSpecialist")
            };

            foreach (var (table, roleClaim) in checks)
            {
                await using var roleCmd = conn.CreateCommand();
                roleCmd.CommandText = $"SELECT 1 FROM {table} WHERE employee_id = @EmployeeID;";
                var p = new SqlParameter("@EmployeeID", SqlDbType.Int) { Value = employeeId };
                roleCmd.Parameters.Add(p);

                var exists = await roleCmd.ExecuteScalarAsync();
                if (exists != null && exists != DBNull.Value)
                    roles.Add(roleClaim);
            }

            // Optional: also include Role table mapping if you want.
            // (Not required for Milestone 3. Keeping it simple.)

            return roles;
        }

        private sealed record LoginResult(bool IsValid, int EmployeeID, string? FullName, string? Email, List<string> Roles)
        {
            public static LoginResult Invalid() => new(false, 0, null, null, new List<string>());
            public static LoginResult Valid(int id, string? fullName, string? email, List<string> roles) =>
                new(true, id, fullName, email, roles);
        }
    }
}