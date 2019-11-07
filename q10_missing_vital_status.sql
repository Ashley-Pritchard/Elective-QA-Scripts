/* Script to identify cases which have a death date (baby.deathdiagnoseddate) but for which the vital status 
 * (p.vitalstatus) has not been recorded as dead. Duplicate patient_ids may arise as a single patient can have 
 * more than one genetic test. This script can be CUSTOMISED to search for a specific patient_id or for patients 
 * born within a specified date range by uncommenting the respective line of code at the bottom of the script and 
 * inserting appropriate id or dates within the quotation marks (''). */

SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, b.deathdiagnoseddate AS 
date_of_death_baby, p.vitalstatus AS vital_status
FROM springmvc3.patient p 
LEFT JOIN springmvc3.baby b ON p.patientid= b.patientid
WHERE b.deathdiagnoseddate IS NOT NULL 
AND(p.vitalstatus != 'D' OR p.vitalstatus IS NULL)
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND ''
ORDER BY patient_id