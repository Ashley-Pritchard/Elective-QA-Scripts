/* The following script identifies cases in which the genetictest.indication category is 'abnormal postnatal 
 * phenotype' but the baby was not live born. Duplicate patient_ids may arise as a single patient can have
 * more than one test. This script can be CUSTOMISED to search for a specific patient_id 
 * or for patients born within a specified date range by uncommenting the respective line of code at the bottom of 
 * the script and inserting appropriate id or dates within the quotation marks (''). */
 
SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, gt.indicationcategory AS 
indication_category, gt.clinicalindication AS clinical_indication_category, b.outcome AS outcome
FROM springmvc3.genetictest gt  
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid
LEFT JOIN springmvc3.patient p ON e.patientid=p.patientid
LEFT JOIN springmvc3.baby b ON p.patientid=b.patientid
WHERE gt.indicationcategory = 12
AND b.outcome != 1
AND UPPER(gt.clinicalindication) NOT LIKE '%STILLBORN%'
AND UPPER(gt.clinicalindication) NOT LIKE '%STILLBIRTH%'
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND ''
ORDER BY patient_id