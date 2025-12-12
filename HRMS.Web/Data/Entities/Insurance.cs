using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class Insurance
{
    public int insurance_id { get; set; }

    public string? type { get; set; }

    public decimal? contribution_rate { get; set; }

    public string? coverage { get; set; }
}
