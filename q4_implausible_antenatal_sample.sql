/* The following script identifies cases that state that an antenatal sample was collected or recieved after 
 * the birth of the baby. Note that in a small number of cases (~1%), an anenatal sample type has been recorded 
 * against parental / adult relative tests - see genetictest.clinicalindication for information. Duplicate 
 * patient_ids may arise as a single patient can have more than one genetic test. This script can be CUSTOMISED to
 * search for a specific patient_id or for patients born within a specified date range by uncommenting the 
 * respective line of code at the bottom of the script and  inserting appropriate id or dates within the quotation 
 * marks (''). When filtering by date, this script has been designed to include patient cases for which the date of 
 * birth is unknown. To exlude these cases, delete 'OR p.birthdate1 IS NULL' from the newly uncommented code. */
  
SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 as patient_dob, gt.genetictestid AS genetic_test_id, 
gt.collecteddate AS date_sample_collected, gt.receiveddate AS date_sample_received, gt.specimentype AS 
specimen_type, gt.clinicalindication AS clinical_indication
FROM springmvc3.genetictest gt
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid 
LEFT JOIN springmvc3.patient p ON e.patientid=p.patientid
WHERE (gt.specimentype = 1
OR gt.specimentype = 2
OR gt.specimentype = 3
OR gt.specimentype = 4)
AND (gt.collecteddate > p.birthdate1
OR gt.receiveddate > p.birthdate1)
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND '' OR p.birthdate1 IS NULL
ORDER BY p.patientid