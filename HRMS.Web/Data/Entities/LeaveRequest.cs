using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class LeaveRequest
{
    public int request_id { get; set; }

    public int? employee_id { get; set; }

    public int? leave_id { get; set; }

    public string? justification { get; set; }

    public int? duration { get; set; }

    public DateTime? approval_timing { get; set; }

    public string? status { get; set; }

    public virtual ICollection<LeaveDocument> LeaveDocuments { get; set; } = new List<LeaveDocument>();

    public virtual Employee? employee { get; set; }

    public virtual Leave? leave { get; set; }
}
