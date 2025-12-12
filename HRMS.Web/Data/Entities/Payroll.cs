using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class Payroll
{
    public int payroll_id { get; set; }

    public int? employee_id { get; set; }

    public decimal? taxes { get; set; }

    public DateOnly? period_start { get; set; }

    public DateOnly? period_end { get; set; }

    public decimal? base_amount { get; set; }

    public decimal? adjustments { get; set; }

    public decimal? contributions { get; set; }

    public decimal? actual_pay { get; set; }

    public decimal? net_salary { get; set; }

    public DateOnly? payment_date { get; set; }

    public virtual ICollection<AllowanceDeduction> AllowanceDeductions { get; set; } = new List<AllowanceDeduction>();

    public virtual ICollection<PayrollPeriod> PayrollPeriods { get; set; } = new List<PayrollPeriod>();

    public virtual ICollection<Payroll_Log> Payroll_Logs { get; set; } = new List<Payroll_Log>();

    public virtual Employee? employee { get; set; }

    public virtual ICollection<PayrollPolicy> policies { get; set; } = new List<PayrollPolicy>();
}
