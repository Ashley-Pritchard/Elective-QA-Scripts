/* Script to identify cases in which the genetictest.clinicalindication is termination for anomaly but the 
 * b.outcome was not termination. Duplicate patient_ids may arise as a single patient can have more than one 
 * test. This script can be CUSTOMISED to search for a specific patient_id or for patients born within a specified 
 * date range by uncommenting the respective line of code at the bottom of the script and inserting appropriate id 
 * or dates within the quotation marks (''). When filtering by date, this script has been designed to include 
 * patient cases for which the date of birth is unknown. To exlude these cases, delete 'OR p.birthdate1 IS NULL' 
 * from the newly uncommented code. */

SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, gt.genetictestid AS genetic_test_id, 
gt.indicationcategory AS indication_category, gt.clinicalindication AS clinical_indication_category, b.outcome 
AS outcome
FROM springmvc3.genetictest gt  
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid
LEFT JOIN springmvc3.patient p ON e.patientid=p.patientid
LEFT JOIN springmvc3.baby b ON p.patientid=b.patientid
WHERE b.outcome != 4
AND (UPPER(gt.clinicalindication) LIKE '%TOP %'
OR UPPER(gt.clinicalindication) LIKE '%TERMINATION%'
OR gt.indicationcategory = 17)
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND '' OR p.birthdate1 IS NULL
ORDER BY patient_id