using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using HRMS.Web.Models.Mission;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace HRMS.Web.Controllers
{
    public class HRController : Controller
    {
        private readonly string _connectionString;
        private readonly IConfiguration _configuration;

        public HRController(IConfiguration configuration)
        {
            _configuration = configuration;
            _connectionString = _configuration.GetConnectionString("DefaultConnection");
        }

        // GET: HR/AssignMission
        public IActionResult AssignMission()
        {
            ViewBag.Employees = GetAllEmployees();
            return View();
        }

        // POST: HR/AssignMission
        [HttpPost]
        public IActionResult AssignMission(int employeeId, string destination, DateTime startDate, DateTime endDate)
        {
            try
            {
                Console.WriteLine($"===== ASSIGN MISSION CALLED =====");
                Console.WriteLine($"Employee ID: {employeeId}");
                Console.WriteLine($"Destination: {destination}");
                Console.WriteLine($"Start Date: {startDate}");
                Console.WriteLine($"End Date: {endDate}");

                // ISSUE #2: Check if end date is before start date
                if (endDate < startDate)
                {
                    TempData["ErrorMessage"] = "End date cannot be before the start date. Please select valid dates.";
                    ViewBag.Employees = GetAllEmployees();
                    return View();
                }

                // Get the employee's manager
                int managerId = GetEmployeeManager(employeeId);
                Console.WriteLine($"Manager ID: {managerId}");

                if (managerId == 0)
                {
                    TempData["ErrorMessage"] = "Employee does not have an assigned manager.";
                    ViewBag.Employees = GetAllEmployees();
                    return View();
                }

                // ISSUE #3: Check employment hierarchy
                int currentUserId = GetCurrentUserId(); // Get logged-in user ID
                string hierarchyError = CheckEmploymentHierarchy(currentUserId, employeeId);

                if (!string.IsNullOrEmpty(hierarchyError))
                {
                    TempData["ErrorMessage"] = hierarchyError;
                    ViewBag.Employees = GetAllEmployees();
                    return View();
                }

                // Call the stored procedure to assign mission
                bool success = AssignMissionToEmployee(employeeId, managerId, destination, startDate, endDate);

                if (success)
                {
                    TempData["SuccessMessage"] = $"Mission assigned successfully to employee!";
                    return RedirectToAction("AssignMission");
                }
                else
                {
                    TempData["ErrorMessage"] = "Failed to assign mission.";
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"EXCEPTION: {ex.Message}");
                TempData["ErrorMessage"] = $"Error assigning mission: {ex.Message}";
            }

            ViewBag.Employees = GetAllEmployees();
            return View();
        }

        // ============================================
        // PRIVATE HELPER METHODS
        // ============================================

        private List<Employee> GetAllEmployees()
        {
            List<Employee> employees = new List<Employee>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"
                    SELECT employee_id, full_name, manager_id 
                    FROM Employee 
                    WHERE is_active = 1
                    ORDER BY full_name";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    employees.Add(new Employee
                    {
                        EmployeeId = (int)reader["employee_id"],
                        FullName = reader["full_name"].ToString(),
                        ManagerId = reader["manager_id"] != DBNull.Value ? (int)reader["manager_id"] : 0
                    });
                }
            }

            return employees;
        }

        private int GetEmployeeManager(int employeeId)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "SELECT manager_id FROM Employee WHERE employee_id = @EmployeeId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);

                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != DBNull.Value && result != null ? (int)result : 0;
            }
        }

        private bool AssignMissionToEmployee(int employeeId, int managerId, string destination, DateTime startDate, DateTime endDate)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("AssignMission", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@EmployeeID", employeeId);
                cmd.Parameters.AddWithValue("@ManagerID", managerId);
                cmd.Parameters.AddWithValue("@Destination", destination);
                cmd.Parameters.AddWithValue("@StartDate", startDate);
                cmd.Parameters.AddWithValue("@EndDate", endDate);

                conn.Open();
                cmd.ExecuteNonQuery();
                Console.WriteLine("Mission assigned via stored procedure");
                return true;
            }
        }

        /// <summary>
        /// Gets the currently logged-in employee's ID
        /// Uses the same method as MissionController for consistency
        /// </summary>
        private int GetCurrentUserId()
        {
            // Try to get from User claims first (from authentication)
            if (User?.Identity?.IsAuthenticated == true)
            {
                var userIdClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);
                if (userIdClaim != null && int.TryParse(userIdClaim.Value, out int userId))
                {
                    System.Diagnostics.Debug.WriteLine($"✅ Got EmployeeId from claims: {userId}");
                    return userId;
                }
            }

            // If not in claims, try session as fallback
            var sessionEmployeeId = HttpContext.Session.GetInt32("EmployeeId");
            if (sessionEmployeeId.HasValue)
            {
                System.Diagnostics.Debug.WriteLine($"✅ Got EmployeeId from session: {sessionEmployeeId}");
                return sessionEmployeeId.Value;
            }

            // If nothing found, return 0 (which will show error message)
            System.Diagnostics.Debug.WriteLine("❌ WARNING: No EmployeeId found in claims or session!");
            return 0;
        }

        /// <summary>
        /// Checks if the current user has permission to assign missions to the target employee
        /// Uses EmployeeHierarchy table to determine levels
        /// Rules:
        /// - Cannot assign to themselves
        /// - Can only assign to people with HIGHER level number (lower in hierarchy)
        /// - Cannot assign to managers (people at same level or lower level number)
        /// </summary>
        private string CheckEmploymentHierarchy(int currentUserId, int targetEmployeeId)
        {
            if (currentUserId == 0)
            {
                return "Unable to identify current user. Please log in again.";
            }

            if (currentUserId == targetEmployeeId)
            {
                return "You cannot assign a mission to yourself.";
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    conn.Open();

                    // Get the hierarchy level of the current user
                    string currentUserLevelQuery = @"
						SELECT COALESCE(MAX(hierarchy_level), 0) as max_level
						FROM EmployeeHierarchy
						WHERE employee_id = @UserId";

                    SqlCommand currentUserCmd = new SqlCommand(currentUserLevelQuery, conn);
                    currentUserCmd.Parameters.AddWithValue("@UserId", currentUserId);

                    object currentUserLevelResult = currentUserCmd.ExecuteScalar();
                    int currentUserLevel = (currentUserLevelResult != null && currentUserLevelResult != DBNull.Value)
                        ? (int)currentUserLevelResult
                        : 0;

                    Console.WriteLine($"Current user {currentUserId} level: {currentUserLevel}");

                    // Get the hierarchy level of the target employee
                    string targetLevelQuery = @"
						SELECT COALESCE(MAX(hierarchy_level), 0) as max_level
						FROM EmployeeHierarchy
						WHERE employee_id = @TargetId";

                    SqlCommand targetCmd = new SqlCommand(targetLevelQuery, conn);
                    targetCmd.Parameters.AddWithValue("@TargetId", targetEmployeeId);

                    object targetLevelResult = targetCmd.ExecuteScalar();
                    int targetEmployeeLevel = (targetLevelResult != null && targetLevelResult != DBNull.Value)
                        ? (int)targetLevelResult
                        : 0;

                    Console.WriteLine($"Target employee {targetEmployeeId} level: {targetEmployeeLevel}");

                    // If target has no hierarchy level, they might be a CEO/top-level
                    if (targetEmployeeLevel == 0)
                    {
                        return "You cannot assign a mission to a CEO or top-level executive.";
                    }

                    // Can only assign to people with HIGHER level number (lower in org chart)
                    // Level 1 = Top managers, Level 2 = Middle managers, Level 3+ = Regular employees
                    if (targetEmployeeLevel <= currentUserLevel)
                    {
                        return "You can only assign missions to employees at a lower hierarchical level than yourself.";
                    }

                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"ERROR in CheckEmploymentHierarchy: {ex.Message}");
                return $"Error checking hierarchy permissions: {ex.Message}";
            }

            return string.Empty; // No hierarchy issues found
        }


    }

    // Simple Employee model for dropdown
    public class Employee
    {
        public int EmployeeId { get; set; }
        public string FullName { get; set; }
        public int ManagerId { get; set; }
    }
}