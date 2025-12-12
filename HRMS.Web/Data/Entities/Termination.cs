using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class Termination
{
    public int termination_id { get; set; }

    public DateOnly? date { get; set; }

    public string? reason { get; set; }

    public int? contract_id { get; set; }

    public virtual Contract? contract { get; set; }
}
