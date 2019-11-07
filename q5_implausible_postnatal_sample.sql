/* The following script identifies cases that state that a postnatal sample was collected, recieved or 
 * authorised before the birth of the baby. Duplicate patient_ids may arise as a single patient can have more 
 * than one genetic test. This script can be CUSTOMISED to search for a specific patient_id or for patients born 
 * within a specified date range by uncommenting the respective line of code at the bottom of the script and 
 * inserting appropriate id or dates within the quotation marks (''). */

SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 as patient_dob, gt.collecteddate AS 
date_sample_collected, gt.receiveddate AS date_sample_received, gt.specimentype AS specimen_type
FROM springmvc3.genetictest gt
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid 
LEFT JOIN springmvc3.patient p ON p.patientid=e.patientid 
WHERE (gt.specimentype = 5
OR gt.specimentype = 6
OR gt.specimentype = 8
OR gt.specimentype = 9
OR gt.specimentype = 10
OR gt.specimentype = 13
OR gt.specimentype = 15
OR gt.specimentype = 19
OR gt.specimentype = 23)
AND (gt.collecteddate < p.birthdate1
OR gt.receiveddate < p.birthdate1
OR gt.authoriseddate < p.birthdate1)
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND ''
ORDER BY patient_id