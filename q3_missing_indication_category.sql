/* The following script identifies null genetictest.indicationcategory fields for which it may be possible to 
 * interpret the indication category using information from the genetictest.clinicalindication field. Note that 
 * this query only pulls the fields which align to definitive indication categories. However, the remaining null 
 * entries could be completed as 'code 13 - other'. Duplicate patient_ids may arise as a single patient can have 
 * more than one genetic test. This script can be CUSTOMISED to search for a specific patient_id or for patients 
 * born  * within a specified date range by uncommenting the respective line of code at the bottom of the script 
 * and  * inserting appropriate id or dates within the quotation marks (''). */

SELECT DISTINCT p.patientid AS patient_id, p.birthdate1 AS patient_dob, gt.indicationcategory AS 
indication_category, gt.clinicalindication 
AS clinical_indication
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
OR UPPER(gt.clinicalindication) LIKE '%QUADRUPLE%'
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
AND gt.indicationcategory IS NULL
--AND p.patientid = ''
--AND p.birthdate1 BETWEEN '' AND ''
ORDER BY patient_id