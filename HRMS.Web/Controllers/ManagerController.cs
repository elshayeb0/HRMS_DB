using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using HRMS.Web.Models.Mission;
using Microsoft.AspNetCore.Http;

namespace HRMS.Web.Controllers
{
    public class ManagerController : Controller
    {
        private readonly string _connectionString;
        private readonly IConfiguration _configuration;

        public ManagerController(IConfiguration configuration)
        {
            _configuration = configuration;
            _connectionString = _configuration.GetConnectionString("DefaultConnection");
        }

        // GET: Manager/Missions
        public IActionResult ManagerMissions()
        {
            int managerId = GetLoggedInEmployeeId();
            System.Diagnostics.Debug.WriteLine($"===== MISSIONS PAGE LOADED =====");
            System.Diagnostics.Debug.WriteLine($"Manager ID: {managerId}");

            List<Mission> missions = GetPendingMissionsForManager(managerId);
            System.Diagnostics.Debug.WriteLine($"Found {missions.Count} missions");

            return View(missions);
        }

        // POST: Manager/ApproveMission
        [HttpPost]
        public IActionResult ApproveMission(int missionId, string remarks)
        {
            System.Diagnostics.Debug.WriteLine("===== APPROVE MISSION CALLED =====");
            System.Diagnostics.Debug.WriteLine($"Mission ID: {missionId}");
            System.Diagnostics.Debug.WriteLine($"Remarks: {remarks ?? "(empty)"}");

            try
            {
                if (missionId <= 0)
                {
                    System.Diagnostics.Debug.WriteLine("ERROR: Invalid mission ID");
                    TempData["ErrorMessage"] = "Invalid mission ID.";
                    return RedirectToAction("ManagerMissions");
                }

                int managerId = GetLoggedInEmployeeId();
                System.Diagnostics.Debug.WriteLine($"Manager ID: {managerId}");

                bool success = ApproveMissionCompletion(missionId, managerId, remarks);
                System.Diagnostics.Debug.WriteLine($"Approval result: {success}");

                if (success)
                {
                    TempData["SuccessMessage"] = $"Mission ID {missionId} approved successfully!";
                    System.Diagnostics.Debug.WriteLine("SUCCESS: Mission approved");
                }
                else
                {
                    TempData["ErrorMessage"] = $"Failed to approve Mission ID {missionId}.";
                    System.Diagnostics.Debug.WriteLine("FAILED: Mission not approved");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"EXCEPTION: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
                TempData["ErrorMessage"] = $"Error approving mission: {ex.Message}";
            }

            System.Diagnostics.Debug.WriteLine("Redirecting to ManagerMissions page...");
            return RedirectToAction("ManagerMissions");
        }

        // POST: Manager/RejectMission
        [HttpPost]
        public IActionResult RejectMission(int missionId, string remarks)
        {
            System.Diagnostics.Debug.WriteLine("===== REJECT MISSION CALLED =====");
            System.Diagnostics.Debug.WriteLine($"Mission ID: {missionId}");
            System.Diagnostics.Debug.WriteLine($"Remarks: {remarks ?? "(empty)"}");

            try
            {
                if (string.IsNullOrWhiteSpace(remarks))
                {
                    System.Diagnostics.Debug.WriteLine("ERROR: No remarks provided");
                    TempData["ErrorMessage"] = "Rejection requires manager remarks.";
                    return RedirectToAction("ManagerMissions");
                }

                if (missionId <= 0)
                {
                    System.Diagnostics.Debug.WriteLine("ERROR: Invalid mission ID");
                    TempData["ErrorMessage"] = "Invalid mission ID.";
                    return RedirectToAction("ManagerMissions");
                }

                int managerId = GetLoggedInEmployeeId();
                System.Diagnostics.Debug.WriteLine($"Manager ID: {managerId}");

                bool success = RejectMissionRequest(missionId, managerId, remarks);
                System.Diagnostics.Debug.WriteLine($"Rejection result: {success}");

                if (success)
                {
                    TempData["ErrorMessage"] = $"Mission ID {missionId} rejected successfully.";
                    System.Diagnostics.Debug.WriteLine("SUCCESS: Mission rejected");
                }
                else
                {
                    TempData["ErrorMessage"] = $"Failed to reject Mission ID {missionId}.";
                    System.Diagnostics.Debug.WriteLine("FAILED: Mission not rejected");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"EXCEPTION: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
                TempData["ErrorMessage"] = $"Error rejecting mission: {ex.Message}";
            }

            System.Diagnostics.Debug.WriteLine("Redirecting to ManagerMissions page...");
            return RedirectToAction("ManagerMissions");
        }

        private List<Mission> GetPendingMissionsForManager(int managerId)
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
                      AND m.status = 'Pending'  
                    ORDER BY m.start_date DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ManagerId", managerId);

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

                        System.Diagnostics.Debug.WriteLine($"Mission loaded: ID={reader["mission_id"]}, Status={reader["status"]}");
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"ERROR in GetPendingMissionsForManager: {ex.Message}");
                    throw;
                }
            }
            return missions;
        }

        private bool ApproveMissionCompletion(int missionId, int managerId, string remarks)
        {
            System.Diagnostics.Debug.WriteLine($"Calling stored procedure ApproveMissionCompletion...");
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                SqlCommand cmd = new SqlCommand("ApproveMissionCompletion", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@MissionID", missionId);
                cmd.Parameters.AddWithValue("@ManagerID", managerId);
                cmd.Parameters.AddWithValue("@Remarks", remarks ?? "");

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    System.Diagnostics.Debug.WriteLine("✅ Stored procedure ApproveMissionCompletion executed successfully");
                    return true;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"❌ ERROR executing ApproveMissionCompletion: {ex.Message}");
                    throw;
                }
            }
        }

        private bool RejectMissionRequest(int missionId, int managerId, string remarks)
        {
            System.Diagnostics.Debug.WriteLine($"Executing rejection UPDATE query...");
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                // FIXED: Changed query to only update status (no manager_remark column in Mission table)
                string query = @"
                    UPDATE Mission 
                    SET status = 'Rejected'
                    WHERE mission_id = @MissionId AND manager_id = @ManagerId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MissionId", missionId);
                cmd.Parameters.AddWithValue("@ManagerId", managerId);

                try
                {
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    System.Diagnostics.Debug.WriteLine($"Rows affected: {rowsAffected}");

                    if (rowsAffected > 0)
                    {
                        System.Diagnostics.Debug.WriteLine("✅ Mission status updated to Rejected");
                        return true;
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine("❌ No rows affected - Mission not found or not authorized");
                        return false;
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"❌ ERROR executing rejection: {ex.Message}");
                    throw;
                }
            }
        }

        // FIXED: GetLoggedInEmployeeId - Now uses User claims (from authentication)
        private int GetLoggedInEmployeeId()
        {
            // Try to get from User claims first (from authentication)
            if (User?.Identity?.IsAuthenticated == true)
            {
                var userIdClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);
                if (userIdClaim != null && int.TryParse(userIdClaim.Value, out int userId))
                {
                    System.Diagnostics.Debug.WriteLine($"✅ Got ManagerId from claims: {userId}");
                    return userId;
                }
            }

            // If not in claims, try session as fallback
            var sessionEmployeeId = HttpContext.Session.GetInt32("EmployeeId");
            if (sessionEmployeeId.HasValue)
            {
                System.Diagnostics.Debug.WriteLine($"✅ Got ManagerId from session: {sessionEmployeeId}");
                return sessionEmployeeId.Value;
            }

            // If nothing found, return 0 (which will show no pending missions)
            System.Diagnostics.Debug.WriteLine("❌ WARNING: No ManagerId found in claims or session!");
            return 0;
        }
    }
}