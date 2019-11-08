/* The following script runs a number of quality control queries on the CARA database. The output of the script
 * is a table showing the result for each query per patient id. If a case has been flagged by a query, and 
 * therefore action is required, the field will read '1'. Otherwise the field will be null. Note that a single 
 * patient can have more than one genetic test / pregnancy etc. If any attribute of the patient is flagged by a 
 * query, a '1' will show for that query aside the patient case in the output table. In most cases, it should be 
 * straight forward for registration staff to find the record which requires amending. However, the individual 
 * query scripts can be run if more information about a specific patient case is required. These scripts have 
 * been designed to run with no filters, using a date range and for individual patiend_ids as required.  
 */
/* The patient id and result column from each query table (created below) is selected. The patient ids are
 * coalesced and later grouped so one row identifies all issues with a single case. Throughout the script, each
 * query table is linked to the previous using the patient id. The final completed table is selected as 'qa' so 
 * it can be filtered by date. This script can be CUSTOMISED to limit results to patient cases which have a 
 * date of birth within a specific range by uncommenting the respective line of code at the bottom of the script 
 * and inserting appropriate dates within the quotation marks (''). 
 */
SELECT * FROM (SELECT COALESCE (q1.patient_id, q2.patient_id, q3.patient_id, q4.patient_id, q5.patient_id, q6.patient_id, 
q7.patient_id, q8.patient_id, q9.patient_id, q10.patient_id, q11.patient_id) AS id_patient, COALESCE 
(q1.patient_dob, q2.patient_dob, q3.patient_dob, q4.patient_dob, q5.patient_dob, q6.patient_dob, 
q7.patient_dob, q8.patient_dob, q9.patient_dob, q10.patient_dob, q11.patient_dob) AS dob_patient, 
MAX(q1.missing_sex) AS missing_sex, MAX(q2.missing_test_type) AS missing_test_type, 
MAX(q3.missing_indication_category) AS missing_indication_category, MAX(q4.implausible_antenatal_sample) AS 
implausible_antenatal_sample, MAX(q5.implausible_postnatal_sample) AS implausible_postnatal_sample, 
MAX(q6.erroneous_test_status) AS erroneous_test_status, MAX(q7.implausible_indication_category) AS 
implausible_indication_category, MAX(q8.PID_in_karyotpe_result) AS PID_in_karyotype_result, 
MAX(q9.indication_of_TOP_not_outcome) AS indication_of_TOP_not_outcome, MAX(q10.missing_vital_status) AS 
missing_vital_status, MAX(q11.missing_karyotyping_method) AS missing_karyotyping_method
FROM
/* 
 * The first query table identifies cases with null patient.sex fields for which it may be possible to interpret 
 * patient sex using information from the genetictestresult.karyotypearrayresult, genetictest.clinicalindication 
 * or genetictestresult.report fields.  
 */
(SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, p.sex AS sex, gtr.karyotypearrayresult AS 
karyotype_result, gt.clinicalindication AS clinical_indication, gtr.report AS report_comments, '1' AS missing_sex
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
AND p.sex IS NULL) q1
/* 
 * The second query table identifies null testresult.testtype fields for which it may be possible to interpret
 * the test type using information from the ultrasoundmarker.code, testresult.report or event.comments fields. 
 * Note that the presence of an ultrasound code indicates that an ultrasound was performed but not the stage it 
 * was performed - could go down as ultrasound other.
 */
FULL OUTER JOIN 
(SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, tr.testtype AS test_type, tr.report AS 
report_test_details, e.comments AS event_comments, um.code AS ultrasound_marker_code, '1' missing_test_type
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
AND tr.testtype IS NULL) q2
ON q1.patient_id=q2.patient_id 
/* 
 * The third query table identifies null genetictest.indicationcategory fields for which it may be possible to 
 * interpret the indication category using information from the genetictest.clinicalindication field. Note that 
 * this query only pulls the fields which align to definitive indication categories. However, the remaining null 
 * entries could be completed as 'code 13 - other'.
 */
FULL OUTER JOIN
(SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, gt.indicationcategory AS 
indication_category, gt.clinicalindication, '1' AS missing_indication_category
FROM springmvc3.genetictest gt
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid
LEFT JOIN springmvc3.patient p ON e.patientid=p.patientid
WHERE (UPPER(gt.clinicalindication) LIKE '%NUCHAL%'
OR UPPER(gt.clinicalindication) LIKE 'NT%'
OR UPPER(gt.clinicalindication) LIKE '%FAMILY HISTORY%'
OR UPPER(gt.clinicalindication) LIKE '%ULTRASOUND%'
OR UPPER(gt.clinicalindication) LIKE '%SCAN%'
OR UPPER(gt.clinicalindication) LIKE '%CHROMOSOMAL ABNORMALITY%'
OR UPPER(gt.clinicalindication) LIKE '%CHROMOSOME ABNORMALITY%'
OR UPPER(gt.clinicalindication) LIKE '%COMBINED%'
OR UPPER(gt.clinicalindication) LIKE '%QUADRUPLE TEST%'
OR UPPER(gt.clinicalindication) LIKE '%NIPT%'
OR UPPER(gt.clinicalindication) LIKE '%MICROARRAY%'
OR UPPER(gt.clinicalindication) LIKE '%CONFIRMATION%'
OR UPPER(gt.clinicalindication) LIKE '%REQUEST%'
OR UPPER(gt.clinicalindication) LIKE '%PHENOTYPE%'
OR UPPER(gt.clinicalindication) LIKE '%MOLAR%'
OR UPPER(gt.clinicalindication) LIKE '%MISCARRIAGE%'
OR UPPER(gt.clinicalindication) LIKE '%IUD%'
OR UPPER(gt.clinicalindication) LIKE '%PERINATAL DEATH%'
OR UPPER(gt.clinicalindication) LIKE '%DIED%'
OR UPPER(gt.clinicalindication) LIKE '%TERMINATION%'
OR UPPER(gt.clinicalindication) LIKE '%PARENTAL BLOOD%'
OR UPPER(gt.clinicalindication) LIKE '%MATERNAL BLOOD%'
OR UPPER(gt.clinicalindication) LIKE '%PATERNAL BLOOD%'
OR UPPER(REPLACE(gt.clinicalindication, '''', '')) LIKE '%MOTHERS BLOOD%'
OR UPPER(REPLACE(gt.clinicalindication, '''', '')) LIKE '%FATHERS BLOOD%'
OR UPPER(gt.clinicalindication) LIKE '%DEVELOPMENT%'
OR UPPER(gt.clinicalindication) LIKE '%INFERTILITY%'
OR UPPER(gt.clinicalindication) LIKE '%PUBERTY%'
OR UPPER(gt.clinicalindication) LIKE '%GONADAL%'
OR UPPER(gt.clinicalindication) LIKE '%GENITALIA%'
OR UPPER(gt.clinicalindication) LIKE '%SUDDEN DEATH%'
OR UPPER(gt.clinicalindication) LIKE '%100KGP%'
OR UPPER(gt.clinicalindication) LIKE '%CARRIER%')
AND gt.indicationcategory IS NULL) q3
ON q2.patient_id=q3.patient_id
/* 
 * The fourth query table identifies cases that state that an antenatal sample was collected or received after 
 * the birth of the baby. Note that in a small number of cases (~1%), an antenatal sample type has been recorded 
 * against parental / adult relative tests.
 */
FULL OUTER JOIN  
(SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 as patient_dob, gt.collecteddate AS 
date_sample_collected, gt.receiveddate AS date_sample_received, gt.specimentype AS specimen_type, 
gt.clinicalindication AS clinical_indication, '1' AS implausible_antenatal_sample
FROM springmvc3.genetictest gt
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid 
LEFT JOIN springmvc3.patient p ON e.patientid=p.patientid
WHERE (gt.specimentype = 1
OR gt.specimentype = 2
OR gt.specimentype = 3
OR gt.specimentype = 4)
AND (gt.collecteddate > p.birthdate1
OR gt.receiveddate > p.birthdate1)) q4
ON q3.patient_id=q4.patient_id
/* 
 * The fifth query table identifies cases that state that a postnatal sample was collected, received or 
 * authorised before the birth of the baby. As above, if the script is not filtered by date below, there may be 
 * some adult contamination.
 */
FULL OUTER JOIN  
(SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 as patient_dob, gt.collecteddate AS 
date_sample_collected, gt.receiveddate AS date_sample_received, gt.specimentype AS specimen_type,'1' AS 
implausible_postnatal_sample
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
OR gt.authoriseddate < p.birthdate1)) q5
ON q4.patient_id=q5.patient_id
/* 
 * The sixth query table identifies cases in which the genetictestresult.karyotypearrayresult is normal but the 
 * genetictestresult.teststatus is recorded as either abnormal or null 
 */ 
FULL OUTER JOIN 
(SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, gtr.teststatus AS test_status, 
gtr.karyotypearrayresult AS karyotype_result, '1' AS erroneous_test_status
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
AND (gtr.teststatus != 1 OR gtr.teststatus IS NULL)) q6
ON q5.patient_id=q6.patient_id
/* 
 * The seventh query table identifies cases in which the genetictest.indication category is 'abnormal postnatal 
 * phenotype' but the baby was not live born.
 */
FULL OUTER JOIN  
(SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, gt.indicationcategory AS 
indication_category, gt.clinicalindication AS clinical_indication_category, b.outcome AS outcome, '1' AS 
implausible_indication_category
FROM springmvc3.genetictest gt  
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid
LEFT JOIN springmvc3.patient p ON e.patientid=p.patientid
LEFT JOIN springmvc3.baby b ON p.patientid=b.patientid
WHERE gt.indicationcategory = 12
AND b.outcome != 1
AND UPPER(gt.clinicalindication) NOT LIKE '%STILLBORN%'
AND UPPER(gt.clinicalindication) NOT LIKE '%STILLBIRTH%') q7
ON q6.patient_id=q7.patient_id
/* 
 * The eighth query table identifies cases in which the genetictestresult.karotypearrayresult field contains 
 * Personal Identifiers (PID) for removal
 */
FULL OUTER JOIN 
(SELECT DISTINCT pb.patientid AS patient_id, pb.birthdate1 AS patient_dob, gtr.karyotypearrayresult AS 
karyotype_result, pb.forename AS baby_forename, pb.surname AS baby_surname, pb.surnameatbirth AS 
baby_surname_at_birth, pm.forename AS mum_forename, pm.surname AS mum_surname, pm.surnameatbirth AS 
mum_surname_at_birth, '1' AS PID_in_karyotpe_result
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
OR UPPER(gtr.karyotypearrayresult) LIKE UPPER('%'||pm.surnameatbirth||'%')) q8
ON q7.patient_id=q8.patient_id
/* 
 * The ninth query table identifies cases in which the genetictest.clinicalindication is termination for anomaly 
 * but the b.outcome was not termination. 
 */
FULL OUTER JOIN
(SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, gt.indicationcategory AS 
indication_category, gt.clinicalindication AS clinical_indication_category, b.outcome AS outcome, '1' AS 
indication_of_TOP_not_outcome
FROM springmvc3.genetictest gt  
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid
LEFT JOIN springmvc3.patient p ON e.patientid=p.patientid
LEFT JOIN springmvc3.baby b ON p.patientid=b.patientid
WHERE b.outcome != 4
AND (UPPER(gt.clinicalindication) LIKE '%TOP %'
OR UPPER(gt.clinicalindication) LIKE '%TERMINATION%'
OR gt.indicationcategory = 17)) q9
ON q8.patient_id=q9.patient_id
/* 
 * The tenth query identifies cases which have a death date (baby.deathdiagnoseddate) but for which the vital 
 * status (p.vitalstatus) has not been recorded as dead. 
 */
FULL OUTER JOIN
(SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, b.deathdiagnoseddate AS 
date_of_death_baby, p.vitalstatus AS vital_status, '1' AS missing_vital_status
FROM springmvc3.patient p
LEFT JOIN springmvc3.baby b ON p.patientid= b.patientid
WHERE b.deathdiagnoseddate IS NOT NULL 
AND(p.vitalstatus != 'D' OR p.vitalstatus IS NULL)) q10
ON q9.patient_id=q10.patient_id
/* 
 * Script to identify cases which have a null genetictest.karyotypingmethod field for which the 
 * genetictest.genetictestscope field indicates that a gene panel was performed (Sequencing, NGS). 
 */
FULL OUTER JOIN
(SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, gt.karyotypingmethod AS 
karyotyping_method, gt.genetictestscope AS genetic_test_scope, '1' AS missing_karyotyping_method
FROM springmvc3.genetictest gt
LEFT JOIN springmvc3.event e ON gt.genetictestid=e.eventid
LEFT JOIN springmvc3.patient p ON e.patientid=p.patientid
WHERE gt.karyotypingmethod IS NULL  
AND UPPER(gt.genetictestscope) LIKE '%PANEL%') q11
ON q10.patient_id=q11.patient_id
GROUP BY id_patient, dob_patient) AS qa
/* 
 * The fully joined table of query outputs has been selected using 'qa' as an alias. This table can now be 
 * filtered by a date range and ordered by patient id. Change the date range as appropriate for analysis.
 * When filtering, this script has been designed to include patient cases for which the date of birth is unknown. 
 * To exclude these cases, delete 'OR qa.dob_patient is NULL' from the newly uncommented code. 
 */
--WHERE (qa.dob_patient BETWEEN '' AND '') OR qa.dob_patient is NULL
ORDER BY qa.id_patient
