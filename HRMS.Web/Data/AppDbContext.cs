using System;
using System.Collections.Generic;
using HRMS.Web.Data.Entities;
using HrmsException = HRMS.Web.Data.Entities.Exception;
using Microsoft.EntityFrameworkCore;

namespace HRMS.Web.Data;

public partial class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<AllowanceDeduction> AllowanceDeductions { get; set; }

    public virtual DbSet<ApprovalWorkflow> ApprovalWorkflows { get; set; }

    public virtual DbSet<ApprovalWorkflowStep> ApprovalWorkflowSteps { get; set; }

    public virtual DbSet<Attendance> Attendances { get; set; }

    public virtual DbSet<AttendanceCorrectionRequest> AttendanceCorrectionRequests { get; set; }

    public virtual DbSet<AttendanceLog> AttendanceLogs { get; set; }

    public virtual DbSet<AttendanceSource> AttendanceSources { get; set; }

    public virtual DbSet<BonusPolicy> BonusPolicies { get; set; }

    public virtual DbSet<ConsultantContract> ConsultantContracts { get; set; }

    public virtual DbSet<Contract> Contracts { get; set; }

    public virtual DbSet<ContractSalaryType> ContractSalaryTypes { get; set; }

    public virtual DbSet<Currency> Currencies { get; set; }

    public virtual DbSet<DeductionPolicy> DeductionPolicies { get; set; }

    public virtual DbSet<Department> Departments { get; set; }

    public virtual DbSet<Device> Devices { get; set; }

    public virtual DbSet<Employee> Employees { get; set; }

    public virtual DbSet<EmployeeHierarchy> EmployeeHierarchies { get; set; }

    public virtual DbSet<Employee_Notification> Employee_Notifications { get; set; }

    public virtual DbSet<Employee_Role> Employee_Roles { get; set; }

    public virtual DbSet<Employee_Skill> Employee_Skills { get; set; }

    public virtual DbSet<HrmsException> Exceptions { get; set; }

    public virtual DbSet<FullTimeContract> FullTimeContracts { get; set; }

    public virtual DbSet<HRAdministrator> HRAdministrators { get; set; }

    public virtual DbSet<HolidayLeave> HolidayLeaves { get; set; }

    public virtual DbSet<HourlySalaryType> HourlySalaryTypes { get; set; }

    public virtual DbSet<Insurance> Insurances { get; set; }

    public virtual DbSet<InternshipContract> InternshipContracts { get; set; }

    public virtual DbSet<LatenessPolicy> LatenessPolicies { get; set; }

    public virtual DbSet<Leave> Leaves { get; set; }

    public virtual DbSet<LeaveDocument> LeaveDocuments { get; set; }

    public virtual DbSet<LeaveEntitlement> LeaveEntitlements { get; set; }

    public virtual DbSet<LeavePolicy> LeavePolicies { get; set; }

    public virtual DbSet<LeaveRequest> LeaveRequests { get; set; }

    public virtual DbSet<LineManager> LineManagers { get; set; }

    public virtual DbSet<ManagerNote> ManagerNotes { get; set; }

    public virtual DbSet<Mission> Missions { get; set; }

    public virtual DbSet<MonthlySalaryType> MonthlySalaryTypes { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<OvertimePolicy> OvertimePolicies { get; set; }

    public virtual DbSet<PartTimeContract> PartTimeContracts { get; set; }

    public virtual DbSet<PayGrade> PayGrades { get; set; }

    public virtual DbSet<Payroll> Payrolls { get; set; }

    public virtual DbSet<PayrollPeriod> PayrollPeriods { get; set; }

    public virtual DbSet<PayrollPolicy> PayrollPolicies { get; set; }

    public virtual DbSet<PayrollSpecialist> PayrollSpecialists { get; set; }

    public virtual DbSet<Payroll_Log> Payroll_Logs { get; set; }

    public virtual DbSet<Position> Positions { get; set; }

    public virtual DbSet<ProbationLeave> ProbationLeaves { get; set; }

    public virtual DbSet<Reimbursement> Reimbursements { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<RolePermission> RolePermissions { get; set; }

    public virtual DbSet<SalaryType> SalaryTypes { get; set; }

    public virtual DbSet<ShiftAssignment> ShiftAssignments { get; set; }

    public virtual DbSet<ShiftCycle> ShiftCycles { get; set; }

    public virtual DbSet<ShiftCycleAssignment> ShiftCycleAssignments { get; set; }

    public virtual DbSet<ShiftSchedule> ShiftSchedules { get; set; }

    public virtual DbSet<SickLeave> SickLeaves { get; set; }

    public virtual DbSet<Skill> Skills { get; set; }

    public virtual DbSet<SystemAdministrator> SystemAdministrators { get; set; }

    public virtual DbSet<TaxForm> TaxForms { get; set; }

    public virtual DbSet<Termination> Terminations { get; set; }

    public virtual DbSet<VacationLeave> VacationLeaves { get; set; }

    public virtual DbSet<Verification> Verifications { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AllowanceDeduction>(entity =>
        {
            entity.HasKey(e => e.ad_id).HasName("PK__Allowanc__CAA4A62731BE11C5");

            entity.ToTable("AllowanceDeduction");

            entity.Property(e => e.amount).HasColumnType("decimal(11, 3)");
            entity.Property(e => e.currency)
                .HasMaxLength(65)
                .IsUnicode(false);
            entity.Property(e => e.timezone)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.type)
                .HasMaxLength(60)
                .IsUnicode(false);

            entity.HasOne(d => d.currencyNavigation).WithMany(p => p.AllowanceDeductions)
                .HasPrincipalKey(p => p.CurrencyName)
                .HasForeignKey(d => d.currency)
                .HasConstraintName("FK__Allowance__curre__540C7B00");

            entity.HasOne(d => d.employee).WithMany(p => p.AllowanceDeductions)
                .HasForeignKey(d => d.employee_id)
                .HasConstraintName("FK__Allowance__emplo__531856C7");

            entity.HasOne(d => d.payroll).WithMany(p => p.AllowanceDeductions)
                .HasForeignKey(d => d.payroll_id)
                .HasConstraintName("FK__Allowance__payro__5224328E");
        });

        modelBuilder.Entity<ApprovalWorkflow>(entity =>
        {
            entity.HasKey(e => e.workflow_id).HasName("PK__Approval__64A76B70FD496EE9");

            entity.ToTable("ApprovalWorkflow");

            entity.Property(e => e.approver_role)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.status)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.threshold_amount).HasColumnType("decimal(11, 2)");
            entity.Property(e => e.workflow_type)
                .HasMaxLength(60)
                .IsUnicode(false);
        });

        modelBuilder.Entity<ApprovalWorkflowStep>(entity =>
        {
            entity.HasKey(e => new { e.workflow_id, e.step_number }).HasName("PK__Approval__D7E8C7651AAEEABB");

            entity.ToTable("ApprovalWorkflowStep");

            entity.Property(e => e.action_required)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.HasOne(d => d.role).WithMany(p => p.ApprovalWorkflowSteps)
                .HasForeignKey(d => d.role_id)
                .HasConstraintName("FK__ApprovalW__role___00DF2177");

            entity.HasOne(d => d.workflow).WithMany(p => p.ApprovalWorkflowSteps)
                .HasForeignKey(d => d.workflow_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ApprovalW__workf__7FEAFD3E");
        });

        modelBuilder.Entity<Attendance>(entity =>
        {
            entity.HasKey(e => e.attendance_id).HasName("PK__Attendan__20D6A9682414176A");

            entity.ToTable("Attendance");

            entity.Property(e => e.entry_time).HasColumnType("datetime");
            entity.Property(e => e.exit_time).HasColumnType("datetime");
            entity.Property(e => e.login_method)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.logout_method)
                .HasMaxLength(110)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithMany(p => p.Attendances)
                .HasForeignKey(d => d.employee_id)
                .HasConstraintName("FK__Attendanc__emplo__2180FB33");

            entity.HasOne(d => d.exception).WithMany(p => p.Attendances)
                .HasForeignKey(d => d.exception_id)
                .HasConstraintName("FK__Attendanc__excep__236943A5");

            entity.HasOne(d => d.shift).WithMany(p => p.Attendances)
                .HasForeignKey(d => d.shift_id)
                .HasConstraintName("FK__Attendanc__shift__22751F6C");
        });

        modelBuilder.Entity<AttendanceCorrectionRequest>(entity =>
        {
            entity.HasKey(e => e.request_id).HasName("PK__Attendan__18D3B90F27D5D055");

            entity.ToTable("AttendanceCorrectionRequest");

            entity.Property(e => e.correction_type)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.reason)
                .HasMaxLength(500)
                .IsUnicode(false);
            entity.Property(e => e.status)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithMany(p => p.AttendanceCorrectionRequestemployees)
                .HasForeignKey(d => d.employee_id)
                .HasConstraintName("FK__Attendanc__emplo__2A164134");

            entity.HasOne(d => d.recorded_byNavigation).WithMany(p => p.AttendanceCorrectionRequestrecorded_byNavigations)
                .HasForeignKey(d => d.recorded_by)
                .HasConstraintName("FK__Attendanc__recor__2B0A656D");
        });

        modelBuilder.Entity<AttendanceLog>(entity =>
        {
            entity.HasKey(e => e.attendance_log_id).HasName("PK__Attendan__DB38FB09C31CD3C4");

            entity.ToTable("AttendanceLog");

            entity.Property(e => e.reason)
                .HasMaxLength(600)
                .IsUnicode(false);
            entity.Property(e => e.timestamp).HasColumnType("datetime");

            entity.HasOne(d => d.actorNavigation).WithMany(p => p.AttendanceLogs)
                .HasForeignKey(d => d.actor)
                .HasConstraintName("FK__Attendanc__actor__2739D489");

            entity.HasOne(d => d.attendance).WithMany(p => p.AttendanceLogs)
                .HasForeignKey(d => d.attendance_id)
                .HasConstraintName("FK__Attendanc__atten__2645B050");
        });

        modelBuilder.Entity<AttendanceSource>(entity =>
        {
            entity.HasKey(e => new { e.attendance_id, e.device_id }).HasName("PK__Attendan__83662CB0DF11DDAA");

            entity.ToTable("AttendanceSource");

            entity.Property(e => e.latitude).HasColumnType("decimal(10, 9)");
            entity.Property(e => e.longitude).HasColumnType("decimal(12, 8)");
            entity.Property(e => e.recorded_at).HasColumnType("datetime");
            entity.Property(e => e.source_type)
                .HasMaxLength(60)
                .IsUnicode(false);

            entity.HasOne(d => d.attendance).WithMany(p => p.AttendanceSources)
                .HasForeignKey(d => d.attendance_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Attendanc__atten__3493CFA7");

            entity.HasOne(d => d.device).WithMany(p => p.AttendanceSources)
                .HasForeignKey(d => d.device_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Attendanc__devic__3587F3E0");
        });

        modelBuilder.Entity<BonusPolicy>(entity =>
        {
            entity.HasKey(e => e.policy_id).HasName("PK__BonusPol__47DA3F0367EBA6E9");

            entity.ToTable("BonusPolicy");

            entity.Property(e => e.policy_id).ValueGeneratedNever();
            entity.Property(e => e.amount).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.bonus_type)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.eligibility_criteria).IsUnicode(false);

            entity.HasOne(d => d.policy).WithOne(p => p.BonusPolicy)
                .HasForeignKey<BonusPolicy>(d => d.policy_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__BonusPoli__polic__5E8A0973");
        });

        modelBuilder.Entity<ConsultantContract>(entity =>
        {
            entity.HasKey(e => e.contract_id).HasName("PK__Consulta__F8D664235DEC8D9C");

            entity.ToTable("ConsultantContract");

            entity.Property(e => e.contract_id).ValueGeneratedNever();
            entity.Property(e => e.fees).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.payment_schedule)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.project_scope).IsUnicode(false);

            entity.HasOne(d => d.contract).WithOne(p => p.ConsultantContract)
                .HasForeignKey<ConsultantContract>(d => d.contract_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Consultan__contr__6C190EBB");
        });

        modelBuilder.Entity<Contract>(entity =>
        {
            entity.HasKey(e => e.contract_id).HasName("PK__Contract__F8D66423FCE5695F");

            entity.ToTable("Contract");

            entity.Property(e => e.current_state)
                .HasMaxLength(80)
                .IsUnicode(false)
                .HasDefaultValue("Active");
            entity.Property(e => e.type)
                .HasMaxLength(80)
                .IsUnicode(false);
        });

        modelBuilder.Entity<ContractSalaryType>(entity =>
        {
            entity.HasKey(e => e.salary_type_id).HasName("PK__Contract__4D647062201908E4");

            entity.ToTable("ContractSalaryType");

            entity.Property(e => e.salary_type_id).ValueGeneratedNever();
            entity.Property(e => e.contract_value).HasColumnType("decimal(11, 3)");
            entity.Property(e => e.installment_details)
                .HasMaxLength(505)
                .IsUnicode(false);

            entity.HasOne(d => d.salary_type).WithOne(p => p.ContractSalaryType)
                .HasForeignKey<ContractSalaryType>(d => d.salary_type_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ContractS__salar__4F47C5E3");
        });

        modelBuilder.Entity<Currency>(entity =>
        {
            entity.HasKey(e => e.CurrencyCode).HasName("PK__Currency__408426BE780578B7");

            entity.ToTable("Currency");

            entity.HasIndex(e => e.CurrencyName, "UQ__Currency__3D13D298CA91B008").IsUnique();

            entity.Property(e => e.CurrencyCode)
                .HasMaxLength(11)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.CurrencyName)
                .HasMaxLength(65)
                .IsUnicode(false);
            entity.Property(e => e.ExchangeRate).HasColumnType("decimal(13, 5)");
            entity.Property(e => e.LastUpdated)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
        });

        modelBuilder.Entity<DeductionPolicy>(entity =>
        {
            entity.HasKey(e => e.policy_id).HasName("PK__Deductio__47DA3F037AC92AB6");

            entity.ToTable("DeductionPolicy");

            entity.Property(e => e.policy_id).ValueGeneratedNever();
            entity.Property(e => e.calculation_mode)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.deduction_reason)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.HasOne(d => d.policy).WithOne(p => p.DeductionPolicy)
                .HasForeignKey<DeductionPolicy>(d => d.policy_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Deduction__polic__6166761E");
        });

        modelBuilder.Entity<Department>(entity =>
        {
            entity.HasKey(e => e.department_id).HasName("PK__Departme__C22324225016D9C6");

            entity.ToTable("Department");

            entity.Property(e => e.department_name)
                .HasMaxLength(80)
                .IsUnicode(false);
            entity.Property(e => e.purpose)
                .HasMaxLength(400)
                .IsUnicode(false);

            entity.HasOne(d => d.department_head).WithMany(p => p.Departments)
                .HasForeignKey(d => d.department_head_id)
                .HasConstraintName("FK_Department_Head");
        });

        modelBuilder.Entity<Device>(entity =>
        {
            entity.HasKey(e => e.device_id).HasName("PK__Device__3B085D8BA4AA41F8");

            entity.ToTable("Device");

            entity.Property(e => e.device_type)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.latitude).HasColumnType("decimal(11, 6)");
            entity.Property(e => e.longitude).HasColumnType("decimal(12, 8)");
            entity.Property(e => e.terminal_id)
                .HasMaxLength(70)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithMany(p => p.Devices)
                .HasForeignKey(d => d.employee_id)
                .HasConstraintName("FK__Device__employee__31B762FC");
        });

        modelBuilder.Entity<Employee>(entity =>
        {
            entity.HasKey(e => e.employee_id).HasName("PK__Employee__C52E0BA81F7A461D");

            entity.ToTable("Employee");

            entity.HasIndex(e => e.email, "UQ__Employee__AB6E6164DC165F41").IsUnique();

            entity.Property(e => e.account_status)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasDefaultValue("Active");
            entity.Property(e => e.address)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.biography).IsUnicode(false);
            entity.Property(e => e.country_of_birth)
                .HasMaxLength(30)
                .IsUnicode(false);
            entity.Property(e => e.email)
                .HasMaxLength(80)
                .IsUnicode(false);
            entity.Property(e => e.emergency_contact_name)
                .HasMaxLength(80)
                .IsUnicode(false);
            entity.Property(e => e.emergency_contact_phone)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.employment_progress)
                .HasMaxLength(65)
                .IsUnicode(false);
            entity.Property(e => e.employment_status)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasDefaultValue("Active");
            entity.Property(e => e.first_name)
                .HasMaxLength(30)
                .IsUnicode(false);
            entity.Property(e => e.full_name)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.is_active).HasDefaultValue(true);
            entity.Property(e => e.last_name)
                .HasMaxLength(30)
                .IsUnicode(false);
            entity.Property(e => e.national_id)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.phone)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.profile_completion).HasDefaultValue(0);
            entity.Property(e => e.profile_image)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.relationship)
                .HasMaxLength(25)
                .IsUnicode(false);

            entity.HasOne(d => d.contract).WithMany(p => p.Employees)
                .HasForeignKey(d => d.contract_id)
                .HasConstraintName("FK_Employee_Contract");

            entity.HasOne(d => d.department).WithMany(p => p.Employees)
                .HasForeignKey(d => d.department_id)
                .HasConstraintName("FK__Employee__depart__412EB0B6");

            entity.HasOne(d => d.manager).WithMany(p => p.Inversemanager)
                .HasForeignKey(d => d.manager_id)
                .HasConstraintName("FK__Employee__manage__4316F928");

            entity.HasOne(d => d.pay_gradeNavigation).WithMany(p => p.Employees)
                .HasForeignKey(d => d.pay_grade)
                .HasConstraintName("FK_Employee_PayGrade");

            entity.HasOne(d => d.position).WithMany(p => p.Employees)
                .HasForeignKey(d => d.position_id)
                .HasConstraintName("FK__Employee__positi__4222D4EF");

            entity.HasOne(d => d.salary_type).WithMany(p => p.Employees)
                .HasForeignKey(d => d.salary_type_id)
                .HasConstraintName("FK_Employee_SalaryType");

            entity.HasOne(d => d.tax_form).WithMany(p => p.Employees)
                .HasForeignKey(d => d.tax_form_id)
                .HasConstraintName("FK_Employee_TaxForm");

            entity.HasMany(d => d.exceptions).WithMany(p => p.employees)
                .UsingEntity<Dictionary<string, object>>(
                    "Employee_Exception",
                    r => r.HasOne<HrmsException>().WithMany()
                        .HasForeignKey("exception_id")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Employee___excep__2EDAF651"),
                    l => l.HasOne<Employee>().WithMany()
                        .HasForeignKey("employee_id")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Employee___emplo__2DE6D218"),
                    j =>
                    {
                        j.HasKey("employee_id", "exception_id").HasName("PK__Employee__F96CD564320BBE2B");
                        j.ToTable("Employee_Exception");
                    });

            entity.HasMany(d => d.verifications).WithMany(p => p.employees)
                .UsingEntity<Dictionary<string, object>>(
                    "Employee_Verification",
                    r => r.HasOne<Verification>().WithMany()
                        .HasForeignKey("verification_id")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Employee___verif__0B5CAFEA"),
                    l => l.HasOne<Employee>().WithMany()
                        .HasForeignKey("employee_id")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Employee___emplo__0A688BB1"),
                    j =>
                    {
                        j.HasKey("employee_id", "verification_id").HasName("PK__Employee__47611C3E8701AF07");
                        j.ToTable("Employee_Verification");
                    });
        });

        modelBuilder.Entity<EmployeeHierarchy>(entity =>
        {
            entity.HasKey(e => new { e.employee_id, e.manager_id }).HasName("PK__Employee__10880C97880DC67B");

            entity.ToTable("EmployeeHierarchy");

            entity.HasOne(d => d.employee).WithMany(p => p.EmployeeHierarchyemployees)
                .HasForeignKey(d => d.employee_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__EmployeeH__emplo__5629CD9C");

            entity.HasOne(d => d.manager).WithMany(p => p.EmployeeHierarchymanagers)
                .HasForeignKey(d => d.manager_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__EmployeeH__manag__571DF1D5");
        });

        modelBuilder.Entity<Employee_Notification>(entity =>
        {
            entity.HasKey(e => new { e.employee_id, e.notification_id }).HasName("PK__Employee__2B2B93EAA00BD616");

            entity.ToTable("Employee_Notification");

            entity.Property(e => e.delivered_at).HasColumnType("datetime");
            entity.Property(e => e.delivery_status)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithMany(p => p.Employee_Notifications)
                .HasForeignKey(d => d.employee_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Employee___emplo__7A3223E8");

            entity.HasOne(d => d.notification).WithMany(p => p.Employee_Notifications)
                .HasForeignKey(d => d.notification_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Employee___notif__7B264821");
        });

        modelBuilder.Entity<Employee_Role>(entity =>
        {
            entity.HasKey(e => new { e.employee_id, e.role_id }).HasName("PK__Employee__124E9DF4A951A990");

            entity.ToTable("Employee_Role");

            entity.Property(e => e.assigned_date)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.employee).WithMany(p => p.Employee_Roles)
                .HasForeignKey(d => d.employee_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Employee___emplo__52593CB8");

            entity.HasOne(d => d.role).WithMany(p => p.Employee_Roles)
                .HasForeignKey(d => d.role_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Employee___role___534D60F1");
        });

        modelBuilder.Entity<Employee_Skill>(entity =>
        {
            entity.HasKey(e => new { e.employee_id, e.skill_id }).HasName("PK__Employee__4A95A39F9D0DFA10");

            entity.ToTable("Employee_Skill");

            entity.Property(e => e.proficiency_level)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithMany(p => p.Employee_Skills)
                .HasForeignKey(d => d.employee_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Employee___emplo__5EBF139D");

            entity.HasOne(d => d.skill).WithMany(p => p.Employee_Skills)
                .HasForeignKey(d => d.skill_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Employee___skill__5FB337D6");
        });

        modelBuilder.Entity<HrmsException>(entity =>
        {
            entity.HasKey(e => e.exception_id).HasName("PK__Exceptio__C42DECC2F557C9D7");

            entity.ToTable("Exception");

            entity.Property(e => e.category)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.name)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.status)
                .HasMaxLength(60)
                .IsUnicode(false);
        });

        modelBuilder.Entity<FullTimeContract>(entity =>
        {
            entity.HasKey(e => e.contract_id).HasName("PK__FullTime__F8D664231A07AF26");

            entity.ToTable("FullTimeContract");

            entity.Property(e => e.contract_id).ValueGeneratedNever();

            entity.HasOne(d => d.contract).WithOne(p => p.FullTimeContract)
                .HasForeignKey<FullTimeContract>(d => d.contract_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__FullTimeC__contr__66603565");
        });

        modelBuilder.Entity<HRAdministrator>(entity =>
        {
            entity.HasKey(e => e.employee_id).HasName("PK__HRAdmini__C52E0BA8F5BA2778");

            entity.ToTable("HRAdministrator");

            entity.Property(e => e.employee_id).ValueGeneratedNever();
            entity.Property(e => e.document_validation_rights)
                .HasMaxLength(89)
                .IsUnicode(false);
            entity.Property(e => e.record_access_scope)
                .HasMaxLength(90)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithOne(p => p.HRAdministrator)
                .HasForeignKey<HRAdministrator>(d => d.employee_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HRAdminis__emplo__46E78A0C");
        });

        modelBuilder.Entity<HolidayLeave>(entity =>
        {
            entity.HasKey(e => e.leave_id).HasName("PK__HolidayL__743350BCF1ADA871");

            entity.ToTable("HolidayLeave");

            entity.Property(e => e.leave_id).ValueGeneratedNever();
            entity.Property(e => e.holiday_name)
                .HasMaxLength(90)
                .IsUnicode(false);
            entity.Property(e => e.regional_scope)
                .HasMaxLength(89)
                .IsUnicode(false);

            entity.HasOne(d => d.leave).WithOne(p => p.HolidayLeave)
                .HasForeignKey<HolidayLeave>(d => d.leave_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HolidayLe__leave__07C12930");
        });

        modelBuilder.Entity<HourlySalaryType>(entity =>
        {
            entity.HasKey(e => e.salary_type_id).HasName("PK__HourlySa__4D64706279020944");

            entity.ToTable("HourlySalaryType");

            entity.Property(e => e.salary_type_id).ValueGeneratedNever();
            entity.Property(e => e.hourly_rate).HasColumnType("decimal(11, 3)");

            entity.HasOne(d => d.salary_type).WithOne(p => p.HourlySalaryType)
                .HasForeignKey<HourlySalaryType>(d => d.salary_type_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HourlySal__salar__498EEC8D");
        });

        modelBuilder.Entity<Insurance>(entity =>
        {
            entity.HasKey(e => e.insurance_id).HasName("PK__Insuranc__58B60F45349CE650");

            entity.ToTable("Insurance");

            entity.Property(e => e.contribution_rate).HasColumnType("decimal(6, 3)");
            entity.Property(e => e.coverage).IsUnicode(false);
            entity.Property(e => e.type)
                .HasMaxLength(80)
                .IsUnicode(false);
        });

        modelBuilder.Entity<InternshipContract>(entity =>
        {
            entity.HasKey(e => e.contract_id).HasName("PK__Internsh__F8D66423BF2AE205");

            entity.ToTable("InternshipContract");

            entity.Property(e => e.contract_id).ValueGeneratedNever();
            entity.Property(e => e.evaluation)
                .HasMaxLength(480)
                .IsUnicode(false);
            entity.Property(e => e.mentoring)
                .HasMaxLength(80)
                .IsUnicode(false);
            entity.Property(e => e.stipend_related).HasColumnType("decimal(10, 4)");

            entity.HasOne(d => d.contract).WithOne(p => p.InternshipContract)
                .HasForeignKey<InternshipContract>(d => d.contract_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Internshi__contr__6EF57B66");
        });

        modelBuilder.Entity<LatenessPolicy>(entity =>
        {
            entity.HasKey(e => e.policy_id).HasName("PK__Lateness__47DA3F035436DA5F");

            entity.ToTable("LatenessPolicy");

            entity.Property(e => e.policy_id).ValueGeneratedNever();
            entity.Property(e => e.deduction_rate).HasColumnType("decimal(6, 2)");

            entity.HasOne(d => d.policy).WithOne(p => p.LatenessPolicy)
                .HasForeignKey<LatenessPolicy>(d => d.policy_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LatenessP__polic__5BAD9CC8");
        });

        modelBuilder.Entity<Leave>(entity =>
        {
            entity.HasKey(e => e.leave_id).HasName("PK__Leave__743350BC48EBEC69");

            entity.ToTable("Leave");

            entity.Property(e => e.leave_description)
                .HasMaxLength(480)
                .IsUnicode(false);
            entity.Property(e => e.leave_type)
                .HasMaxLength(60)
                .IsUnicode(false);
        });

        modelBuilder.Entity<LeaveDocument>(entity =>
        {
            entity.HasKey(e => e.document_id).HasName("PK__LeaveDoc__9666E8ACBE51578C");

            entity.ToTable("LeaveDocument");

            entity.Property(e => e.file_path)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.uploaded_at)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.leave_request).WithMany(p => p.LeaveDocuments)
                .HasForeignKey(d => d.leave_request_id)
                .HasConstraintName("FK__LeaveDocu__leave__160F4887");
        });

        modelBuilder.Entity<LeaveEntitlement>(entity =>
        {
            entity.HasKey(e => new { e.employee_id, e.leave_type_id }).HasName("PK__LeaveEnt__92097AE5E60F1846");

            entity.ToTable("LeaveEntitlement");

            entity.Property(e => e.entitlement).HasColumnType("decimal(8, 3)");

            entity.HasOne(d => d.employee).WithMany(p => p.LeaveEntitlements)
                .HasForeignKey(d => d.employee_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LeaveEnti__emplo__114A936A");

            entity.HasOne(d => d.leave_type).WithMany(p => p.LeaveEntitlements)
                .HasForeignKey(d => d.leave_type_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LeaveEnti__leave__123EB7A3");
        });

        modelBuilder.Entity<LeavePolicy>(entity =>
        {
            entity.HasKey(e => e.policy_id).HasName("PK__LeavePol__47DA3F030637E8FA");

            entity.ToTable("LeavePolicy");

            entity.Property(e => e.eligibility_rules)
                .HasMaxLength(500)
                .IsUnicode(false);
            entity.Property(e => e.name)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.purpose)
                .HasMaxLength(500)
                .IsUnicode(false);
            entity.Property(e => e.special_leave_type)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<LeaveRequest>(entity =>
        {
            entity.HasKey(e => e.request_id).HasName("PK__LeaveReq__18D3B90F90CEC3B7");

            entity.ToTable("LeaveRequest");

            entity.Property(e => e.approval_timing).HasColumnType("datetime");
            entity.Property(e => e.justification)
                .HasMaxLength(700)
                .IsUnicode(false);
            entity.Property(e => e.status)
                .HasMaxLength(60)
                .IsUnicode(false)
                .HasDefaultValue("Pending");

            entity.HasOne(d => d.employee).WithMany(p => p.LeaveRequests)
                .HasForeignKey(d => d.employee_id)
                .HasConstraintName("FK__LeaveRequ__emplo__0D7A0286");

            entity.HasOne(d => d.leave).WithMany(p => p.LeaveRequests)
                .HasForeignKey(d => d.leave_id)
                .HasConstraintName("FK__LeaveRequ__leave__0E6E26BF");
        });

        modelBuilder.Entity<LineManager>(entity =>
        {
            entity.HasKey(e => e.employee_id).HasName("PK__LineMana__C52E0BA804C3EBF1");

            entity.ToTable("LineManager");

            entity.Property(e => e.employee_id).ValueGeneratedNever();
            entity.Property(e => e.approval_limit).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.supervised_departments)
                .HasMaxLength(200)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithOne(p => p.LineManager)
                .HasForeignKey<LineManager>(d => d.employee_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LineManag__emplo__5BE2A6F2");
        });

        modelBuilder.Entity<ManagerNote>(entity =>
        {
            entity.HasKey(e => e.note_id).HasName("PK__ManagerN__CEDD0FA422E41856");

            entity.Property(e => e.created_at)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.note_content).IsUnicode(false);

            entity.HasOne(d => d.employee).WithMany(p => p.ManagerNoteemployees)
                .HasForeignKey(d => d.employee_id)
                .HasConstraintName("FK__ManagerNo__emplo__04AFB25B");

            entity.HasOne(d => d.manager).WithMany(p => p.ManagerNotemanagers)
                .HasForeignKey(d => d.manager_id)
                .HasConstraintName("FK__ManagerNo__manag__05A3D694");
        });

        modelBuilder.Entity<Mission>(entity =>
        {
            entity.HasKey(e => e.mission_id).HasName("PK__Mission__B5419AB23DB072AC");

            entity.ToTable("Mission");

            entity.Property(e => e.destination)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.status)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithMany(p => p.Missionemployees)
                .HasForeignKey(d => d.employee_id)
                .HasConstraintName("FK__Mission__employe__71D1E811");

            entity.HasOne(d => d.manager).WithMany(p => p.Missionmanagers)
                .HasForeignKey(d => d.manager_id)
                .HasConstraintName("FK__Mission__manager__72C60C4A");
        });

        modelBuilder.Entity<MonthlySalaryType>(entity =>
        {
            entity.HasKey(e => e.salary_type_id).HasName("PK__MonthlyS__4D647062FEEA9269");

            entity.ToTable("MonthlySalaryType");

            entity.Property(e => e.salary_type_id).ValueGeneratedNever();
            entity.Property(e => e.contribution_scheme)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.tax_rule)
                .HasMaxLength(150)
                .IsUnicode(false);

            entity.HasOne(d => d.salary_type).WithOne(p => p.MonthlySalaryType)
                .HasForeignKey<MonthlySalaryType>(d => d.salary_type_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__MonthlySa__salar__4C6B5938");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => e.notification_id).HasName("PK__Notifica__E059842F6169E17B");

            entity.ToTable("Notification");

            entity.Property(e => e.message_content)
                .HasMaxLength(500)
                .IsUnicode(false);
            entity.Property(e => e.notification_type)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.read_status).HasDefaultValue(false);
            entity.Property(e => e.timestamp)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.urgency)
                .HasMaxLength(20)
                .IsUnicode(false);
        });

        modelBuilder.Entity<OvertimePolicy>(entity =>
        {
            entity.HasKey(e => e.policy_id).HasName("PK__Overtime__47DA3F039E3E5986");

            entity.ToTable("OvertimePolicy");

            entity.Property(e => e.policy_id).ValueGeneratedNever();
            entity.Property(e => e.weekday_rate_multiplier).HasColumnType("decimal(3, 2)");
            entity.Property(e => e.weekend_rate_multiplier).HasColumnType("decimal(3, 2)");

            entity.HasOne(d => d.policy).WithOne(p => p.OvertimePolicy)
                .HasForeignKey<OvertimePolicy>(d => d.policy_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__OvertimeP__polic__58D1301D");
        });

        modelBuilder.Entity<PartTimeContract>(entity =>
        {
            entity.HasKey(e => e.contract_id).HasName("PK__PartTime__F8D66423D32EAD96");

            entity.ToTable("PartTimeContract");

            entity.Property(e => e.contract_id).ValueGeneratedNever();
            entity.Property(e => e.hourly_rate).HasColumnType("decimal(10, 2)");

            entity.HasOne(d => d.contract).WithOne(p => p.PartTimeContract)
                .HasForeignKey<PartTimeContract>(d => d.contract_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__PartTimeC__contr__693CA210");
        });

        modelBuilder.Entity<PayGrade>(entity =>
        {
            entity.HasKey(e => e.pay_grade_id).HasName("PK__PayGrade__C8AD0DED288F596C");

            entity.ToTable("PayGrade");

            entity.Property(e => e.grade_name)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.max_salary).HasColumnType("decimal(11, 3)");
            entity.Property(e => e.min_salary).HasColumnType("decimal(11, 3)");
        });

        modelBuilder.Entity<Payroll>(entity =>
        {
            entity.HasKey(e => e.payroll_id).HasName("PK__Payroll__D99FC944DA7C5D9F");

            entity.ToTable("Payroll");

            entity.Property(e => e.actual_pay).HasColumnType("decimal(11, 3)");
            entity.Property(e => e.adjustments).HasColumnType("decimal(11, 3)");
            entity.Property(e => e.base_amount).HasColumnType("decimal(11, 3)");
            entity.Property(e => e.contributions).HasColumnType("decimal(11, 3)");
            entity.Property(e => e.net_salary).HasColumnType("decimal(11, 3)");
            entity.Property(e => e.taxes).HasColumnType("decimal(11, 3)");

            entity.HasOne(d => d.employee).WithMany(p => p.Payrolls)
                .HasForeignKey(d => d.employee_id)
                .HasConstraintName("FK__Payroll__employe__3E1D39E1");

            entity.HasMany(d => d.policies).WithMany(p => p.payrolls)
                .UsingEntity<Dictionary<string, object>>(
                    "PayrollPolicy_ID",
                    r => r.HasOne<PayrollPolicy>().WithMany()
                        .HasForeignKey("policy_id")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__PayrollPo__polic__65370702"),
                    l => l.HasOne<Payroll>().WithMany()
                        .HasForeignKey("payroll_id")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__PayrollPo__payro__6442E2C9"),
                    j =>
                    {
                        j.HasKey("payroll_id", "policy_id").HasName("PK__PayrollP__FDE26AB4F0958FA3");
                        j.ToTable("PayrollPolicy_ID");
                    });
        });

        modelBuilder.Entity<PayrollPeriod>(entity =>
        {
            entity.HasKey(e => e.payroll_period_id).HasName("PK__PayrollP__CD8483A200B7CF98");

            entity.ToTable("PayrollPeriod");

            entity.Property(e => e.status)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.payroll).WithMany(p => p.PayrollPeriods)
                .HasForeignKey(d => d.payroll_id)
                .HasConstraintName("FK__PayrollPe__payro__6AEFE058");
        });

        modelBuilder.Entity<PayrollPolicy>(entity =>
        {
            entity.HasKey(e => e.policy_id).HasName("PK__PayrollP__47DA3F03C6733A87");

            entity.ToTable("PayrollPolicy");

            entity.Property(e => e.description).IsUnicode(false);
            entity.Property(e => e.type)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<PayrollSpecialist>(entity =>
        {
            entity.HasKey(e => e.employee_id).HasName("PK__PayrollS__C52E0BA8934DA4E0");

            entity.ToTable("PayrollSpecialist");

            entity.Property(e => e.employee_id).ValueGeneratedNever();
            entity.Property(e => e.assigned_region)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.processing_frequency)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithOne(p => p.PayrollSpecialist)
                .HasForeignKey<PayrollSpecialist>(d => d.employee_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__PayrollSp__emplo__73852659");
        });

        modelBuilder.Entity<Payroll_Log>(entity =>
        {
            entity.HasKey(e => e.payroll_log_id).HasName("PK__Payroll___7B69DA7A14AD82DF");

            entity.ToTable("Payroll_Log");

            entity.Property(e => e.change_date).HasColumnType("datetime");
            entity.Property(e => e.modification_type)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.payroll).WithMany(p => p.Payroll_Logs)
                .HasForeignKey(d => d.payroll_id)
                .HasConstraintName("FK__Payroll_L__payro__681373AD");
        });

        modelBuilder.Entity<Position>(entity =>
        {
            entity.HasKey(e => e.position_id).HasName("PK__Position__99A0E7A4CD9B5C35");

            entity.ToTable("Position");

            entity.Property(e => e.position_title)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.responsibilities)
                .HasMaxLength(400)
                .IsUnicode(false);
            entity.Property(e => e.status)
                .HasMaxLength(30)
                .IsUnicode(false)
                .HasDefaultValue("Active");
        });

        modelBuilder.Entity<ProbationLeave>(entity =>
        {
            entity.HasKey(e => e.leave_id).HasName("PK__Probatio__743350BC18192AE6");

            entity.ToTable("ProbationLeave");

            entity.Property(e => e.leave_id).ValueGeneratedNever();

            entity.HasOne(d => d.leave).WithOne(p => p.ProbationLeave)
                .HasForeignKey<ProbationLeave>(d => d.leave_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Probation__leave__04E4BC85");
        });

        modelBuilder.Entity<Reimbursement>(entity =>
        {
            entity.HasKey(e => e.reimbursement_id).HasName("PK__Reimburs__F6C26984CC92C930");

            entity.ToTable("Reimbursement");

            entity.Property(e => e.claim_type)
                .HasMaxLength(80)
                .IsUnicode(false);
            entity.Property(e => e.current_status)
                .HasMaxLength(80)
                .IsUnicode(false);
            entity.Property(e => e.type)
                .HasMaxLength(80)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithMany(p => p.Reimbursements)
                .HasForeignKey(d => d.employee_id)
                .HasConstraintName("FK__Reimburse__emplo__75A278F5");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.role_id).HasName("PK__Role__760965CC53178580");

            entity.ToTable("Role");

            entity.Property(e => e.purpose)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.role_name)
                .HasMaxLength(60)
                .IsUnicode(false);
        });

        modelBuilder.Entity<RolePermission>(entity =>
        {
            entity.HasKey(e => new { e.role_id, e.permission_name }).HasName("PK__RolePerm__5E156A965112DE16");

            entity.ToTable("RolePermission");

            entity.Property(e => e.permission_name)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.allowed_action)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.role).WithMany(p => p.RolePermissions)
                .HasForeignKey(d => d.role_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__RolePermi__role___4E88ABD4");
        });

        modelBuilder.Entity<SalaryType>(entity =>
        {
            entity.HasKey(e => e.salary_type_id).HasName("PK__SalaryTy__4D6470622B288134");

            entity.ToTable("SalaryType");

            entity.Property(e => e.currency)
                .HasMaxLength(65)
                .IsUnicode(false);
            entity.Property(e => e.payment_frequency)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.type)
                .HasMaxLength(40)
                .IsUnicode(false);

            entity.HasOne(d => d.currencyNavigation).WithMany(p => p.SalaryTypes)
                .HasPrincipalKey(p => p.CurrencyName)
                .HasForeignKey(d => d.currency)
                .HasConstraintName("FK__SalaryTyp__curre__45BE5BA9");
        });

        modelBuilder.Entity<ShiftAssignment>(entity =>
        {
            entity.HasKey(e => e.assignment_id).HasName("PK__ShiftAss__DA89181473AC7195");

            entity.ToTable("ShiftAssignment");

            entity.Property(e => e.status)
                .HasMaxLength(60)
                .IsUnicode(false);

            entity.HasOne(d => d.employee).WithMany(p => p.ShiftAssignments)
                .HasForeignKey(d => d.employee_id)
                .HasConstraintName("FK__ShiftAssi__emplo__1BC821DD");

            entity.HasOne(d => d.shift).WithMany(p => p.ShiftAssignments)
                .HasForeignKey(d => d.shift_id)
                .HasConstraintName("FK__ShiftAssi__shift__1CBC4616");
        });

        modelBuilder.Entity<ShiftCycle>(entity =>
        {
            entity.HasKey(e => e.cycle_id).HasName("PK__ShiftCyc__5D955881184E1BD0");

            entity.ToTable("ShiftCycle");

            entity.Property(e => e.cycle_name)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.description)
                .HasMaxLength(500)
                .IsUnicode(false);
        });

        modelBuilder.Entity<ShiftCycleAssignment>(entity =>
        {
            entity.HasKey(e => new { e.cycle_id, e.shift_id }).HasName("PK__ShiftCyc__4A273FA31266DA65");

            entity.ToTable("ShiftCycleAssignment");

            entity.HasOne(d => d.cycle).WithMany(p => p.ShiftCycleAssignments)
                .HasForeignKey(d => d.cycle_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ShiftCycl__cycle__3A4CA8FD");

            entity.HasOne(d => d.shift).WithMany(p => p.ShiftCycleAssignments)
                .HasForeignKey(d => d.shift_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ShiftCycl__shift__3B40CD36");
        });

        modelBuilder.Entity<ShiftSchedule>(entity =>
        {
            entity.HasKey(e => e.shift_id).HasName("PK__ShiftSch__7B267220C798A0FA");

            entity.ToTable("ShiftSchedule");

            entity.Property(e => e.allowance_amount)
                .HasDefaultValue(0m)
                .HasColumnType("decimal(10, 2)");
            entity.Property(e => e.location)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.name)
                .HasMaxLength(60)
                .IsUnicode(false);
            entity.Property(e => e.status)
                .HasMaxLength(80)
                .IsUnicode(false);
            entity.Property(e => e.type)
                .HasMaxLength(60)
                .IsUnicode(false);
        });

        modelBuilder.Entity<SickLeave>(entity =>
        {
            entity.HasKey(e => e.leave_id).HasName("PK__SickLeav__743350BCF1EAFA69");

            entity.ToTable("SickLeave");

            entity.Property(e => e.leave_id).ValueGeneratedNever();

            entity.HasOne(d => d.leave).WithOne(p => p.SickLeave)
                .HasForeignKey<SickLeave>(d => d.leave_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SickLeave__leave__02084FDA");
        });

        modelBuilder.Entity<Skill>(entity =>
        {
            entity.HasKey(e => e.skill_id).HasName("PK__Skill__FBBA8379F0FA8A7B");

            entity.ToTable("Skill");

            entity.Property(e => e.description)
                .HasMaxLength(500)
                .IsUnicode(false);
            entity.Property(e => e.skill_name)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<SystemAdministrator>(entity =>
        {
            entity.HasKey(e => e.employee_id).HasName("PK__SystemAd__C52E0BA8336A4D6B");

            entity.ToTable("SystemAdministrator");

            entity.Property(e => e.employee_id).ValueGeneratedNever();
            entity.Property(e => e.audit_visibility_scope)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.configurable_fields).IsUnicode(false);

            entity.HasOne(d => d.employee).WithOne(p => p.SystemAdministrator)
                .HasForeignKey<SystemAdministrator>(d => d.employee_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SystemAdm__emplo__49C3F6B7");
        });

        modelBuilder.Entity<TaxForm>(entity =>
        {
            entity.HasKey(e => e.tax_form_id).HasName("PK__TaxForm__3184195A36DF6079");

            entity.ToTable("TaxForm");

            entity.Property(e => e.form_content).IsUnicode(false);
            entity.Property(e => e.jurisdiction)
                .HasMaxLength(150)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Termination>(entity =>
        {
            entity.HasKey(e => e.termination_id).HasName("PK__Terminat__B66BAA111FBEFA9C");

            entity.ToTable("Termination");

            entity.Property(e => e.reason)
                .HasMaxLength(500)
                .IsUnicode(false);

            entity.HasOne(d => d.contract).WithMany(p => p.Terminations)
                .HasForeignKey(d => d.contract_id)
                .HasConstraintName("FK__Terminati__contr__7A672E12");
        });

        modelBuilder.Entity<VacationLeave>(entity =>
        {
            entity.HasKey(e => e.leave_id).HasName("PK__Vacation__743350BCDF423CD3");

            entity.ToTable("VacationLeave");

            entity.Property(e => e.leave_id).ValueGeneratedNever();

            entity.HasOne(d => d.leave).WithOne(p => p.VacationLeave)
                .HasForeignKey<VacationLeave>(d => d.leave_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__VacationL__leave__7F2BE32F");
        });

        modelBuilder.Entity<Verification>(entity =>
        {
            entity.HasKey(e => e.verification_id).HasName("PK__Verifica__24F17969D5FED87E");

            entity.ToTable("Verification");

            entity.Property(e => e.issuer)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.verification_type)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
