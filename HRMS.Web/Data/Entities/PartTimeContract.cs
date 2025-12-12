using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class PartTimeContract
{
    public int contract_id { get; set; }

    public int? working_hours { get; set; }

    public decimal? hourly_rate { get; set; }

    public virtual Contract contract { get; set; } = null!;
}
