using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class ManagerNote
{
    public int note_id { get; set; }

    public int? employee_id { get; set; }

    public int? manager_id { get; set; }

    public string? note_content { get; set; }

    public DateTime? created_at { get; set; }

    public virtual Employee? employee { get; set; }

    public virtual Employee? manager { get; set; }
}
