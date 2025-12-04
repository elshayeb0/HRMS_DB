# HR Management System Database

A complete SQL implementation of the HRMS system designed and now extended with:

- Full relational schema (DDL)
- Sample data covering all user story scenarios (DML)
- Stored procedures & functions for all Milestone 2 User Stories
- Testing scripts for validation

This repository provides a **clean, modular structure** so each team member can contribute without conflicts.

---

## 🚀 How to Run the Project

1. Open the folder in **VS Code**
2. Ensure SQL Server extension is installed
3. Run the scripts in order:

	1.	db/combined/drop_create.sql
	2.	db/combined/01_full_schema.sql
	3.	db/combined/02_full_data.sql
	4.	db/combined/03_full_procedures.sql

---

## 🧩 Contribution Workflow
### Make your changes ONLY in your assigned files

Every teammate must:
git pull
git add .
git commit -m "Meaningful Message"
git push

Each role owns a single file inside `db/procedures/`:

- System Admin → `01_system_admin.sql`
- HR Admin → `02_hr_admin.sql`
- Payroll Officer → `03_payroll_officer.sql`
- Line Manager → `04_line_manager.sql`
- Employee → `05_employee.sql`

---

## 👥 Team Info

- Ziad Elshayeb
- Ahmed Saadallah
- Hazem Ahmed
- Yassin Zaki


---
