using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class ShiftAssignment
{
    public int assignment_id { get; set; }

    public int? employee_id { get; set; }

    public int? shift_id { get; set; }

    public DateOnly? start_date { get; set; }

    public DateOnly? end_date { get; set; }

    public string? status { get; set; }

    public virtual Employee? employee { get; set; }

    public virtual ShiftSchedule? shift { get; set; }
}
