using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class Verification
{
    public int verification_id { get; set; }

    public string? verification_type { get; set; }

    public string? issuer { get; set; }

    public DateOnly? issue_date { get; set; }

    public int? expiry_period { get; set; }

    public virtual ICollection<Employee> employees { get; set; } = new List<Employee>();
}
