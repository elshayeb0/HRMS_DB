using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class ShiftCycle
{
    public int cycle_id { get; set; }

    public string? cycle_name { get; set; }

    public string? description { get; set; }

    public virtual ICollection<ShiftCycleAssignment> ShiftCycleAssignments { get; set; } = new List<ShiftCycleAssignment>();
}
