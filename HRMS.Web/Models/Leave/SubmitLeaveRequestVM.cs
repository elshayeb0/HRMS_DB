using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace HRMS.Web.Models.Leave
{
    public class SubmitLeaveRequestVM
    {
        [Required]
        public int EmployeeId { get; set; }

        [Required]
        public int LeaveTypeId { get; set; }

        [Required, DataType(DataType.Date)]
        public DateTime StartDate { get; set; }

        [Required, DataType(DataType.Date)]
        public DateTime EndDate { get; set; }

        [Required, StringLength(100)]
        public string Reason { get; set; } = string.Empty;

        public List<IFormFile> Attachments { get; set; } = new();
    }
}