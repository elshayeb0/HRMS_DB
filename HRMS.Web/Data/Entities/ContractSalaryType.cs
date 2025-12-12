using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class ContractSalaryType
{
    public int salary_type_id { get; set; }

    public decimal? contract_value { get; set; }

    public string? installment_details { get; set; }

    public virtual SalaryType salary_type { get; set; } = null!;
}
