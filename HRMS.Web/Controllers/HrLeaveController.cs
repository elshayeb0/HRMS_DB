using HRMS.Web.Data;
using HRMS.Web.Data.Entities;
using HRMS.Web.Models.Leave;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HRMS.Web.Controllers
{
    public class HrLeaveController : Controller
    {
        private readonly AppDbContext _db;

        public HrLeaveController(AppDbContext db)
        {
            _db = db;
        }

        // =========================
        // Leave Types (EXISTING)
        // =========================

        // GET: /HrLeave/Types
        [HttpGet]
        public async Task<IActionResult> Types()
        {
            var types = await _db.Leaves
                .AsNoTracking()
                .OrderBy(l => l.leave_type)
                .ToListAsync();

            return View(types);
        }

        // GET: /HrLeave/CreateType
        [HttpGet]
        public IActionResult CreateType()
        {
            return View(new Leave());
        }

        // POST: /HrLeave/CreateType
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateType(Leave model)
        {
            if (string.IsNullOrWhiteSpace(model.leave_type))
                ModelState.AddModelError(nameof(model.leave_type), "Leave type is required.");

            if (!ModelState.IsValid)
                return View(model);

            _db.Leaves.Add(model);
            await _db.SaveChangesAsync();

            TempData["Success"] = "Leave type created.";
            return RedirectToAction(nameof(Types));
        }

        // GET: /HrLeave/EditType/5
        [HttpGet]
        public async Task<IActionResult> EditType(int id)
        {
            var entity = await _db.Leaves.FindAsync(id);
            if (entity == null) return NotFound();
            return View(entity);
        }

        // POST: /HrLeave/EditType
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EditType(Leave model)
        {
            if (string.IsNullOrWhiteSpace(model.leave_type))
                ModelState.AddModelError(nameof(model.leave_type), "Leave type is required.");

            if (!ModelState.IsValid)
                return View(model);

            _db.Leaves.Update(model);
            await _db.SaveChangesAsync();

            TempData["Success"] = "Leave type updated.";
            return RedirectToAction(nameof(Types));
        }

        // POST: /HrLeave/DeleteType/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteType(int id)
        {
            var entity = await _db.Leaves.FindAsync(id);
            if (entity == null) return NotFound();

            _db.Leaves.Remove(entity);
            await _db.SaveChangesAsync();

            TempData["Success"] = "Leave type deleted.";
            return RedirectToAction(nameof(Types));
        }

        // ==============================
        // HR Leave Entitlements
        // ==============================

        // GET: /HrLeave/Entitlements
        [HttpGet]
        public async Task<IActionResult> Entitlements()
        {
            var items = await _db.LeaveEntitlements
                .AsNoTracking()
                .Include(x => x.employee)
                .Include(x => x.leave_type)
                .OrderBy(x => x.employee_id)
                .ThenBy(x => x.leave_type.leave_type)
                .ToListAsync();

            return View(items);
        }

        // GET: /HrLeave/AssignEntitlement
        [HttpGet]
        public async Task<IActionResult> AssignEntitlement()
        {
            ViewBag.LeaveTypes = await _db.Leaves.AsNoTracking().OrderBy(l => l.leave_type).ToListAsync();
            return View();
        }

        // POST: /HrLeave/AssignEntitlement
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AssignEntitlement(int employeeId, string leaveType, decimal entitlement)
        {
            if (employeeId <= 0) ModelState.AddModelError(nameof(employeeId), "EmployeeId must be > 0.");
            if (string.IsNullOrWhiteSpace(leaveType)) ModelState.AddModelError(nameof(leaveType), "Leave type is required.");

            if (!ModelState.IsValid)
            {
                ViewBag.LeaveTypes = await _db.Leaves.AsNoTracking().OrderBy(l => l.leave_type).ToListAsync();
                return View();
            }

            await _db.Database.ExecuteSqlInterpolatedAsync($@"
        EXEC AssignLeaveEntitlement
            @EmployeeID={employeeId},
            @LeaveType={leaveType},
            @Entitlement={entitlement}
    ");

            TempData["Success"] = "Leave entitlement assigned/updated successfully.";
            return RedirectToAction(nameof(Entitlements));
        }

        // GET: /HrLeave/AdjustBalance
        [HttpGet]
        public async Task<IActionResult> AdjustBalance()
        {
            ViewBag.LeaveTypes = await _db.Leaves.AsNoTracking().OrderBy(l => l.leave_type).ToListAsync();
            return View();
        }

        // POST: /HrLeave/AdjustBalance
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AdjustBalance(int employeeId, string leaveType, decimal adjustment)
        {
            if (employeeId <= 0) ModelState.AddModelError(nameof(employeeId), "EmployeeId must be > 0.");
            if (string.IsNullOrWhiteSpace(leaveType)) ModelState.AddModelError(nameof(leaveType), "Leave type is required.");

            if (!ModelState.IsValid)
            {
                ViewBag.LeaveTypes = await _db.Leaves.AsNoTracking().OrderBy(l => l.leave_type).ToListAsync();
                return View();
            }

            await _db.Database.ExecuteSqlInterpolatedAsync($@"
        EXEC AdjustLeaveBalance
            @EmployeeID={employeeId},
            @LeaveType={leaveType},
            @Adjustment={adjustment}
    ");

            TempData["Success"] = "Leave balance adjusted successfully.";
            return RedirectToAction(nameof(Entitlements));
        }

        // =========================
        // NEW: Leave Policy + Eligibility
        // =========================

        // GET: /HrLeave/EditPolicy?policyId=1
        [HttpGet]
        public async Task<IActionResult> EditPolicy(int policyId)
        {
            var policy = await _db.LeavePolicies
                .AsNoTracking()
                .FirstOrDefaultAsync(p => p.policy_id == policyId);

            if (policy == null) return NotFound();

            var vm = new UpdateLeavePolicyVM
            {
                PolicyId = policyId,
                EligibilityRules = policy.eligibility_rules ?? "",
                NoticePeriod = policy.notice_period ?? 0
            };

            return View(vm);
        }

        // POST: /HrLeave/EditPolicy
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EditPolicy(UpdateLeavePolicyVM vm)
        {
            if (!ModelState.IsValid)
                return View(vm);

            await _db.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC UpdateLeavePolicy
                    @PolicyID={vm.PolicyId},
                    @EligibilityRules={vm.EligibilityRules},
                    @NoticePeriod={vm.NoticePeriod}
            ");

            TempData["Success"] = "Leave policy updated.";
            return RedirectToAction(nameof(EditPolicy), new { policyId = vm.PolicyId });
        }

        // GET: /HrLeave/Eligibility
        [HttpGet]
        public async Task<IActionResult> Eligibility()
        {
            ViewBag.LeaveTypes = await _db.Leaves
                .AsNoTracking()
                .OrderBy(l => l.leave_type)
                .ToListAsync();

            return View(new ConfigureLeaveEligibilityVM());
        }

        // POST: /HrLeave/Eligibility
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Eligibility(ConfigureLeaveEligibilityVM vm)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.LeaveTypes = await _db.Leaves
                    .AsNoTracking()
                    .OrderBy(l => l.leave_type)
                    .ToListAsync();

                return View(vm);
            }

            await _db.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC ConfigureLeaveEligibility
                    @LeaveType={vm.LeaveType},
                    @MinTenure={vm.MinTenure},
                    @EmployeeType={vm.EmployeeType}
            ");

            TempData["Success"] = "Eligibility rules saved.";
            return RedirectToAction(nameof(Eligibility));
        }
    }
}