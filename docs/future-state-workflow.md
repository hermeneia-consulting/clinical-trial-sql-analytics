# Future-State Workflow Design

## Purpose

This document defines a proposed future-state workflow for the clinical trial recruitment and medical-record retrieval process based on the operational gaps identified in the current-state assessment.

The proposed design centralizes workflow data while providing stage-specific operational queues for the teams responsible for patient intake, ROI authorization, medical-record retrieval, and CRC handoff.

## 1. Centralized Workflow Model

The future-state design uses a centralized data model as the system of record for patient progression through the recruitment pipeline.

Rather than maintaining separate trackers for each operational stage, workflow status, ownership, and activity are connected through a common underlying data structure.

Operational teams interact with the centralized workflow through stage-specific queues. Each queue surfaces the patients and actions relevant to that stage while preserving visibility into the patient's progression across the complete recruitment process.

The proposed workflow includes four primary operational queues:

- Intake
- ROI Authorization
- Medical Record Retrieval
- CRC Handoff

## 2. Queue-Based Workspaces

Each operational role accesses a workspace containing multiple status-based queues.

Queues automatically filter assigned patients according to workflow stage, status, due dates, and required actions. Staff retain discretion over how to prioritize their workload, while the system provides a consistent structure for identifying new, pending, overdue, and completed work.

## 3. Intake Queue

New patient referrals enter a centralized intake queue through either automated ingestion from compatible vendor systems or standardized manual entry when system integration is unavailable.

Referrals are assigned according to the clinical trial site and routed to the intake specialist responsible for that site's workload.

Rather than requiring staff to search for individual patients, the intake queue provides an assigned view of patients requiring action. New referrals are surfaced based on workflow status, allowing intake specialists to identify patients awaiting screening.

After screening, the intake specialist records the eligibility outcome in the centralized system.

Patients who do not meet the inclusion and exclusion criteria exit the active recruitment workflow. Patients who pass the initial screening transition automatically to the ROI Authorization Queue.

## 4. ROI Authorization Queue

Patients who pass initial eligibility screening automatically transition into the ROI Authorization workspace.

The workspace organizes assigned patients into status-based queues that may include:

- New — patients requiring ROI preparation and initial outreach
- Awaiting Signature — ROI sent but not yet returned
- Follow-Up Due — patients requiring another contact attempt
- Final Attempt — patients approaching the maximum number of follow-up attempts
- Signed — completed authorizations ready to transition to medical-record retrieval
- Lost — patients who did not complete authorization after the defined follow-up process

Follow-up queues are generated from workflow dates and business rules rather than relying on individually maintained spreadsheet formulas or reminders.

When an ROI is signed, the patient's workflow status is updated and the case becomes available to the Medical Record Retrieval workspace.

## 5. Medical Record Retrieval Queue

Patients with completed ROI authorizations transition into the Medical Record Retrieval workspace.

The workspace organizes assigned record requests into status-based queues that may include:

- New — patients requiring initiation of a medical-record request
- Pending — requests submitted and awaiting records
- Follow-Up Due — requests that have reached an expected follow-up point
- Overdue — requests exceeding expected facility turnaround
- Records Received — requests for which records have been obtained
- Secondary Review — patients whose records are ready for eligibility review

Facility information is maintained as reusable system data rather than in individually maintained reference trackers. This may include contact information, request submission methods, and other operational information required to initiate and manage requests.

Historical request data can also be used to evaluate facility turnaround behavior. Rather than applying the same follow-up interval to every request, the system can compare the age of an outstanding request against historical facility performance to help identify requests that warrant follow-up.

Staff retain responsibility for determining the appropriate operational action, while the system surfaces requests requiring attention based on available workflow and facility data.

After records are received and reviewed against the trial's inclusion and exclusion criteria, patients who remain eligible transition to the CRC workspace. Patients who do not meet the criteria exit the active recruitment workflow.

## 5. Medical Record Retrieval Queue

Patients with completed ROI authorizations transition into the Medical Record Retrieval workspace.

The workspace organizes assigned record requests into status-based queues that may include:

- New — patients requiring initiation of a medical-record request
- Pending — requests submitted and awaiting records
- Follow-Up Due — requests that have reached an expected follow-up point
- Overdue — requests exceeding expected facility turnaround
- Records Received — requests for which records have been obtained
- Secondary Review — patients whose records are ready for eligibility review

Facility information is maintained as reusable system data rather than in individually maintained reference trackers. This may include contact information, request submission methods, and other operational information required to initiate and manage requests.

Historical request data can also be used to evaluate facility turnaround behavior. Rather than applying the same follow-up interval to every request, the system can compare the age of an outstanding request against historical facility performance to help identify requests that warrant follow-up.

Staff retain responsibility for determining the appropriate operational action, while the system surfaces requests requiring attention based on available workflow and facility data.

After records are received and reviewed against the trial's inclusion and exclusion criteria, patients who remain eligible transition to the CRC workspace. Patients who do not meet the criteria exit the active recruitment workflow.

## 7. External System Integration and Manual Intake

The future-state workflow is designed to support multiple referral intake methods because external vendor systems may differ in their integration capabilities.

Where compatible APIs, file exports, or other integration methods are available, referral data can be ingested into the centralized system automatically or through scheduled imports.

When integration is not available, intake staff can enter referrals manually through a standardized intake process.

Regardless of intake method, new referrals are validated, assigned to the appropriate site and operational owner, and entered into the centralized workflow before appearing in the Intake workspace.

This approach reduces dependence on any single vendor technology while preserving a consistent internal workflow.

### Planned Technical Implementation

A future Python-based ingestion layer may be used to:

- read structured referral files such as CSV or Excel exports
- validate required patient, vendor, and site data
- identify duplicate or existing records
- transform external data into the internal data model
- insert or update records in the central database
- log ingestion errors for review
- route successfully processed referrals into the appropriate operational queue

External integrations such as vendor APIs or electronic-signature platforms may be added where supported, while manual workflow steps remain standardized when automation is not available.

## 8. KPI Visibility and Operational Dashboards

The centralized data model also supports an analytical layer for monitoring workflow performance across the recruitment pipeline.

Operational dashboards provide visibility into key performance indicators without requiring staff or leadership to manually consolidate information from separate trackers and systems.

Dashboard views may include:

- patient volume by workflow stage
- recruitment and ROI conversion rates
- patients currently pending by stage
- average time between major workflow transitions
- outstanding ROI follow-ups
- medical-record request turnaround time
- facility-level retrieval performance
- overdue record requests
- patient loss points across the recruitment pipeline
- workload distribution across sites or operational queues

Because operational queues and dashboards are supported by the same centralized data model, workflow activity can contribute directly to performance reporting and historical analysis.

The analytical layer supports both real-time operational visibility and longer-term identification of workflow bottlenecks, facility behavior, and process-improvement opportunities.

## 9. Future-State Design Principles

The proposed workflow is guided by the following principles:

- one centralized source of workflow data
- role-based workspaces with status-driven queues
- automatic workflow transitions where business rules support them
- standardized manual processes where system integration is unavailable
- reusable facility and operational knowledge
- reduced dependence on email for workflow handoffs
- historical data used to support operational prioritization
- human review retained for clinical and operational decisions
- operational and analytical views supported by the same centralized data model