# Business Rules

## Purpose

This document defines the operational rules that govern patient movement through the future-state clinical trial recruitment workflow.

These rules translate workflow decisions into consistent system behavior, queue assignment, status changes, follow-up requirements, and escalation logic.

## 1. Intake Rules

### New Referral

A referral is classified as `New` when it enters the recruitment pipeline from a vendor. The referral date establishes when the patient entered the workflow.

### In Progress

A referral transitions to `In Progress` when the first patient contact attempt is documented.

### Ineligible / Closed

A patient exits the active intake workflow when the initial screening does not support progression to the next stage.

The system should capture a disposition reason because patients may exit the workflow for different reasons, including:

- inclusion criteria not met
- exclusion criteria met
- patient unwilling to participate
- other documented disposition reason

### Ready for ROI

A patient transitions to the ROI Authorization stage after the initial inclusion criteria are met and the patient agrees to proceed with the recruitment process.

### Site Assignment

Site assignment is known when the referral enters the pipeline. Vendors route patients according to geographic proximity to participating clinical trial sites.

### Intake Ownership

Each clinical trial site has an assigned intake specialist.

When a new referral enters the centralized system, the patient is automatically routed to the workspace of the intake specialist assigned to that site.

The referral appears in the specialist's `New` queue until the first patient contact attempt is documented.

## 2. ROI Authorization Rules

### New ROI

A patient enters the ROI Authorization workflow after passing the initial eligibility screening and agreeing to proceed.

The patient initially appears in the `New` queue until the ROI is prepared and sent for signature.

### Awaiting Signature

Once the ROI is sent, the patient transitions to `Awaiting Signature`.

The ROI sent date establishes the starting point for follow-up timing.

### Follow-Up Due

If the ROI remains unsigned, a follow-up reminder and action are triggered every 48 hours.

After each follow-up attempt is documented, the 48-hour interval resets for the next required action.

### Lost to Follow-Up

A maximum of three follow-up attempts are made after the initial ROI is sent.

If the ROI remains unsigned after the third follow-up attempt, the patient is classified as `Lost to Follow-Up` and exits the active recruitment workflow.

### ROI Signed

When the signed ROI is received, the authorization workflow is complete.

The patient's status changes to `ROI Signed`, removing the patient from outstanding ROI queues and transitioning the patient into the Medical Record Retrieval workflow.

## 3. Medical Record Retrieval Rules

### New Record Request

A patient enters the Medical Record Retrieval workflow after the ROI has been signed.

A separate record request is created for each healthcare facility from which records are required.

### Pending Request

Once a request is submitted, it remains in `Pending` status until records are received or additional action is required.

### Follow-Up Prioritization

Follow-up timing should be informed by historical facility turnaround behavior rather than applying the same follow-up interval to every request.

Reliable historical data is required before facility-specific follow-up expectations can be used operationally.

Until sufficient historical data is available, requests may follow a standardized baseline follow-up schedule.

As facility-level performance data becomes more consistent, the system can compare the age of an outstanding request against expected turnaround patterns to help prioritize follow-up activity.

### Overdue Requests

A request may be classified as `Overdue` when it exceeds the expected turnaround threshold defined for the facility or the current standardized baseline.

Overdue status is intended to support prioritization and does not replace staff judgment.

### Records Received

When records are received, the request is marked complete.

A patient moves to secondary eligibility review only after all required record requests have been completed.

### Secondary Eligibility Review

Retrieved records are reviewed against the trial's inclusion and exclusion criteria.

Patients who remain eligible transition to the CRC Handoff workflow.

Patients who do not meet the criteria exit the active recruitment workflow with a documented disposition reason.

## 4. CRC Handoff Rules

### Ready for CRC

A patient transitions to the CRC Handoff workflow after all required medical records have been received and the secondary eligibility review supports continued progression.

The patient automatically appears in the CRC `New Handoffs` queue.

### CRC Review

The CRC updates the patient's workflow status as the case is reviewed.

If additional information or operational work is required, the patient may be returned to the appropriate preceding workflow stage with a documented reason.

### Handoff Complete

When the CRC accepts the patient for the next stage of trial activity, the operational handoff is marked complete.

This status represents the end of the workflow modeled in this case study.

## 5. Human Decision-Making and Automation

System automation supports workflow routing, queue assignment, reminders, status visibility, and operational prioritization.

Clinical eligibility decisions remain human decisions. The system may surface information and trigger workflow actions based on documented outcomes, but it does not independently determine whether a patient meets clinical inclusion or exclusion criteria.

