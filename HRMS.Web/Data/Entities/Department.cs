using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class Department
{
    public int department_id { get; set; }

    public string department_name { get; set; } = null!;

    public string? purpose { get; set; }

    public int? department_head_id { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    public virtual Employee? department_head { get; set; }
}
