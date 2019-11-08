/* Script to identify null testresult.testtype fields for which it may be possible to interpret the test type 
 * using information from the ultrasoundmarker.code, testresult.report or  * event.comments fields. Note that 
 * the presence of an ultrasound code indicates that an ultrasound was performed but not the stage it was 
 * performed - could go down as ultrasound other. Duplicate patient_ids may arise as a single patient can have 
 * more than one test. This script can be CUSTOMISED to search for a specific patient_id or for patients born 
 * within a specified date range by uncommenting the respective line of code at the bottom of the script and 
 * inserting appropriate id or dates within the quotation marks (''). When filtering by date, this script has 
 * been designed to include patient cases for which the date of birth is unknown. To exlude these cases, delete 
 * 'OR p.birthdate1 IS NULL' from the newly uncommented code. */

SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, tr.testresultid AS test_result_id, 
e.eventid AS event_id, tr.testtype AS test_type, tr.report AS report_test_details, e.comments AS event_comments, 
um.code AS ultrasound_marker_code
FROM springmvc3.testresult tr
LEFT JOIN springmvc3.event e ON tr.testresultid=e.eventid
LEFT JOIN springmvc3.patient p ON p.patientid=e.patientid 
LEFT JOIN springmvc3.ultrasoundmarker um ON tr.testresultid=um.testresultid
WHERE (UPPER(tr.report) LIKE '%AMNIO%'
OR UPPER(tr.report) LIKE '%BLOOD SPOT%'
OR UPPER(tr.report) LIKE '%CVS%'
OR UPPER(tr.report) LIKE '%CHROMOSOMES%'
OR UPPER(tr.report) LIKE '%COMBINED TEST%'
OR UPPER(tr.report) LIKE '%FETAL BLOOD%'
OR UPPER(tr.report) LIKE '%FETAL ECHO%'
OR UPPER(tr.report) LIKE '%HEARING%'
OR UPPER(tr.report) LIKE '%IMPRINTING%'
OR UPPER(tr.report) LIKE '%MRI%'
OR UPPER(tr.report) LIKE '%NIPE%'
OR UPPER(tr.report) LIKE '%NIPT%'
OR UPPER(tr.report) LIKE '%NUCHAL%'
OR UPPER(tr.report) LIKE '%GENETIC%'
OR UPPER(tr.report) LIKE '%PULSEBOX%'
OR UPPER(tr.report) LIKE '%POSTNATAL%'
OR UPPER(tr.report) LIKE '%PRENATAL%'
OR UPPER(tr.report) LIKE '%REFLEX DNA%'
OR UPPER(tr.report) LIKE '%SERUM SCREEN%'
OR UPPER(tr.report) LIKE '%SINGLE GENE%'
OR UPPER(tr.report) LIKE '%ULTRASOUND%'
OR UPPER(tr.report) LIKE '%WHOLE EXOME%'
OR UPPER(tr.report) LIKE '%WHOLE GENOME%'
OR UPPER(e.comments) LIKE '%AMNIO%'
OR UPPER(e.comments) LIKE '%BLOOD SPOT%'
OR UPPER(e.comments) LIKE '%CVS%'
OR UPPER(e.comments) LIKE '%CHROMOSOMES%'
OR UPPER(e.comments) LIKE '%COMBINED TEST%'
OR UPPER(e.comments) LIKE '%FETAL BLOOD%'
OR UPPER(e.comments) LIKE '%FETAL ECHO%'
OR UPPER(e.comments) LIKE '%HEARING%'
OR UPPER(e.comments) LIKE '%IMPRINTING%'
OR UPPER(e.comments) LIKE '%MRI%'
OR UPPER(e.comments) LIKE '%NIPE%'
OR UPPER(e.comments) LIKE '%NIPT%'
OR UPPER(e.comments) LIKE '%NUCHAL%'
OR UPPER(e.comments) LIKE '%GENETIC%'
OR UPPER(e.comments) LIKE '%PULSEBOX%'
OR UPPER(e.comments) LIKE '%POSTNATAL%'
OR UPPER(e.comments) LIKE '%PRENATAL%'
OR UPPER(e.comments) LIKE '%REFLEX DNA%'
OR UPPER(e.comments) LIKE '%SERUM SCREEN%'
OR UPPER(e.comments) LIKE '%SINGLE GENE%'
OR UPPER(e.comments) LIKE '%ULTRASOUND%'
OR UPPER(e.comments) LIKE '%WHOLE EXOME%'
OR UPPER(e.comments) LIKE '%WHOLE GENOME%'
OR um.code IS NOT NULL)
AND tr.testtype IS NULL
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND '' OR p.birthdate1 IS NULL
ORDER BY patient_id