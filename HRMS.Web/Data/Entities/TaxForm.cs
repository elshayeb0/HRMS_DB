using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class TaxForm
{
    public int tax_form_id { get; set; }

    public string? jurisdiction { get; set; }

    public int? validity_period { get; set; }

    public string? form_content { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();
}
