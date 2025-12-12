using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class Attendance
{
    public int attendance_id { get; set; }

    public int? employee_id { get; set; }

    public int? shift_id { get; set; }

    public DateTime? entry_time { get; set; }

    public DateTime? exit_time { get; set; }

    public int? duration { get; set; }

    public string? login_method { get; set; }

    public string? logout_method { get; set; }

    public int? exception_id { get; set; }

    public virtual ICollection<AttendanceLog> AttendanceLogs { get; set; } = new List<AttendanceLog>();

    public virtual ICollection<AttendanceSource> AttendanceSources { get; set; } = new List<AttendanceSource>();

    public virtual Employee? employee { get; set; }

    public virtual Exception? exception { get; set; }

    public virtual ShiftSchedule? shift { get; set; }
}
