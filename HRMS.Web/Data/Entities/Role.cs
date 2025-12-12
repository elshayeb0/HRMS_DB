using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class Role
{
    public int role_id { get; set; }

    public string role_name { get; set; } = null!;

    public string? purpose { get; set; }

    public virtual ICollection<ApprovalWorkflowStep> ApprovalWorkflowSteps { get; set; } = new List<ApprovalWorkflowStep>();

    public virtual ICollection<Employee_Role> Employee_Roles { get; set; } = new List<Employee_Role>();

    public virtual ICollection<RolePermission> RolePermissions { get; set; } = new List<RolePermission>();
}
