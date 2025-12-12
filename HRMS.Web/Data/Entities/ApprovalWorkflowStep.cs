using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class ApprovalWorkflowStep
{
    public int workflow_id { get; set; }

    public int step_number { get; set; }

    public int? role_id { get; set; }

    public string? action_required { get; set; }

    public virtual Role? role { get; set; }

    public virtual ApprovalWorkflow workflow { get; set; } = null!;
}
