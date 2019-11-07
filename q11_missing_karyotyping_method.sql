/* Script to identify cases which have a null genetictest.karyotypingmethod field for which the 
 * genetictest.genetictestscope field indicates that a gene panel was performed (Sequencing, NGS). Duplicate 
 * patient_ids may arise as a single patient can have more than one genetic test. This script can be CUSTOMISED to 
 * search for a specific patient_id or for patients born within a specified date range by uncommenting the 
 * respective line of code at the bottom of the script and inserting appropriate id or dates within the quotation 
 * marks (''). */ 

SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, gt.karyotypingmethod AS 
karyotyping_method, gt.genetictestscope AS genetic_test_scope
FROM springmvc3.genetictest gt
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid
LEFT JOIN springmvc3.patient p ON e.patientid=p.patientid
WHERE gt.karyotypingmethod IS NULL  
AND UPPER(gt.genetictestscope) LIKE '%PANEL%'
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND ''
ORDER BY patient_id