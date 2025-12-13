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

    }
}