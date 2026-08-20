# A Workflow and Data Analysis of Clinical Trial Recruitment Efficiency 
> Based on real clinical research operations experience managing a two-phase patient recruitment tracking system across 15-20 clinical trial sites.

---

# README Update — Project Evolution & Roadmap

## Project Evolution

The project began as a small PostgreSQL prototype using 10 synthetic patients to test a two-phase clinical trial recruitment workflow and explore initial operational questions using a relational database.

It has since been migrated to MySQL and expanded to a **250-patient synthetic dataset** to support more realistic relational analysis and deeper investigation of clinical operations patterns.

As I continued working with the dataset, new operational questions emerged around workflow design, standard operating procedures, data visibility, automation, and the relationships between systems supporting the process.

The original seven analyses documented below represent the first analytical phase of the project. The project is now evolving beyond retrospective SQL analysis toward a broader operational case study focused on workflow design, centralized data visibility, process standardization, and future automation opportunities.

---

## Data Source

This project was built from direct clinical operations experience managing a two-phase patient recruitment and medical-record retrieval workflow across 15–20 clinical trial sites.

The dataset is fully synthetic, but the workflow structure, business questions, and data model were informed by operational patterns observed firsthand while working as a Health Information Specialist.

Domain knowledge shaped the model design, terminology, workflow stages, and analytical questions.

---

## Database Design

The patient workflow includes three operational stages:

- **Phase 1** – Recruitment and signed ROI
- **Phase 2** – Medical record retrieval
- **Phase 3** – Handoff to the site coordinator for continued trial evaluation

I was directly responsible for Phases 1 and 2. These stages required separate tracking because they involved different owners, statuses, dates, and operational actions.

Separating them in the data model improves data integrity and makes it easier to analyze where patients are moving smoothly through the workflow and where delays or handoff gaps occur.

---
## Tools

- MySQL
- MySQL Workbench
- Git
- GitHub

---

## Project Plan

The next stages of the project will extend it beyond retrospective data analysis into a broader operational workflow case study.

Planned development includes:

- current-state and future-state workflow analysis
- standardized operating procedures and business rules
- centralized data visibility across recruitment and medical-record retrieval stages
- dashboard development for KPI and workflow monitoring
- exploration of Excel-to-database ingestion
- automation of follow-up, escalation, and status-based actions

---

## Phase 2 — Workflow Assessment & Process Design

The initial SQL analysis identified broader operational questions about how patient information moved across recruitment, ROI authorization, medical-record retrieval, and site handoff.

Phase 2 expands the project from retrospective analysis into workflow and process design. The goal is to evaluate the current-state workflow, identify gaps in data visibility and handoffs, and design a more centralized and standardized future-state process.

---

### Phase 2 Deliverables

- Current-state workflow assessment
- Process gaps and operational risks
- Future-state workflow design
- Standard operating procedure (SOP)
- Data dictionary and business rules
- Database design revisions
- Excel-to-database ingestion prototype
- Opportunities for workflow automation
---

## Live Database
[View the full schema and queries on DB Fiddle](https://www.db-fiddle.com/f/uvEDcwCorkGpLRbBMJjrFN/0)
