/* Script to identify cases in which the genetictestresult.karyotypearrayresult is normal but the 
 * genetictestresult.teststatus is recorded as either abnormal or null. Duplicate patient_ids may arise as a 
 * single patient can have more than one test. This script can be CUSTOMISED to search for a specific patient_id 
 * or for patients born within a specified date range by uncommenting the respective line of code at the bottom of 
 * the script and inserting appropriate id or dates within the quotation marks (''). When filtering by date, this 
 * script has been designed to include patient cases for which the date of birth is unknown. To exlude these cases, 
 * delete 'OR p.birthdate1 IS NULL' from the newly uncommented code.*/ 

SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, gtr.genetictestresultid AS 
genetic_test_result_id, gtr.teststatus AS test_status, gtr.karyotypearrayresult AS karyotype_result
FROM analysiscara.avc_genetictest gt
LEFT JOIN analysiscara.avc_genetictestresult gtr ON gt.genetictestid=gtr.genetictestid
LEFT JOIN springmvc3.patient p ON p.patientid=gt.patientid
WHERE (UPPER(karyotypearrayresult) LIKE '%NORMAL%'
OR UPPER(gtr.karyotypearrayresult) LIKE '%NO EVIDENCE%'
OR UPPER(gtr.karyotypearrayresult) LIKE '%NO CLINICALLY SIGNIFICANT%'
OR UPPER(gtr.karyotypearrayresult) LIKE '%NO SIGNIFICANT COPY%'
OR UPPER(REPLACE(REPLACE(gtr.karyotypearrayresult, ',',''), ' ', '')) LIKE'46XX'
OR UPPER(REPLACE(REPLACE(gtr.karyotypearrayresult, ',',''), ' ', '')) LIKE'46XY'
OR UPPER(REPLACE(REPLACE(gtr.karyotypearrayresult, ',',''), ' ', '')) LIKE '%(1-22X)X2%'
OR UPPER(REPLACE(REPLACE(gtr.karyotypearrayresult, ',',''), ' ', '')) LIKE '%(1-22)X2(XY)X1%')
AND UPPER(gtr.karyotypearrayresult) NOT LIKE '%ABNORMAL%'
AND UPPER(gtr.karyotypearrayresult) NOT LIKE '%HETEROZYGOUS%'
AND UPPER(gtr.karyotypearrayresult) NOT LIKE '%XY FEMALE%'
AND UPPER(gtr.karyotypearrayresult) NOT LIKE '%47%'
AND UPPER(gtr.karyotypearrayresult) NOT LIKE '%DER(%'
AND UPPER(REPLACE(REPLACE(gtr.karyotypearrayresult, ',',''), ' ', '')) NOT LIKE '%(1-22X)X2(Y)%'
AND (gtr.teststatus != 1 OR gtr.teststatus IS NULL)
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND '' OR p.birthdate1 IS NULL
ORDER BY patient_id