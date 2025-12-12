using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class PayGrade
{
    public int pay_grade_id { get; set; }

    public string grade_name { get; set; } = null!;

    public decimal? min_salary { get; set; }

    public decimal? max_salary { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();
}
