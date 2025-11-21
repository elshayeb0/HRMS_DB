# HRMS_DB – Milestone 2 (Databases Course – GIU)

A complete SQL implementation of the HRMS system designed in **Milestone 1**, now extended with:

- Full relational schema (DDL)
- Sample data covering all user story scenarios (DML)
- Stored procedures & functions for all Milestone 2 User Stories
- Testing scripts for validation

This repository provides a **clean, modular structure** so each team member can contribute without conflicts.

---

## 📁 Project Structure

HRMS_DB/
│── docs/                         # Milestone documents
│── db/
│    ├── 00_create_database.sql   # Creates HRMS_DB and sets context
│    ├── schema/                  # All CREATE TABLE statements
│    ├── data/                    # All INSERT statements
│    ├── procedures/              # All stored procedures grouped by role
│    ├── combined/                # Final submission scripts (schema/data/procedures)
│    └── tests/                   # End-to-end and smoke testing scripts
│── deliverables/                 # Final files for submission
│── .vscode/                      # Shared formatting + SQL execution settings
│── README.md                     # Project documentation
│── .gitignore                    # Clean git workflow

---

## 🚀 How to Run the Project

1. Open the folder in **VS Code**
2. Ensure SQL Server extension is installed
3. Run the scripts in order:

	1.	db/00_create_database.sql
	2.	db/schema/* (in numeric order)
	3.	db/data/* (in numeric order)
	4.	db/procedures/* (in numeric order)
	5.	db/tests/* (to validate)

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

## 📝 Submission Format

Milestone 2 requires exactly **3 SQL files**:

1. Schema (`Losers_MS2_schema.sql`)
2. Data (`Losers_MS2_data.sql`)
3. Procedures (`Losers_MS2_procedures.sql`)

These are generated inside:
db/combined/
Then copied to:
deliverables/

---

## 👥 Team Info

### - Losers
### - Ziad Elshayeb - Ahmed Saadallah - Hazem Ahmed - Ahmed Dakroury - Yassin Zaki
### - GIU ID In Order Above: 16002080 - 16008325 - 16005924 - 16004521 - 16005309
### - Tutorial Number In Order Above: T19 - T18 - T18 - T18 - T19

---