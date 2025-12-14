using HRMS.Web.Data;
using HRMS.Web.Models.Leave;
using HRMS.Web.Services.Leave;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HRMS.Web.Controllers
{
    public class LeaveController : Controller
    {
        private readonly AppDbContext _db;
        private readonly ILeaveService _leaveService;
        private readonly IWebHostEnvironment _env;

        public LeaveController(AppDbContext db, ILeaveService leaveService, IWebHostEnvironment env)
        {
            _db = db;
            _leaveService = leaveService;
            _env = env;
        }

        [HttpGet]
        public async Task<IActionResult> Submit()
        {
            ViewBag.LeaveTypes = await _db.Leaves.OrderBy(l => l.leave_type).ToListAsync();
            return View(new SubmitLeaveRequestVM { StartDate = DateTime.Today, EndDate = DateTime.Today });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Submit(SubmitLeaveRequestVM vm)
        {
            if (vm.EndDate.Date < vm.StartDate.Date)
                ModelState.AddModelError("", "End date must be >= start date.");

            if (!ModelState.IsValid)
            {
                ViewBag.LeaveTypes = await _db.Leaves.OrderBy(l => l.leave_type).ToListAsync();
                return View(vm);
            }

            var requestId = await _leaveService.SubmitLeaveRequestAsync(
                vm.EmployeeId, vm.LeaveTypeId, vm.StartDate, vm.EndDate, vm.Reason
            );

            var savedPaths = new List<string>();

            if (vm.Attachments != null && vm.Attachments.Count > 0)
            {
                var relDir = Path.Combine("uploads", "leaves", vm.EmployeeId.ToString());
                var absDir = Path.Combine(_env.WebRootPath, relDir);
                Directory.CreateDirectory(absDir);

                foreach (var file in vm.Attachments.Where(f => f.Length > 0))
                {
                    var ext = Path.GetExtension(file.FileName);
                    var fileName = $"{Guid.NewGuid():N}{ext}";
                    var absPath = Path.Combine(absDir, fileName);

                    using var stream = System.IO.File.Create(absPath);
                    await file.CopyToAsync(stream);

                    var relPath = "/" + Path.Combine(relDir, fileName).Replace("\\", "/");
                    savedPaths.Add(relPath);
                }

                await _leaveService.AttachDocumentsAsync(requestId, savedPaths);
            }

            TempData["Success"] = $"Leave request submitted. Request ID = {requestId}";
            return RedirectToAction(nameof(Submit));
        }

        [HttpGet]
        public async Task<IActionResult> History(int employeeId)
        {
            var data = await _leaveService.GetLeaveHistoryAsync(employeeId);
            ViewBag.EmployeeId = employeeId;
            return View(data);
        }

        [HttpGet]
        public async Task<IActionResult> Balance(int employeeId)
        {
            var data = await _leaveService.GetLeaveBalanceAsync(employeeId);
            ViewBag.EmployeeId = employeeId;
            return View(data);
        }

        [HttpGet]
        public async Task<IActionResult> Pending(int managerId)
        {
            var data = await _leaveService.GetPendingLeaveRequestsAsync(managerId);
            ViewBag.ManagerId = managerId;
            return View(data);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Approve(int managerId, int leaveRequestId)
        {
            var ok = await _leaveService.ApproveLeaveRequestAsync(managerId, leaveRequestId);
            TempData["Success"] = ok ? "Leave request approved." : "Not allowed or not pending.";
            return RedirectToAction(nameof(Pending), new { managerId });
        }

        [HttpGet]
        public IActionResult Reject(int managerId, int leaveRequestId)
        {
            ViewBag.ManagerId = managerId;
            ViewBag.LeaveRequestId = leaveRequestId;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Reject(int managerId, int leaveRequestId, string reason)
        {
            var ok = await _leaveService.RejectLeaveRequestAsync(managerId, leaveRequestId, reason);
            TempData["Success"] = ok ? "Leave request rejected." : "Not allowed or not pending.";
            return RedirectToAction(nameof(Pending), new { managerId });
        }

        [HttpGet]
        public IActionResult FlagIrregular(int managerId, int employeeId)
        {
            ViewBag.ManagerId = managerId;
            ViewBag.EmployeeId = employeeId;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> FlagIrregular(int managerId, int employeeId, string patternDescription)
        {
            if (string.IsNullOrWhiteSpace(patternDescription))
            {
                TempData["Error"] = "Pattern description is required.";
                return RedirectToAction(nameof(FlagIrregular), new { managerId, employeeId });
            }

            await _leaveService.FlagIrregularLeaveAsync(employeeId, managerId, patternDescription.Trim());

            TempData["Success"] = "Irregular leave pattern flagged.";
            return RedirectToAction(nameof(Pending), new { managerId });
        }

    }
}