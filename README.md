# Hotel Management Database

A portfolio-ready SQL Server database project designed to model and manage end-to-end hotel operations, from reservations through invoicing.

## Project Overview
The **Hotel Management Database** provides a structured relational foundation for hotel administration. It is organized to support transactional consistency, reporting readiness, and maintainable database engineering practices.

## Objectives
- Model core hotel operations in a normalized SQL Server schema.
- Enforce reliable business rules through constraints, procedures, and triggers.
- Support analytical visibility with reusable views and reporting-ready structures.
- Demonstrate professional database project organization for real-world team workflows.

## Database Entities
- Hotels
- Room Types
- Rooms
- Guests
- Reservations
- Check-In
- Check-Out
- Services
- Service Consumption
- Invoices

## Business Rules
Key business rules for this project are documented in:
- `/docs/BusinessRules.md`

Typical rule domains include:
- Reservation date validation and lifecycle integrity.
- Room availability and occupancy control.
- Service charge tracking and invoice consistency.

## Technologies Used
- **SQL Server (T-SQL)** for schema, procedures, triggers, and security.
- **Git & GitHub** for source control and collaboration.
- **Power BI (planned integration)** for analytics and dashboards.

## Repository Structure
```text
hotel-reservation-system-sqlserver/
├── database/
│   ├── 01_create_database.sql
│   ├── 02_tables.sql
│   ├── 03_relationships.sql
│   ├── 04_views.sql
│   ├── 05_procedures.sql
│   ├── 06_triggers.sql
│   ├── 07_indexes.sql
│   ├── 08_security.sql
│   └── 09_sample_data.sql
├── backups/
│   ├── full_backup.sql
│   ├── differential_backup.sql
│   ├── transaction_log_backup.sql
│   └── restore_database.sql
├── docs/
│   ├── DataDictionary.md
│   ├── BusinessRules.md
│   └── TechnicalDocumentation.md
├── powerbi/
└── images/
```

## Features
- Modular, execution-ordered SQL script architecture.
- Dedicated backup and recovery script area.
- Separate business and technical documentation for maintainability.
- Reporting-ready folder structure for BI and visual assets.

## Installation Instructions
1. Clone the repository.
2. Open the SQL scripts in SQL Server Management Studio (SSMS) or Azure Data Studio.
3. Execute files in `/database` in numeric order (`01` to `09`).
4. Configure and execute scripts under `/backups` according to your environment paths.
5. Review `/docs` for design intent and implementation notes.

## Future Improvements
- Implement complete DDL/DML definitions in each placeholder SQL script.
- Add automated migration/deployment pipeline.
- Expand auditing, role-based access, and compliance controls.
- Publish Power BI dashboards connected to the finalized schema.

## Author
**Yamil Millán**

---
This repository is structured as a professional database engineering portfolio project.
