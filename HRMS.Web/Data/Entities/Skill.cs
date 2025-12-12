using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class Skill
{
    public int skill_id { get; set; }

    public string skill_name { get; set; } = null!;

    public string? description { get; set; }

    public virtual ICollection<Employee_Skill> Employee_Skills { get; set; } = new List<Employee_Skill>();
}
