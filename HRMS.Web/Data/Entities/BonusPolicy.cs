using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class BonusPolicy
{
    public int policy_id { get; set; }

    public string? bonus_type { get; set; }

    public string? eligibility_criteria { get; set; }

    public decimal? amount { get; set; }

    public virtual PayrollPolicy policy { get; set; } = null!;
}
