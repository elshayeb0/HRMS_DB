using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using HRMS.Web.Models.Mission;

namespace HRMS.Web.Controllers
{
    public class MissionController : Controller
    {
        private readonly string _connectionString;
        private readonly IConfiguration _configuration;

        // Constructor with dependency injection
        public MissionController(IConfiguration configuration)
        {
            _configuration = configuration;
            _connectionString = _configuration.GetConnectionString("DefaultConnection");
        }

        // ============================================
        // EMPLOYEE FEATURES
        // ============================================

        // GET: Mission/EmployeeMissions
        public IActionResult EmployeeMissions()
        {
            int employeeId = GetLoggedInEmployeeId();

            // DEBUG: Print what employee ID we got
            System.Diagnostics.Debug.WriteLine($"===== DEBUG EmployeeMissions =====");
            System.Diagnostics.Debug.WriteLine($"Employee ID: {employeeId}");

            List<Mission> missions = GetEmployeeMissions(employeeId);

            // DEBUG: Print how many missions we found
            System.Diagnostics.Debug.WriteLine($"Missions Found: {missions.Count}");
            foreach (var m in missions)
            {
                System.Diagnostics.Debug.WriteLine($"  - {m.MissionId}: {m.Destination}");
            }
            System.Diagnostics.Debug.WriteLine($"===== END DEBUG =====");

            return View(missions);
        }

        // ============================================
        // MANAGER FEATURES
        // ============================================

        // GET: Mission/ManagerMissions
        public IActionResult ManagerMissions()
        {
            int managerId = GetLoggedInEmployeeId();
            List<Mission> missions = GetManagerMissions(managerId);
            return View(missions);
        }

        // POST: Mission/ApproveMission
        [HttpPost]
        public IActionResult ApproveMission(int missionId, string remarks)
        {
            try
            {
                int managerId = GetLoggedInEmployeeId();
                bool success = ApproveMissionCompletion(missionId, managerId, remarks);

                if (success)
                {
                    TempData["SuccessMessage"] = "Mission approved successfully!";
                }
                else
                {
                    TempData["ErrorMessage"] = "Failed to approve mission.";
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = $"Error: {ex.Message}";
            }

            return RedirectToAction("ManagerMissions");
        }

        // POST: Mission/RejectMission
        [HttpPost]
        public IActionResult RejectMission(int missionId, string remarks)
        {
            try
            {
                int managerId = GetLoggedInEmployeeId();
                bool success = RejectMissionRequest(missionId, managerId, remarks);

                if (success)
                {
                    TempData["SuccessMessage"] = "Mission rejected.";
                }
                else
                {
                    TempData["ErrorMessage"] = "Failed to reject mission.";
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = $"Error: {ex.Message}";
            }

            return RedirectToAction("ManagerMissions");
        }

        // ============================================
        // HR ADMIN FEATURES
        // ============================================

        // GET: Mission/CreateMission
        public IActionResult CreateMission()
        {
            ViewBag.Employees = GetAllEmployees();
            ViewBag.Managers = GetAllManagers();
            return View();
        }

        // POST: Mission/CreateMission
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult CreateMission(Mission mission)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    bool success = AssignNewMission(mission);

                    if (success)
                    {
                        TempData["SuccessMessage"] = "Mission assigned successfully!";
                        return RedirectToAction("AllMissions");
                    }
                    else
                    {
                        TempData["ErrorMessage"] = "Failed to assign mission.";
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = $"Error: {ex.Message}";
            }

            ViewBag.Employees = GetAllEmployees();
            ViewBag.Managers = GetAllManagers();
            return View(mission);
        }

        // GET: Mission/AllMissions
        public IActionResult AllMissions()
        {
            List<Mission> missions = GetAllMissionsFromDB();
            return View(missions);
        }

        // ============================================
        // PRIVATE HELPER METHODS
        // ============================================

        private List<Mission> GetEmployeeMissions(int employeeId)
        {
            List<Mission> missions = new List<Mission>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"
                    SELECT m.mission_id, m.destination, m.start_date, m.end_date, 
                           m.status, m.employee_id, m.manager_id,
                           e.full_name AS employee_name,
                           mgr.full_name AS manager_name
                    FROM Mission m
                    INNER JOIN Employee e ON m.employee_id = e.employee_id
                    INNER JOIN Employee mgr ON m.manager_id = mgr.employee_id
                    WHERE m.employee_id = @EmployeeId
                    ORDER BY m.start_date DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        missions.Add(new Mission
                        {
                            MissionId = (int)reader["mission_id"],
                            Destination = reader["destination"].ToString(),
                            StartDate = (DateTime)reader["start_date"],
                            EndDate = (DateTime)reader["end_date"],
                            Status = reader["status"].ToString(),
                            EmployeeId = (int)reader["employee_id"],
                            ManagerId = (int)reader["manager_id"],
                            EmployeeName = reader["employee_name"].ToString(),
                            ManagerName = reader["manager_name"].ToString()
                        });
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"ERROR in GetEmployeeMissions: {ex.Message}");
                    throw;
                }
            }

            return missions;
        }

        private List<Mission> GetManagerMissions(int managerId)
        {
            List<Mission> missions = new List<Mission>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"
                    SELECT m.mission_id, m.destination, m.start_date, m.end_date, 
                           m.status, m.employee_id, m.manager_id,
                           e.full_name AS employee_name,
                           mgr.full_name AS manager_name
                    FROM Mission m
                    INNER JOIN Employee e ON m.employee_id = e.employee_id
                    INNER JOIN Employee mgr ON m.manager_id = mgr.employee_id
                    WHERE m.manager_id = @ManagerId
                    ORDER BY m.start_date DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ManagerId", managerId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    missions.Add(new Mission
                    {
                        MissionId = (int)reader["mission_id"],
                        Destination = reader["destination"].ToString(),
                        StartDate = (DateTime)reader["start_date"],
                        EndDate = (DateTime)reader["end_date"],
                        Status = reader["status"].ToString(),
                        EmployeeId = (int)reader["employee_id"],
                        ManagerId = (int)reader["manager_id"],
                        EmployeeName = reader["employee_name"].ToString(),
                        ManagerName = reader["manager_name"].ToString()
                    });
                }
            }

            return missions;
        }

        private bool ApproveMissionCompletion(int missionId, int managerId, string remarks)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("ApproveMissionCompletion", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@MissionID", missionId);
                cmd.Parameters.AddWithValue("@ManagerID", managerId);
                cmd.Parameters.AddWithValue("@Remarks", remarks ?? "");

                conn.Open();
                cmd.ExecuteNonQuery();
                return true;
            }
        }

        private bool RejectMissionRequest(int missionId, int managerId, string remarks)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"
                    UPDATE Mission 
                    SET status = 'Rejected' 
                    WHERE mission_id = @MissionId AND manager_id = @ManagerId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MissionId", missionId);
                cmd.Parameters.AddWithValue("@ManagerId", managerId);

                conn.Open();
                int rowsAffected = cmd.ExecuteNonQuery();
                return rowsAffected > 0;
            }
        }

        private bool AssignNewMission(Mission mission)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("AssignMission", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@EmployeeID", mission.EmployeeId);
                cmd.Parameters.AddWithValue("@ManagerID", mission.ManagerId);
                cmd.Parameters.AddWithValue("@Destination", mission.Destination);
                cmd.Parameters.AddWithValue("@StartDate", mission.StartDate);
                cmd.Parameters.AddWithValue("@EndDate", mission.EndDate);

                conn.Open();
                cmd.ExecuteNonQuery();
                return true;
            }
        }

        private List<Mission> GetAllMissionsFromDB()
        {
            List<Mission> missions = new List<Mission>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"
                    SELECT m.mission_id, m.destination, m.start_date, m.end_date, 
                           m.status, m.employee_id, m.manager_id,
                           e.full_name AS employee_name,
                           mgr.full_name AS manager_name
                    FROM Mission m
                    INNER JOIN Employee e ON m.employee_id = e.employee_id
                    INNER JOIN Employee mgr ON m.manager_id = mgr.employee_id
                    ORDER BY m.start_date DESC";

                SqlCommand cmd = new SqlCommand(query, conn);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    missions.Add(new Mission
                    {
                        MissionId = (int)reader["mission_id"],
                        Destination = reader["destination"].ToString(),
                        StartDate = (DateTime)reader["start_date"],
                        EndDate = (DateTime)reader["end_date"],
                        Status = reader["status"].ToString(),
                        EmployeeId = (int)reader["employee_id"],
                        ManagerId = (int)reader["manager_id"],
                        EmployeeName = reader["employee_name"].ToString(),
                        ManagerName = reader["manager_name"].ToString()
                    });
                }
            }

            return missions;
        }

        private List<SelectListItem> GetAllEmployees()
        {
            List<SelectListItem> employees = new List<SelectListItem>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = "SELECT employee_id, full_name FROM Employee WHERE is_active = 1";
                SqlCommand cmd = new SqlCommand(query, conn);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    employees.Add(new SelectListItem
                    {
                        Value = reader["employee_id"].ToString(),
                        Text = reader["full_name"].ToString()
                    });
                }
            }

            return employees;
        }

        private List<SelectListItem> GetAllManagers()
        {
            List<SelectListItem> managers = new List<SelectListItem>();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                string query = @"
                    SELECT DISTINCT e.employee_id, e.full_name 
                    FROM Employee e
                    INNER JOIN LineManager lm ON e.employee_id = lm.employee_id
                    WHERE e.is_active = 1";

                SqlCommand cmd = new SqlCommand(query, conn);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    managers.Add(new SelectListItem
                    {
                        Value = reader["employee_id"].ToString(),
                        Text = reader["full_name"].ToString()
                    });
                }
            }

            return managers;
        }

        private int GetLoggedInEmployeeId()
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

            // If nothing found, return 0 (which will show no missions)
            System.Diagnostics.Debug.WriteLine("❌ WARNING: No EmployeeId found in claims or session!");
            return 0;
        }
    }
}