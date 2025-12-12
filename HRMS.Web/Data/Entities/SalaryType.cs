using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class SalaryType
{
    public int salary_type_id { get; set; }

    public string type { get; set; } = null!;

    public string? payment_frequency { get; set; }

    public string? currency { get; set; }

    public virtual ContractSalaryType? ContractSalaryType { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    public virtual HourlySalaryType? HourlySalaryType { get; set; }

    public virtual MonthlySalaryType? MonthlySalaryType { get; set; }

    public virtual Currency? currencyNavigation { get; set; }
}
