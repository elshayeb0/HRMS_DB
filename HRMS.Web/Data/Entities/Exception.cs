using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class Exception
{
    public int exception_id { get; set; }

    public string? name { get; set; }

    public string? category { get; set; }

    public DateOnly? date { get; set; }

    public string? status { get; set; }

    public virtual ICollection<Attendance> Attendances { get; set; } = new List<Attendance>();

    public virtual ICollection<Employee> employees { get; set; } = new List<Employee>();
}
