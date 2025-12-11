/*
SQL Course - CTE Lesson
CTE - Common Table Expression,uses the WITH clause
*/

/*
Two (or more step) processes are tricky when we have to write everything in one statement
One option is a simple subquery approach
Note that this approach may becomes unreadable if there are several levels of nesting
*/

SELECT
	p.AdmittedDate
	,p.AdvancedTariff
FROM
	(
	SELECT
		ps.AdmittedDate
		,ps.Hospital
		,SUM(ps.Tariff) + 1 AS AdvancedTariff
	FROM
		PatientStay ps
	GROUP BY
		ps.AdmittedDate
		,ps.Hospital) p
WHERE
	p.Hospital = 'PRUH'
	AND p.AdvancedTariff > 5;

/*
Use WITH and a common table expression (CTE) 
This yields exactly the same result but is more readable.
NOTE: SQL needs to know that WITH is the start of a statement - the previous statement must have a semi-colon at end
*/

WITH p (AdmittedDate,Hospital,AdvancedTariff)
AS (
SELECT
	ps.AdmittedDate
	,ps.Hospital
	,SUM(ps.Tariff) + 1
FROM
	PatientStay ps
GROUP BY
	ps.AdmittedDate
	,ps.Hospital)
SELECT
	p.AdmittedDate
	,p.AdvancedTariff
FROM
	p
WHERE
	p.Hospital = 'PRUH'
	AND p.AdvancedTariff > 5;

/*
We can also write this without the column list in the CTE as long as all the columns 
within the CTE definition have a column name or alias.
*/
WITH p
AS (
SELECT
	ps.AdmittedDate
	,ps.Hospital
	,SUM(ps.Tariff) + 1 AS AdvancedTariff
FROM
	PatientStay ps
GROUP BY
	ps.AdmittedDate
	,ps.Hospital)
SELECT
	p.AdmittedDate
	,p.AdvancedTariff
FROM
	p
WHERE
	p.Hospital = 'PRUH'
	AND p.AdvancedTariff > 5;
