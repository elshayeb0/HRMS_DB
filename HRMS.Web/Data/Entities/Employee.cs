using System;
using System.Collections.Generic;

namespace HRMS.Web.Data.Entities;

public partial class Employee
{
    public int employee_id { get; set; }

    public string? first_name { get; set; }

    public string? last_name { get; set; }

    public string? full_name { get; set; }

    public string? national_id { get; set; }

    public DateOnly? date_of_birth { get; set; }

    public string? country_of_birth { get; set; }

    public string? phone { get; set; }

    public string? email { get; set; }

    public string? address { get; set; }

    public string? emergency_contact_name { get; set; }

    public string? emergency_contact_phone { get; set; }

    public string? relationship { get; set; }

    public string? biography { get; set; }

    public string? profile_image { get; set; }

    public string? employment_progress { get; set; }

    public string? account_status { get; set; }

    public string? employment_status { get; set; }

    public DateOnly? hire_date { get; set; }

    public bool? is_active { get; set; }

    public int? profile_completion { get; set; }

    public int? department_id { get; set; }

    public int? position_id { get; set; }

    public int? manager_id { get; set; }

    public int? contract_id { get; set; }

    public int? tax_form_id { get; set; }

    public int? salary_type_id { get; set; }

    public int? pay_grade { get; set; }

    public virtual ICollection<AllowanceDeduction> AllowanceDeductions { get; set; } = new List<AllowanceDeduction>();

    public virtual ICollection<AttendanceCorrectionRequest> AttendanceCorrectionRequestemployees { get; set; } = new List<AttendanceCorrectionRequest>();

    public virtual ICollection<AttendanceCorrectionRequest> AttendanceCorrectionRequestrecorded_byNavigations { get; set; } = new List<AttendanceCorrectionRequest>();

    public virtual ICollection<AttendanceLog> AttendanceLogs { get; set; } = new List<AttendanceLog>();

    public virtual ICollection<Attendance> Attendances { get; set; } = new List<Attendance>();

    public virtual ICollection<Department> Departments { get; set; } = new List<Department>();

    public virtual ICollection<Device> Devices { get; set; } = new List<Device>();

    public virtual ICollection<EmployeeHierarchy> EmployeeHierarchyemployees { get; set; } = new List<EmployeeHierarchy>();

    public virtual ICollection<EmployeeHierarchy> EmployeeHierarchymanagers { get; set; } = new List<EmployeeHierarchy>();

    public virtual ICollection<Employee_Notification> Employee_Notifications { get; set; } = new List<Employee_Notification>();

    public virtual ICollection<Employee_Role> Employee_Roles { get; set; } = new List<Employee_Role>();

    public virtual ICollection<Employee_Skill> Employee_Skills { get; set; } = new List<Employee_Skill>();

    public virtual HRAdministrator? HRAdministrator { get; set; }

    public virtual ICollection<Employee> Inversemanager { get; set; } = new List<Employee>();

    public virtual ICollection<LeaveEntitlement> LeaveEntitlements { get; set; } = new List<LeaveEntitlement>();

    public virtual ICollection<LeaveRequest> LeaveRequests { get; set; } = new List<LeaveRequest>();

    public virtual LineManager? LineManager { get; set; }

    public virtual ICollection<ManagerNote> ManagerNoteemployees { get; set; } = new List<ManagerNote>();

    public virtual ICollection<ManagerNote> ManagerNotemanagers { get; set; } = new List<ManagerNote>();

    public virtual ICollection<Mission> Missionemployees { get; set; } = new List<Mission>();

    public virtual ICollection<Mission> Missionmanagers { get; set; } = new List<Mission>();

    public virtual PayrollSpecialist? PayrollSpecialist { get; set; }

    public virtual ICollection<Payroll> Payrolls { get; set; } = new List<Payroll>();

    public virtual ICollection<Reimbursement> Reimbursements { get; set; } = new List<Reimbursement>();

    public virtual ICollection<ShiftAssignment> ShiftAssignments { get; set; } = new List<ShiftAssignment>();

    public virtual SystemAdministrator? SystemAdministrator { get; set; }

    public virtual Contract? contract { get; set; }

    public virtual Department? department { get; set; }

    public virtual Employee? manager { get; set; }

    public virtual PayGrade? pay_gradeNavigation { get; set; }

    public virtual Position? position { get; set; }

    public virtual SalaryType? salary_type { get; set; }

    public virtual TaxForm? tax_form { get; set; }

    public virtual ICollection<Exception> exceptions { get; set; } = new List<Exception>();

    public virtual ICollection<Verification> verifications { get; set; } = new List<Verification>();
}
