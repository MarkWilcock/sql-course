/*
SQL Course - Subqueries Lesson 2 - correlated subqueries

A correlated query refers to columns in the outer query.
It cannot be executed stand-alone
*/

/*
List the patients with tariffs that are greater than the overall average tariffs.
This is a self-contained query - NOT a correlated query
*/
SELECT
	ps.Hospital
	,ps.PatientId
	,ps.Tariff
	,(SELECT AVG(Tariff) FROM PatientStay) AS AverageTariff
FROM
	PatientStay ps
WHERE
	ps.Tariff >
    (
	SELECT AVG(Tariff) FROM PatientStay
	)
ORDER BY ps.Tariff ;

/*
Each Hospital has a different value for its average Tariff
*/
SELECT
	ps.Hospital
	,AVG(CAST(ps.Tariff AS FLOAT)) AS HospitalAverageTariff
FROM
	PatientStay ps
GROUP BY
	ps.Hospital;

/*
In the WHERE clause,filter to only the PatientIds of those patients with a tariffs greater than the  average tariff for their Hospital

Note that the calculation of 
- OverallAverageTariff does not requires a correlated subquery but
- HospitalAverageTariff does requires a correlated subquery.
*/

SELECT
	ps.Hospital
	,ps.PatientId
	,ps.Tariff
	,(	SELECT AVG(Tariff) FROM PatientStay) AS OverallAverageTariff
	,(	SELECT AVG(Tariff) FROM PatientStay WHERE Hospital = ps.Hospital) AS HospitalAverageTariff
FROM
	PatientStay ps
WHERE
	ps.Tariff >
    (SELECT AVG(Tariff) FROM PatientStay WHERE PatientStay.Hospital = ps.Hospital)
ORDER BY
	ps.Hospital
	,ps.Tariff;

/*
 * A common pattern is to use EXISTS in a coorrelated subquery as a alternative to IN in a self-contained since it performs better.
 */

SELECT
	ps.PatientId
	,ps.Hospital
FROM
	PatientStay ps
WHERE
	EXISTS (
	SELECT
		*
	FROM
		DimHospital h
	WHERE
		h.HospitalType = 'Teaching'
		AND h.Hospital = ps.Hospital )
ORDER BY 
	ps.Hospital
	,ps.PatientId 
 ;
/*
Correlated Query Use Case: Percentage Ratios
*/

SELECT
	ps.Hospital
	,ps.PatientId
	,ps.Tariff
	,100.0 * ps.Tariff / (SELECT SUM(Tariff) FROM PatientStay WHERE Hospital = ps.Hospital) AS HospitalPercentTariff
FROM
	PatientStay ps
ORDER BY
	ps.Hospital
	,ps.PatientId;

/*
Correlated Query Use Case
Assume that PatientIds are assigned when a patient is booked for a hospital stay
The previous patient booked before a each patient would  then have the biggest PatientId that is less than the current PatientId.
*/
SELECT
	ps.PatientId
	,(	SELECT MAX(PatientId) FROM PatientStay WHERE PatientId < ps.PatientId) AS PreviouslyBookedPatientId
	,(	SELECT MIN(PatientId) FROM PatientStay WHERE PatientId > ps.PatientId) AS NextBookedPatientId
FROM
	PatientStay ps
ORDER BY
	ps.PatientId;

/*
Correlated Query Use Case
Cumulative value (the sum of a column of all previous rows)
*/
SELECT
	ps.PatientId
	,ps.Tariff
	,(SELECT SUM(Tariff) FROM PatientStay WHERE PatientId <= ps.PatientId) AS RunningTotalTariff
FROM
	PatientStay ps
ORDER BY
	ps.PatientId;
