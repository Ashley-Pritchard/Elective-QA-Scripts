/* The following script identifies cases with null patient.sex fields for which it may be possible to interpret  
 * patient sex using information from the genetictestresult.karyotypearrayresult, genetictest.clinicalindication 
 * or genetictestresult.report fields. Duplicate patient_ids may arise as a single patient can have more than
 * one genetic test. This script can be CUSTOMISED to search for a specific patient_id or for patients born 
 * within a specified date range by uncommenting the respective line of code at the bottom of the script and 
 * inserting appropriate id or dates within the quotation marks (''). */

SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, p.sex AS sex, gtr.karyotypearrayresult AS 
karyotype_result, gt.clinicalindication AS clinical_indication, gtr.report AS report_comments
FROM analysiscara.avc_genetictest gt
LEFT JOIN analysiscara.avc_genetictestresult gtr ON gt.genetictestid=gtr.genetictestid
LEFT JOIN springmvc3.patient p ON p.patientid=gt.patientid
WHERE (UPPER(gtr.karyotypearrayresult) LIKE '%XX%' 
OR UPPER(gtr.karyotypearrayresult) LIKE '%XY%'
OR UPPER(gtr.karyotypearrayresult) LIKE '%XCEN%'
OR UPPER(gtr.karyotypearrayresult) LIKE '%YCEN%'
OR UPPER(gtr.karyotypearrayresult) LIKE '%DXZ1%'
OR UPPER(gtr.karyotypearrayresult) LIKE '%DYZ3%'
OR UPPER(gtr.karyotypearrayresult) LIKE '%,X%'
OR UPPER(gt.clinicalindication) LIKE '%XX%'
OR UPPER(gt.clinicalindication) LIKE '%XY%'
OR UPPER(gt.clinicalindication) LIKE '%XCEN%'
OR UPPER(gt.clinicalindication) LIKE '%YCEN%'
OR UPPER(gt.clinicalindication) LIKE '%DXZ1%'
OR UPPER(gt.clinicalindication) LIKE '%DYZ3%'
OR UPPER(gt.clinicalindication) LIKE '%,X%'
OR UPPER(gt.clinicalindication) LIKE '%MALE%'
OR UPPER(gt.clinicalindication) LIKE '%FEMALE%'
OR UPPER(gtr.report) LIKE '%XX%'
OR UPPER(gtr.report) LIKE '%XY%'
OR UPPER(gtr.report) LIKE '%XCEN%'
OR UPPER(gtr.report) LIKE '%YCEN%'
OR UPPER(gtr.report) LIKE '%DXZ1%'
OR UPPER(gtr.report) LIKE '%DYZ3%'
OR UPPER(gtr.report) LIKE '%,X%'
OR UPPER(gtr.report) LIKE '%MALE%'
OR UPPER(gtr.report) LIKE '%FEMALE%')
AND p.sex IS NULL 
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND ''
ORDER BY patient_id