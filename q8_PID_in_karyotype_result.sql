/* Script to identify cases in which the genetictestresult.karotypearrayresult field contains Personal Identifiers
 * (PID) for removal. Duplicate patient_ids may arise as a single patient can have more than one test. This script 
 * can be CUSTOMISED to search for a specific patient_id or for patients born within a specified date range by 
 * uncommenting the respective line of code at the bottom of the script and inserting appropriate id or dates 
 * within the quotation marks (''). */

SELECT DISTINCT pb.patientid AS patient_id, pb.birthdate1 AS patient_dob, gtr.karyotypearrayresult AS 
karyotype_result, pb.forename AS baby_forename, pb.surname AS baby_surname, pb.surnameatbirth AS 
baby_surname_at_birth, pm.forename AS mum_forename, pm.surname AS mum_surname, pm.surnameatbirth AS 
mum_surname_at_birth
FROM springmvc3.genetictestresult gtr
LEFT JOIN springmvc3.genetictest gt ON gtr.genetictestid=gt.genetictestid
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid
LEFT JOIN springmvc3.patient pb ON e.patientid=pb.patientid
LEFT JOIN springmvc3.baby b ON b.patientid=pb.patientid
LEFT JOIN springmvc3.pregnancy p ON b.pregnancyid=p.pregnancyid
LEFT JOIN springmvc3.event em ON em.eventid=p.pregnancyid
LEFT JOIN springmvc3.patient pm ON em.patientid=pm.patientid
WHERE UPPER(gtr.karyotypearrayresult) LIKE UPPER('%'||pb.forename||'%') 
OR UPPER(gtr.karyotypearrayresult) LIKE UPPER('%'||pb.surname||'%') 
OR UPPER(gtr.karyotypearrayresult) LIKE UPPER('%'||pb.surnameatbirth||'%') 
OR UPPER(gtr.karyotypearrayresult) LIKE UPPER('%'||pm.forename||'%') 
OR UPPER(gtr.karyotypearrayresult) LIKE UPPER('%'||pm.surname||'%') 
OR UPPER(gtr.karyotypearrayresult) LIKE UPPER('%'||pm.surnameatbirth||'%')
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND ''
ORDER BY patient_id