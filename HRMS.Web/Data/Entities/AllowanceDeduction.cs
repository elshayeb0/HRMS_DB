using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class AllowanceDeduction
{
    public int ad_id { get; set; }

    public int? payroll_id { get; set; }

    public int? employee_id { get; set; }

    public string? type { get; set; }

    public decimal? amount { get; set; }

    public string? currency { get; set; }

    public int? duration { get; set; }

    public string? timezone { get; set; }

    public virtual Currency? currencyNavigation { get; set; }

    public virtual Employee? employee { get; set; }

    public virtual Payroll? payroll { get; set; }
}
