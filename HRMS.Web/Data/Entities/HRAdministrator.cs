using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class HRAdministrator
{
    public int employee_id { get; set; }

    public int? approval_level { get; set; }

    public string? record_access_scope { get; set; }

    public string? document_validation_rights { get; set; }

    public virtual Employee employee { get; set; } = null!;
}
