using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class HourlySalaryType
{
    public int salary_type_id { get; set; }

    public decimal? hourly_rate { get; set; }

    public int? max_monthly_hours { get; set; }

    public virtual SalaryType salary_type { get; set; } = null!;
}
