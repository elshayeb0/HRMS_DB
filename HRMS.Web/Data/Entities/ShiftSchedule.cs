using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class ShiftSchedule
{
    public int shift_id { get; set; }

    public string? name { get; set; }

    public string? type { get; set; }

    public TimeOnly? start_time { get; set; }

    public TimeOnly? end_time { get; set; }

    public int? break_duration { get; set; }

    public DateOnly? shift_date { get; set; }

    public string? status { get; set; }

    public string? location { get; set; }

    public decimal? allowance_amount { get; set; }

    public virtual ICollection<Attendance> Attendances { get; set; } = new List<Attendance>();

    public virtual ICollection<ShiftAssignment> ShiftAssignments { get; set; } = new List<ShiftAssignment>();

    public virtual ICollection<ShiftCycleAssignment> ShiftCycleAssignments { get; set; } = new List<ShiftCycleAssignment>();
}
