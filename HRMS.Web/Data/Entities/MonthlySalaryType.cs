using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class MonthlySalaryType
{
    public int salary_type_id { get; set; }

    public string? tax_rule { get; set; }

    public string? contribution_scheme { get; set; }

    public virtual SalaryType salary_type { get; set; } = null!;
}
