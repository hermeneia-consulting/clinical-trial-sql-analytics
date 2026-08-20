CREATE DATABASE clinical_trial_tracking;
USE clinical_trial_tracking;
CREATE TABLE vendors (
  vendor_id INT AUTO_INCREMENT PRIMARY KEY,
  vendor_name VARCHAR(100),
  id_format VARCHAR(50)
);

CREATE TABLE sites (
  site_id INT AUTO_INCREMENT PRIMARY KEY,
  site_name VARCHAR(100),
  location VARCHAR(100),
  coordinator_name VARCHAR(100)
);

CREATE TABLE facilities (
  facility_id INT AUTO_INCREMENT PRIMARY KEY,
  facility_name VARCHAR(100),
  location VARCHAR(100),
  contact_info VARCHAR(100)
);

CREATE TABLE patients (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  vendor_patient_id VARCHAR(50),
  vendor_id INT,
  site_id INT,
  FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
  FOREIGN KEY (site_id) REFERENCES sites(site_id)
);

CREATE TABLE recruitment_tracking (
  recruitment_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT,
  first_contact_date DATE,
  roi_sent_date DATE,
  followup_1_date DATE,
  followup_2_date DATE,
  followup_3_date DATE,
  roi_signed_date DATE,
  status VARCHAR(50),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE record_requests (
  request_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT,
  facility_id INT,
  roi_sent_date DATE,
  followup_1_date DATE,
  followup_2_date DATE,
  records_received_date DATE,
  status VARCHAR(50),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (facility_id) REFERENCES facilities(facility_id)
);
-- Insert vendors
INSERT INTO vendors (vendor_name, id_format) VALUES
('MedRecruit', 'numeric'),
('ClinSource', 'alphanumeric');

-- Insert clinical sites
INSERT INTO sites (site_name, location, coordinator_name) VALUES
('Houston Medical Center', 'Houston, TX', 'Ana Rivera'),
('Dallas Research Institute', 'Dallas, TX', 'James Patel'),
('Austin Clinical Partners', 'Austin, TX', 'Maria Lopez'),
('San Antonio Health Group', 'San Antonio, TX', 'David Kim'),
('Memorial Research Site', 'Houston, TX', 'Sarah Chen');

-- Insert facilities
INSERT INTO facilities (facility_name, location, contact_info) VALUES
('St. Luke Hospital', 'Houston, TX', 'records@stluke.com'),
('Texas General Hospital', 'Dallas, TX', 'medrecords@txgeneral.com'),
('Austin Regional Clinic', 'Austin, TX', 'roi@austinclinic.com'),
('Methodist Hospital', 'San Antonio, TX', 'records@methodist.com'),
('Memorial Hermann', 'Houston, TX', 'roi@memorialhermann.com');

-- Insert patients
INSERT INTO patients (vendor_patient_id, vendor_id, site_id) VALUES
('10001', 1, 1),
('10002', 1, 1),
('10003', 1, 2),
('AB-204', 2, 2),
('AB-205', 2, 3),
('AB-206', 2, 3),
('10007', 1, 4),
('AB-208', 2, 4),
('10009', 1, 5),
('AB-210', 2, 5);

-- Insert recruitment tracking
INSERT INTO recruitment_tracking
(patient_id, first_contact_date, roi_sent_date, followup_1_date, followup_2_date, roi_signed_date, status) VALUES
(1, '2023-01-05', '2023-01-10', '2023-01-17', NULL, '2023-01-20', 'roi signed'),
(2, '2023-01-06', '2023-01-11', '2023-01-18', '2023-01-25', NULL, 'lost'),
(3, '2023-01-08', '2023-01-13', '2023-01-20', NULL, '2023-01-28', 'roi signed'),
(4, '2023-01-09', '2023-01-14', '2023-01-21', '2023-01-28', '2023-02-01', 'roi signed'),
(5, '2023-01-10', '2023-01-15', '2023-01-22', NULL, NULL, 'pending'),
(6, '2023-01-11', '2023-01-16', '2023-01-23', '2023-01-30', '2023-02-05', 'roi signed'),
(7, '2023-01-12', '2023-01-17', '2023-01-24', NULL, '2023-02-01', 'roi signed'),
(8, '2023-01-13', '2023-01-18', '2023-01-25', '2023-02-01', NULL, 'lost'),
(9, '2023-01-14', '2023-01-19', '2023-01-26', NULL, '2023-02-03', 'roi signed'),
(10, '2023-01-15', '2023-01-20', '2023-01-27', NULL, '2023-02-06', 'roi signed');

-- Insert record requests
INSERT INTO record_requests
(patient_id, facility_id, roi_sent_date, followup_1_date, followup_2_date, records_received_date, status) VALUES
(1, 1, '2023-01-22', '2023-01-29', NULL, '2023-02-05', 'received'),
(3, 2, '2023-01-30', '2023-02-06', '2023-02-13', '2023-03-01', 'received'),
(4, 3, '2023-02-03', '2023-02-10', NULL, '2023-02-20', 'received'),
(6, 1, '2023-02-07', '2023-02-14', '2023-02-21', '2023-03-10', 'received'),
(7, 4, '2023-02-03', '2023-02-10', NULL, '2023-02-18', 'received'),
(9, 5, '2023-02-05', '2023-02-12', NULL, '2023-02-19', 'received'),
(10, 2, '2023-02-08', '2023-02-15', '2023-02-22', NULL, 'pending');

SELECT * FROM vendors;
SELECT * FROM sites;
SELECT * FROM facilities;
SELECT * FROM patients;
SELECT * FROM recruitment_tracking;
SELECT * FROM record_requests;

/*
============================================================
                    QUERIES BEGIN HERE
============================================================
*/

/*
Q1 — Patients by vendor

Goal:
Count how many patients belong to each vendor.

Logic:
- vendors is connected to patients through vendor_id.
- JOIN keeps patients that have a matching vendor.
- COUNT(patient_id) counts the patients in each vendor group.
- GROUP BY vendor_name creates one result row per vendor.

Key concept:
Basic JOIN + COUNT + GROUP BY.
*/
SELECT v.vendor_name, 
	COUNT(p.patient_id) AS total_patients
FROM vendors v
	JOIN patients p 
    ON p.vendor_id = v.vendor_id
GROUP BY v.vendor_name;

/*
Q2 — Patients by site

Goal:
Count how many patients belong to each site.

Logic:
- patients contains site_id.
- LEFT JOIN connects each patient to the corresponding site.
- COUNT(patient_id) counts patients within each site group.
- GROUP BY site_name produces one result row per site.

Key concept:
Using a JOIN relationship to aggregate by another table's attribute.
*/

SELECT s.site_name, 
	COUNT(p.patient_id) AS total_patients
FROM patients p
	LEFT JOIN sites s 
    ON s.site_id = p.site_id
GROUP BY s.site_name;

/*
Q3 — Patients by recruitment status

Goal:
Count patients in each recruitment status.

Logic:
- No JOIN is necessary because both patient_id and status
  already exist in recruitment_tracking.
- GROUP BY status creates groups such as pending,
  lost, and roi signed.
- COUNT(patient_id) counts the rows within each status.

Key concept:
Do not JOIN tables unless the question requires data
from another table.
*/

SELECT rt.status, 
	(rt.patient_id) AS number_of_patients
FROM recruitment_tracking rt
GROUP BY rt.status;

/*
Q4 — Patients with signed ROI

Goal:
Show patients who have signed an ROI along with
their vendor, site, and ROI signed date.

Logic:
- recruitment_tracking tells us whether roi_signed_date exists.
- patients connects recruitment data to vendor_id and site_id.
- vendors supplies vendor_name.
- sites supplies site_name.
- WHERE roi_signed_date IS NOT NULL keeps only patients
  with an actual ROI signing date.

Key concept:
IS NOT NULL tests whether an event/date actually exists.
*/

SELECT p.patient_id, v.vendor_name, s.site_name, rt.roi_signed_date
FROM recruitment_tracking rt
	JOIN patients p 
	ON p.patient_id = rt.patient_id
	JOIN vendors v 
    ON v.vendor_id = p.vendor_id
    JOIN sites s 
    ON s.site_id = p.site_id
WHERE roi_signed_date IS NOT NULL;

/*
Q5 — Patients without signed ROI

Goal:
Show patients who do not have an ROI signed date.

Logic:
- Same JOIN path as the previous query.
- WHERE roi_signed_date IS NULL keeps patients
  whose ROI signing date is missing.

Key concept:
NULL means the value/event is absent.
Use IS NULL rather than = NULL.
*/

SELECT p.patient_id, v.vendor_name, s.site_name, rt.roi_signed_date, rt.status
FROM recruitment_tracking rt
	JOIN patients p 
	ON p.patient_id = rt.patient_id
	JOIN vendors v 
	ON v.vendor_id = p.vendor_id
	JOIN sites s 
	ON s.site_id = p.site_id
WHERE roi_signed_date IS NULL;

/*
Q6 — ROI signing percentage by vendor

Goal:
For each vendor, compare total patients with patients
whose recruitment status is 'roi signed' and calculate
the signed percentage.

Logic:
- COUNT(patient_id) gives the denominator.
- CASE WHEN identifies only rows meeting the ROI condition.
- COUNT(CASE WHEN ... THEN 1 END) counts qualifying rows.
- Multiply by 100.0 before dividing to produce a percentage.
- ROUND(..., 1) displays one decimal place.

Important later lesson:
JOINs can multiply rows when a patient has multiple
record_requests. This query was written before I understood
grain and JOIN multiplication, so its counts may be inflated
when used against one-to-many data.

Key concept:
Conditional aggregation + percentage calculation.
*/

SELECT v.vendor_name,
	COUNT(p.patient_id) AS total_patients,
	COUNT(CASE WHEN rt.status = 'roi signed' THEN 1 END) AS roi_signed,
	ROUND(
		COUNT(CASE WHEN rt.status = 'roi signed' THEN 1 END) * 100.0
           / COUNT(p.patient_id),
           1
       ) AS roi_signed_percentage
FROM vendors v
	JOIN patients p 
    ON p.vendor_id = v.vendor_id
	JOIN recruitment_tracking rt 
    ON rt.patient_id = p.patient_id
	JOIN record_requests rr 
	ON rr.patient_id = p.patient_id
GROUP BY v.vendor_name;
 
 /*
Q7 — Record-request status counts by facility

Goal:
For each facility, count received and pending record requests.

Logic:
- facilities connects to record_requests through facility_id.
- LEFT JOIN preserves facilities even when they have no requests.
- CASE WHEN creates separate conditions for received and pending.
- COUNT ignores NULL results from CASE.

Key concept:
Conditional aggregation can create multiple metrics
from the same group.
*/

SELECT f.facility_id, f.facility_name,
	COUNT(CASE WHEN rr.status = 'received' THEN 1 END) AS records_received,
    COUNT(CASE WHEN rr.status = 'pending' THEN 1 END) AS records_pending
FROM facilities f 
	LEFT JOIN record_requests rr 
	ON rr. facility_id = f.facility_id
GROUP BY f.facility_id, f.facility_name;

/*
Q8 — Patients and record requests by site

Goal:
For each site, show total unique patients and total record requests.

Important breakthrough:
A patient can have multiple record requests.

After joining patients to record_requests, the same patient_id
can therefore appear on multiple joined rows.

SQL does NOT automatically deduplicate the patient.

COUNT(DISTINCT p.patient_id)
counts each patient only once.

COUNT(rr.request_id)
counts the individual request rows.

Key concept:
JOINs can change the grain of the result.
Patient grain and request grain are not the same thing.
*/

SELECT s.site_id, s.site_name,
	COUNT(DISTINCT p.patient_id) AS total_patients,
    COUNT(rr.request_id) AS total_record_requests
FROM sites s
	LEFT JOIN patients p 
	ON p.site_id = s.site_id
	LEFT JOIN record_requests rr 
	ON rr.patient_id = p.patient_id
GROUP BY s.site_id, s.site_name;

/*
Q9 — Different facilities used by each site

Goal:
For each site, count how many unique facilities received
record requests from that site's patients.

Logic:
- site -> patients -> record_requests -> facilities
- A site may have many requests sent to the same facility.
- COUNT(DISTINCT facility_id) counts that facility only once.
- COUNT(request_id) counts individual record requests.

Language note:
"different facilities" means "unique facilities."

Key concept:
DISTINCT applies to the values being counted;
it is not itself an aggregation.
*/

SELECT s.site_id, s.site_name,
	COUNT(DISTINCT f.facility_id) AS different_facilities,
	COUNT(rr.request_id) AS record_requests
FROM sites s 
	JOIN patients p 
	ON p.site_id = s.site_id
	JOIN record_requests rr 
	ON rr.patient_id = p.patient_id
	LEFT JOIN facilities f 
	ON f.facility_id = rr.facility_id
GROUP BY s.site_id, s.site_name;

/*
Q10 — Sites with at least two signed ROIs

Goal:
Return only sites with 2 or more patients whose ROI is signed.

Logic:
- GROUP BY creates one group per site.
- CASE WHEN counts only rows with status = 'roi signed'.
- HAVING filters the grouped/aggregated results.
- >= means "at least."

WHERE filters rows before aggregation.
HAVING filters groups after aggregation.

Key concept:
Use HAVING when the filtering condition depends
on an aggregate such as COUNT().
*/

SELECT s.site_name,
	COUNT(CASE WHEN rt.status = 'roi signed' THEN 1 END) AS roi_signed_count
FROM sites s
	JOIN patients p 
	ON p.site_id = s.site_id
	JOIN recruitment_tracking rt 
	ON rt.patient_id = p.patient_id
GROUP BY s.site_name
HAVING COUNT(CASE WHEN rt.status = 'roi signed' THEN 1 END) >= 2;

/*
Q11 — Sites with pending record requests

Goal:
Return sites that have at least one pending record request.

Logic:
- CASE WHEN counts pending requests within each site.
- GROUP BY produces one result row per site.
- HAVING ... >= 1 removes sites with zero pending requests.

Key concept:
HAVING can filter groups based on a calculated count.
*/

SELECT s.site_id, s.site_name,
       COUNT(CASE WHEN rr.status = 'pending' THEN 1 END) AS pending_record_requests
FROM sites s
JOIN patients p 
	   ON p.site_id = s.site_id
JOIN record_requests rr 
       ON rr.patient_id = p.patient_id
GROUP BY s.site_id, s.site_name
HAVING COUNT(CASE WHEN rr.status = 'pending' THEN 1 END) >= 1;

/*
Q12 — Patients missing recruitment tracking

Goal:
Find patients that do not have a matching row
in recruitment_tracking.

Logic:
- Start with all patients.
- LEFT JOIN attempts to find a matching tracking row.
- If no match exists, columns from recruitment_tracking are NULL.
- WHERE rt.patient_id IS NULL isolates those unmatched patients.

Note:
rt.patient_id AS tracking_patient_id creates an alias.
The alias changes only the result column name;
it does not rename the database column.

Key concept:
LEFT JOIN + IS NULL is an anti-join pattern
for finding missing relationships.
*/

SELECT p.patient_id, rt.patient_id AS tracking_patient_id
FROM patients p
LEFT JOIN recruitment_tracking rt 
	 ON rt.patient_id = p.patient_id
WHERE rt.patient_id IS NULL;

/*
Q13 — Patients without record requests

Goal:
Find patients that do not have a record_request row.

Logic:
- LEFT JOIN preserves every patient.
- Patients without a matching request receive NULL
  for record_requests columns.
- WHERE request_id IS NULL keeps only those patients.

Key concept:
Another example of LEFT JOIN + IS NULL
to find missing related records.
*/

SELECT p.patient_id, rr.request_id
FROM patients p
LEFT JOIN record_requests rr 
	  ON rr.patient_id = p.patient_id
WHERE rr.request_id IS NULL;

/*
Q14 — Vendors with ROI signing rate above 60%

Goal:
Return vendor_id and vendor_name only for vendors whose
ROI signing percentage is greater than 60%.

Important lesson:
An aggregate does NOT have to appear in SELECT
in order to be used in HAVING.

The percentage can be calculated only for filtering
while SELECT returns just the vendor information.

GROUP BY is necessary here because the percentage
is being calculated separately for each vendor.

Key concept:
SELECT determines what appears in the result.
HAVING can use calculations that are not displayed.
*/

SELECT v.vendor_id, v.vendor_name
FROM vendors v
JOIN patients p 
	 ON p.vendor_id = v.vendor_id
JOIN recruitment_tracking rt 
     ON rt.patient_id = p.patient_id
GROUP BY v.vendor_id, v.vendor_name
HAVING COUNT(CASE WHEN rt.status = 'roi signed' THEN 1 END) * 100.0 /
	   COUNT(p.patient_id) > 60;

/*
Q15 — Patients and second follow-ups by recruitment status

Goal:
For each recruitment status, show:
- number of patients
- number that have a second follow-up date

Logic:
COUNT(patient_id) counts patient rows.
COUNT(followup_2_date) counts only NON-NULL followup_2_date values.

This works because COUNT(column) ignores NULL.

Key concept:
COUNT(*) / COUNT(id) and COUNT(nullable_column)
can answer different questions.
*/

SELECT status, 
COUNT(patient_id) AS number_of_patients,
COUNT(followup_2_date) AS second_followup
FROM recruitment_tracking
GROUP BY status;

/*
Q16 — ROI signing turnaround by patient

Goal:
Calculate how many days passed between first contact
and ROI signing for each patient who signed.

Logic:
DATEDIFF(roi_signed_date, first_contact_date)
calculates elapsed days.

WHERE roi_signed_date IS NOT NULL removes patients
for whom turnaround cannot yet be calculated.

Important distinction:
COUNT(date_column) counts non-NULL dates.
DATEDIFF(date2, date1) performs date arithmetic.

Key concept:
Derived/calculated columns can be created in SELECT.
*/

SELECT patient_id,
DATEDIFF(roi_signed_date, first_contact_date) AS turnaround_days
FROM recruitment_tracking
WHERE roi_signed_date IS NOT NULL;

/*
Q17 — Fastest ROI signing

Goal:
Find the 3 patients with the shortest turnaround
between first contact and ROI signing.

Logic:
- DATEDIFF calculates turnaround_days.
- WHERE excludes unsigned patients.
- ORDER BY turnaround_days ASC puts the shortest
  turnaround first.
- LIMIT 3 returns only the first three rows.

Key concept:
ASC = smallest to largest.
DESC = largest to smallest.
*/

SELECT patient_id,
DATEDIFF(roi_signed_date, first_contact_date) AS turnaround_days
FROM recruitment_tracking
WHERE roi_signed_date IS NOT NULL
ORDER BY turnaround_days ASC
LIMIT 3;

/*
Q18 — Average ROI turnaround by vendor

Goal:
Calculate average first-contact-to-ROI-signing turnaround
for each vendor.

Logic:
- DATEDIFF calculates turnaround for each patient.
- AVG() aggregates those individual turnaround values.
- ROUND(..., 1) displays one decimal place.
- WHERE excludes patients without an ROI signed date.
- GROUP BY calculates a separate average for each vendor.

Key concept:
Functions can be nested:
ROUND(AVG(DATEDIFF(...)), 1)
*/

SELECT v.vendor_name, 
ROUND(AVG(DATEDIFF(rt.roi_signed_date, rt.first_contact_date)),1) 
AS avg_turnaround
FROM vendors v
JOIN patients p ON p.vendor_id = v.vendor_id
JOIN recruitment_tracking rt ON rt.patient_id = p.patient_id
WHERE rt.roi_signed_date IS NOT NULL
GROUP BY v.vendor_id, v.vendor_name;

/*
Q19 — Average record turnaround by facility

Goal:
Calculate each facility's average time from request sent
to records received.

Logic:
DATEDIFF(records_received_date, roi_sent_date)
calculates turnaround for one request.

AVG(DATEDIFF(...))
calculates average turnaround for all completed requests
at that facility.

WHERE records_received_date IS NOT NULL prevents incomplete
requests from contributing to turnaround.

ORDER BY avg_turnaround ASC shows fastest facilities first.

Key concept:
Aggregate a calculated value after defining the event interval.
*/

SELECT f.facility_name, 
ROUND(AVG(DATEDIFF(rr.records_received_date, rr.roi_sent_date)),1) 
AS avg_turnaround
FROM facilities f
JOIN record_requests rr ON rr.facility_id = f.facility_id
WHERE rr.records_received_date IS NOT NULL
GROUP BY f.facility_id, f.facility_name
ORDER BY avg_turnaround ASC;

/*
Practice/repeated version of Q19.
Same logic: average request-to-receipt turnaround by facility.
*/


SELECT f.facility_name, 
ROUND(AVG(DATEDIFF(rr.records_received_date, rr.roi_sent_date)),1) 
AS avg_turnaround
FROM facilities f
JOIN record_requests rr ON rr.facility_id = f.facility_id
WHERE rr.records_received_date IS NOT NULL
GROUP BY f.facility_id, f.facility_name
ORDER BY avg_turnaround ASC;

/*
Q20 — Facility with longest average turnaround

Goal:
Find the facility with the highest average
request-to-records-received turnaround.

Logic:
Same average turnaround calculation as Q19.

Difference:
ORDER BY avg_turnaround DESC
puts the largest average first.

LIMIT 1 returns only the slowest facility.

Key concept:
ORDER BY + LIMIT can answer top/bottom ranking questions.
*/

SELECT f.facility_name, 
ROUND(AVG(DATEDIFF(rr.records_received_date, rr.roi_sent_date)),1) 
AS avg_turnaround
FROM facilities f
JOIN record_requests rr ON rr.facility_id = f.facility_id
WHERE rr.records_received_date IS NOT NULL
GROUP BY f.facility_id, f.facility_name
ORDER BY avg_turnaround DESC
LIMIT 1;

/*
Q21 — Conversion funnel by vendor

Goal:
For each vendor, show progression through the workflow:
total referred patients -> ROI signed -> records requested
-> records received.

Major lesson:
This query combines tables with different grains.

Patient-level metrics:
- total referred patients
- patients with signed ROI

Request-level metrics:
- record requests sent
- record requests received

COUNT(DISTINCT CASE WHEN ... THEN patient_id END)
does NOT return patient IDs.
patient_id is used internally to identify the unique entity
that COUNT should count.

Important:
The existence of request_id and the evidence that a request
was actually SENT are different ideas.

request_id = identifies the request
roi_sent_date IS NOT NULL = evidence that it was sent

Key concept:
Separate:
1. WHAT entity am I counting?
2. WHAT condition proves that entity reached the stage?
*/

SELECT v.vendor_name, 
COUNT(DISTINCT p.patient_id) AS total_referred_patients,
COUNT(DISTINCT CASE WHEN rt.status = 'roi signed' THEN p.patient_id END) AS total_roi_signed,
COUNT(rr.roi_sent_date) AS total_records_requested, 
COUNT(CASE WHEN rr.status = 'received' THEN 1 END) AS total_records_received
FROM vendors v
LEFT JOIN patients p ON p.vendor_id = v.vendor_id
LEFT JOIN recruitment_tracking rt ON rt.patient_id = p.patient_id
LEFT JOIN record_requests rr ON rr.patient_id = p.patient_id
GROUP BY v.vendor_id, v.vendor_name;

/*
Q22 — Site conversion dashboard

Goal:
For each site, show:
- total patients
- total ROI signed
- ROI signing percentage
- total record requests sent
- total records received
- records-received percentage

THIS QUERY INTRODUCED THE CONCEPT OF GRAIN.

Grain = what one unit/row represents.

Patient metrics use patient_id.
Request metrics use request_id.

Because joining record_requests can create multiple rows
for the same patient, patient metrics require protection
against JOIN multiplication.

COUNT(DISTINCT patient_id)
counts each patient once.

For request metrics:
request_id identifies the request.
roi_sent_date IS NOT NULL proves the request was sent.
records_received_date IS NOT NULL proves records were received.

NULLIF(denominator, 0) prevents division by zero.

Major mental-model breakthrough:
SQL does NOT automatically recognize that repeated patient_ids
represent the same entity after a JOIN.
Every valid matching row is returned.

Always ask:
- What am I counting?
- What is its unique identifier?
- What proves the event happened?
- Can my JOINs multiply it?
- Do I need DISTINCT?
*/

SELECT s.site_name,
COUNT(DISTINCT p.patient_id) AS total_patients,
COUNT(DISTINCT CASE WHEN rt.status = 'roi signed' THEN p.patient_id END) AS total_roi_signed,
ROUND(COUNT(DISTINCT CASE WHEN rt.status = 'roi signed' THEN p.patient_id END) * 100.0 / NULLIF(COUNT(DISTINCT p.patient_id), 0), 1) AS roi_signed_percentage,
COUNT(DISTINCT CASE WHEN rr.roi_sent_date IS NOT NULL THEN rr.request_id END) AS total_records_requested,
COUNT(DISTINCT CASE WHEN rr.records_received_date IS NOT NULL THEN rr.request_id END) AS total_records_received,
ROUND(COUNT(DISTINCT CASE WHEN rr.records_received_date IS NOT NULL THEN rr.request_id  END ) * 100.0 / NULLIF(COUNT(DISTINCT CASE WHEN rr.roi_sent_date IS NOT NULL THEN rr.request_id END),0),1) AS records_received_percentage
FROM sites s
LEFT JOIN patients p ON p.site_id = s.site_id
LEFT JOIN recruitment_tracking rt ON rt.patient_id = p.patient_id
LEFT JOIN record_requests rr ON rr.patient_id = p.patient_id
GROUP BY s.site_id, s.site_name;

/*
Q23 — Monthly recruitment trend

Goal:
Group patients according to the month of first_contact_date
and show total new patients and total signed ROIs.

New concept:
SELECT does NOT only retrieve columns that already exist.

DATE_FORMAT(first_contact_date, '%Y-%m')
creates a derived value such as:

2026-08-13 -> 2026-08

AS contact_month gives that derived result a temporary name.

MySQL allows the alias contact_month to be reused
in GROUP BY.

Major mental-model breakthrough:
SELECT defines what I want the RESULT to contain.
The result can contain existing columns, calculations,
aggregations, transformations, and derived columns.

The source table and result table do not have to
have the same structure.
*/

SELECT DATE_FORMAT(rt.first_contact_date, '%Y-%m') AS contact_month,
COUNT(DISTINCT rt.patient_id) AS total_new_patients,
COUNT(DISTINCT CASE WHEN rt.status = 'roi signed' THEN rt.patient_id END) AS total_roi_signed
FROM recruitment_tracking rt
GROUP BY contact_month;

/*
Q24 — Monthly records trend

Goal:
For each request month, show:
- total record requests
- total requests received
- average turnaround days

DATE_FORMAT converts the full roi_sent_date into year-month.

request_id represents the request grain.

DATEDIFF(records_received_date, roi_sent_date)
calculates turnaround for ONE request.

AVG(DATEDIFF(...))
calculates the average turnaround for all applicable
requests within that month.

Important distinction:
COUNT(date_column) = count rows where the date exists.
DATEDIFF(date2, date1) = calculate elapsed time.
AVG(DATEDIFF(...)) = average those elapsed times.

Key concept:
Grouping transformed dates + aggregating calculated values.
*/

SELECT DATE_FORMAT(roi_sent_date, '%Y-%m') AS requests_by_month,
COUNT(DISTINCT CASE WHEN roi_sent_date IS NOT NULL THEN request_id END) AS total_record_requests,
COUNT(DISTINCT CASE WHEN status = 'received' THEN request_id END) AS total_requests_received,
ROUND(AVG(DATEDIFF(records_received_date, roi_sent_date)),1) AS avg_turnaround_days
FROM record_requests
GROUP BY requests_by_month;
  
/*
Q25 — Derived patient workflow status

Goal:
Create ONE status column that does not physically exist
in the database by deriving the patient's current stage
from existing workflow data.

Workflow rules:

COMPLETED
records_received_date exists and request status is received.

RECORDS PENDING
roi_sent_date exists and request status is pending.

ROI SIGNED / NO RECORDS REQUESTED
roi_signed_date exists but no record request has been sent.

LOST
third follow-up exists and ROI has not been signed.

RECRUITMENT PENDING
first contact exists, ROI has not been signed,
and the third follow-up has not occurred.

New concept:
CASE WHEN can directly create a derived column.
It does not have to be inside COUNT().

CASE evaluates WHEN conditions from top to bottom
and stops at the FIRST true condition.

Therefore, order matters.

The workflow is evaluated from the most advanced stage
back toward the earliest stage so a completed patient
is not incorrectly classified as merely ROI signed.

Key concept:
SQL can encode business/workflow logic into derived fields.
Correct SQL syntax is not enough; the business rules
themselves must also be correct.
*/

 SELECT p.patient_id,
CASE
    WHEN rr.records_received_date IS NOT NULL
	     AND rr.status = 'received'
         THEN 'completed'
    WHEN rr.roi_sent_date IS NOT NULL
         AND rr.status = 'pending'
         THEN 'records pending'
    WHEN rt.roi_signed_date IS NOT NULL
         AND rr.roi_sent_date IS NULL
         THEN 'roi signed / no records requested'
WHEN rt.followup_3_date IS NOT NULL
		AND rt.roi_signed_date IS NULL
        THEN 'lost'
WHEN rt.first_contact_date IS NOT NULL
         AND rt.roi_signed_date IS NULL
         AND rt.followup_3_date IS NULL
         THEN 'recruitment pending'
END AS derived_status
FROM patients p
LEFT JOIN recruitment_tracking rt ON rt.patient_id = p.patient_id
LEFT JOIN record_requests rr ON rr.patient_id = p.patient_id;     

USE clinical_trial_tracking;

/*
============================================================
SQL ANALYST WORKBOOK — PHASE 2
Relational Reasoning & Business Investigation

MODULE 1 — GRAIN & JOIN MULTIPLICATION LAB

Dataset expanded to 250 patients
============================================================
*/

/*

Business Question 1 — Recruitment volume

Operations wants to understand the size of the recruitment pipeline.

Show each vendor and the number of unique patients referred.

Before writing SQL:
What is the grain of patients?
What entity are you counting?
What uniquely identifies it?

*/

SELECT v.vendor_id, v.vendor_name,
	COUNT(DISTINCT p.patient_id) AS total_referred_patients
FROM vendors v
LEFT JOIN patients p
	ON p.vendor_id = v.vendor_id
	GROUP BY v.vendor_id, v.vendor_name;

/*
Business Question 2 — Vendor record-request activity 

Operations wants to know how much medical-record retrieval activity each vendor generated. 

Show each vendor and the number of record requests associated with its patients. 
*/

SELECT v.vendor_id, v.vendor_name, 
	COUNT(rr.request_id) AS record_requests
FROM vendors v
	LEFT JOIN patients p 
    ON p.vendor_id = v.vendor_id
    LEFT JOIN record_requests rr
    ON rr.patient_id = p.patient_id
GROUP BY v.vendor_id, v.vendor_name;

/*
Business Question 3 — Patients generating record requests

Operations wants to know how many unique patients from each vendor
have generated at least one record request.

The report must count each patient only once, even when a patient
has multiple record requests.
*/

SELECT v.vendor_id, v.vendor_name, 
	COUNT(DISTINCT rr.patient_id) AS patients_one_record_request
FROM vendors v
	LEFT JOIN patients p
    ON p.vendor_id = v.vendor_id
    LEFT JOIN record_requests rr
    ON rr.patient_id = p.patient_id
GROUP BY v.vendor_id, v.vendor_name;

/*
Business Question 4 — Vendor conversion accuracy

Leadership wants ROI conversion rates by vendor.

Show:
vendor
unique referred patients
unique patients with signed ROI
ROI conversion rate
*/

SELECT v.vendor_id, v.vendor_name,
	COUNT(DISTINCT p.patient_id) 
    AS referred_patients,
	COUNT(DISTINCT CASE WHEN rt.roi_signed_date IS NOT NULL THEN p.patient_id END) 
    AS patients_with_signed_roi,
    ROUND(
    COUNT(DISTINCT CASE WHEN rt.roi_signed_date IS NOT NULL THEN p.patient_id END) * 100.0 / COUNT(DISTINCT p.patient_id),1) 
    AS roi_conversion_rate
FROM vendors v
	LEFT JOIN patients p 
    ON p.vendor_id = v.vendor_id
    LEFT JOIN recruitment_tracking rt 
    ON rt.patient_id = p.patient_id
GROUP BY v.vendor_id, v.vendor_name;

/*
Business Question 5 — Facility workload

The records team wants to identify facilities creating the greatest retrieval workload.

Show each facility and:
total requests actually sent
total requests received
total requests still pending
*/

SELECT f.facility_id, f.facility_name, 
	COUNT(DISTINCT CASE WHEN rr.roi_sent_date IS NOT NULL THEN rr.request_id END)
    AS total_requests_sent,
    COUNT(DISTINCT CASE WHEN rr.records_received_date IS NOT NULL THEN rr.request_id END)
    AS total_requests_received,
    COUNT(DISTINCT CASE WHEN rr.roi_sent_date IS NOT NULL AND rr.status = 'pending' THEN rr.request_id END)
    AS total_pending_requests
FROM facilities f
	LEFT JOIN record_requests rr
    ON f.facility_id = rr.facility_id
GROUP BY f.facility_id, f.facility_name;

/*
Business Question 6 — Patient vs. request metrics

A manager asks: “How many patients are waiting for records?”

Another asks:
“How many record requests are still pending?”
*/

SELECT
	COUNT(DISTINCT CASE WHEN roi_sent_date IS NOT NULL AND status = 'pending' THEN patient_id END)
    AS total_patients_waiting_for_records,
    COUNT(DISTINCT CASE WHEN roi_sent_date IS NOT NULL AND status = 'pending' THEN request_id END)
    AS total_pending_record_requests
    FROM record_requests;
    

    

