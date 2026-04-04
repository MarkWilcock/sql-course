/*
 * NULLS Exercise - Final
*/

/*
 * Add a WHERE clause to the SQL query below to filter to those patients for whom ethnicity is not known  
*/
SELECT
	ps.PatientId
	,ps.Ethnicity
FROM
	PatientStay ps 
WHERE ps.Ethnicity IS NULL;

/*
 * Improve the SQL query below so that the values of the EthnicityIsNull calculated column is 'Not Known' rather than NULL
 * Use the ISNULL() function
*/
SELECT
	ps.PatientId
	,ps.Ethnicity
	,ISNULL(ps.Ethnicity,'Not Known')  AS EthnicityIsNull
FROM
	PatientStay ps ;

/*
 * Improve the SQL query below so that the values of the EthnicityCoalesce calculated column is 'Not Known' rather than NULL
 * Use the COALESCE() function
*/
SELECT
	ps.PatientId
	,ps.Ethnicity
	,COALESCE (ps.Ethnicity,'Not Known') AS EthnicityCoalesce
FROM
	PatientStay ps ;

/* 
 * Summarise the PatientStay table in a query that returns one row and two columns named:
 * NumberOfPatients
 * NumberOfPatientsWithKnownEthnicity
*/
SELECT
	count(*) AS NumberOfPatients
	,SUM(CASE WHEN Ethnicity IS NOT NULL THEN 1 ELSE 0 END) AS NumberOfPatientsWithKnownEthnicity
FROM
	PatientStay ps;

-- An alternative solution
SELECT
	count(*) AS NumberOfPatients
	,(SELECT COUNT(*) FROM PatientStay WHERE Ethnicity IS NOT NULL) AS NumberOfPatientsWithKnownEthnicity
FROM
	PatientStay ps;
