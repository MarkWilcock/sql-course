/*
Explaining Window Functions 

Window functions are very useful for analysis.  Examples include rolling totals,moving averages and ranking per category.
A window function is a computation that returns a single value applied to a set of rows defined by a window specification.
Each column can independently calculate a window function.
Each row has its own window

Syntax: window_function(...) OVER (window specification)

We use a small table, PatientStay, in these examples.
*/

SELECT
	ps.PatientId
	,ps.AdmittedDate
	,ps.Hospital
	,ps.Ward
	,ps.Ethnicity
	,ps.Tariff
FROM
	dbo.PatientStay ps;

/*
 * Write a SQL query to show the number of patients admitted each day
The resultset should have two columns:
* AdmittedDate
*NumberOfPatients
It should be sorted by AdmittedDate (earliest first)
 */


/*
We will use the DATENAME function later so let's have a look at it now.
How many patients were admittted each month?
*/

SELECT
	DATENAME(MONTH,ps.AdmittedDate) AS AdmittedMonth
	,COUNT(*) AS [Number Of Patients]
FROM
	dbo.PatientStay ps
GROUP BY
	DATENAME(MONTH,ps.AdmittedDate);

/*
The most basic - and useless - example of a Window function
Note that there is an aggregation,COUNT(*),but no GROUP BY
COUNT(*) counts over a window defined by OVER() - the whole of the table since we have not yet partioned it
*/

SELECT
	ps.PatientId
	,ps.Hospital
	,ps.Ward
	,ps.AdmittedDate
	,ps.Tariff
	,COUNT(*) OVER () AS TotalCount
	-- create a window over the whole table
FROM
	PatientStay ps
ORDER BY
	ps.PatientId;

/*
PARTITION divides one large window into several smaller windows
For each row,we create a window based on the rows with the same value of the PARTITION BY column(s) and aggregate over that window

We can PARTITION BY more than one column
*/
SELECT
	ps.PatientId
	,ps.Hospital
	,ps.Ward
	,ps.AdmittedDate
	,ps.Tariff
	,COUNT(*) OVER () AS TotalCount
--	,COUNT(*) OVER (PARTITION BY ps.Hospital) AS HospitalCount -- create a window over those rows with the same hospital as the current row
--	,COUNT(*) OVER (PARTITION BY ps.Ward) AS WardCount
--	,COUNT(*) OVER (PARTITION BY ps.Hospital ,ps.Ward) AS HospitalWardCount
FROM
	PatientStay ps
ORDER BY
	ps.PatientId;

/*
Use case: percentage of all rows in result set and percentage of a group 
*/

SELECT
	ps.PatientId
	,ps.Tariff
	,ps.Ward
	,SUM(ps.Tariff) OVER () AS TotalTariff
--	,SUM(ps.Tariff) OVER (PARTITION BY ps.Ward) AS WardTariff
--	,100.0 * ps.Tariff / SUM(ps.Tariff) OVER () AS PctOfAllTariff
--	,100.0 * ps.Tariff / SUM(ps.Tariff) OVER (PARTITION BY ps.Ward) AS PctOfWardTariff
FROM
	PatientStay ps
ORDER BY
	ps.Ward
	,ps.PatientId;



/*
ROW_NUMBER() is a special function used with Window functions to index rows in a window
It must have a ORDER BY since SQL must know  how to sort rows in each window
*/
SELECT
	ps.PatientId
	,ps.Hospital
	,ps.Ward
	,ps.AdmittedDate
	,ps.Tariff
	,ROW_NUMBER() OVER (ORDER BY ps.PatientId) AS PatientIndex
--	,ROW_NUMBER() OVER (PARTITION BY ps.Hospital ORDER BY ps.PatientId) AS PatientByHospitalIndex
--  ,COUNT(*) OVER (PARTITION BY ps.Hospital order by ps.PatientId)  as PatientByHospitalIndexAlt -- An alternative way of indexing
FROM
	PatientStay ps
ORDER BY
	ps.Hospital
	,ps.PatientId;

/*
Compare ROW_NUMBER(),RANK() and DENSE_RANK() where there are ties
ROW_NUMBER() will always create a monotonically  increasing sequence 1,2,3,... and arbitrarily choose one tie row over another
RANK() will give all tie rows the same value and the rank of the next row will n higher if there are n tie rows e.g. 1,1,3,...
DENSE_RANK() will give all tie rows the same value and the rank of the next row will one higher e.g. 1,1,2,...
NTILE(10) splits into deciles
*/

SELECT
	ps.PatientId
	,ps.Tariff
	,ROW_NUMBER() OVER (ORDER BY ps.Tariff DESC) AS PatientRowIndex
--	,RANK() OVER (	ORDER BY ps.Tariff DESC) AS PatientRank
--	,DENSE_RANK() OVER (ORDER BY ps.Tariff DESC) AS PatientDenseRank
--	,NTILE(10) OVER (ORDER BY ps.Tariff DESC) AS PatientIdDecile
FROM
	PatientStay ps
ORDER BY
	ps.Tariff DESC;

-- Use Window functions to calculate a cumulative value ,or running total
SELECT
	ps.AdmittedDate
	,ps.Tariff
	-- ,ROW_NUMBER() OVER (ORDER BY ps.AdmittedDate) AS RowIndex
	-- ,SUM(ps.Tariff) OVER (ORDER BY ps.AdmittedDate) AS RunningTariff
	-- ,ROW_NUMBER() OVER (PARTITION BY DATENAME(MONTH,ps.AdmittedDate) ORDER BY ps.AdmittedDate) AS MonthIndex
	-- ,SUM(ps.Tariff) OVER (PARTITION BY DATENAME(MONTH,ps.AdmittedDate) ORDER BY ps.AdmittedDate) AS MonthToDateTariff
FROM
	PatientStay ps
WHERE
	ps.Hospital = 'Oxleas'
	AND ps.Ward = 'Dermatology'
ORDER BY
	ps.AdmittedDate;


/*
 * We can achieve the same result by splitting into simpler steps
 * (a) the first step created the calculated column MonthAdmitted and applies the WHERE clause
 * (b) the second step applies the window functions 
 * Running Total,resetting each month,alternative and simpler statement using WITH 
 */

WITH cte
AS (
SELECT
	ps.AdmittedDate
	,DATENAME(MONTH,ps.AdmittedDate) AS MonthAdmitted
	,ps.Tariff
FROM
	PatientStay ps
WHERE
	ps.Hospital = 'Oxleas'
	AND ps.Ward = 'Dermatology')
SELECT
	cte.MonthAdmitted
	,cte.AdmittedDate
	,cte.Tariff
	,ROW_NUMBER() OVER (PARTITION BY cte.MonthAdmitted ORDER BY cte.AdmittedDate) AS RowIndex
	,SUM(cte.Tariff) OVER (PARTITION BY cte.MonthAdmitted ORDER BY cte.AdmittedDate) AS RunningTariff
FROM
	cte;

/*
Other special functions are LEAD() and LAG() 
LAG gets the value from the previous row in the window 
Use this for example to calculate the change of a balance or inventory level from  one day to the next
*/
SELECT
	ps.AdmittedDate
	,ps.Tariff
	,LEAD(ps.Tariff) OVER (ORDER BY ps.AdmittedDate) AS NextDayTariff 
--	,LAG(ps.Tariff) OVER (ORDER BY ps.AdmittedDate) AS PreviousDayTariff
--	,ps.Tariff - LAG(ps.Tariff) OVER (ORDER BY ps.AdmittedDate) AS ChangeOnPreviousDate
FROM
	PatientStay ps
WHERE
	ps.Hospital = 'Oxleas'
	AND ps.Ward = 'Dermatology';


/*
Find the running total of the tariff by date for each hospital
Firstly we must group by Hospital and Date in a CTE  
*/
WITH cte
AS (
SELECT
	ps.Hospital
	,ps.AdmittedDate
	,SUM(ps.Tariff) AS TotalTariff
FROM
	PatientStay ps
GROUP BY
	ps.Hospital
	,ps.AdmittedDate)
SELECT
	cte.Hospital
	,cte.AdmittedDate
	,cte.TotalTariff
	,SUM(cte.TotalTariff) OVER (PARTITION BY cte.Hospital ORDER BY cte.AdmittedDate) AS RunningTariff
	,ROW_NUMBER() OVER (PARTITION BY cte.Hospital ORDER BY cte.AdmittedDate) AS TariffIndex
FROM
	cte
ORDER BY
	cte.Hospital
	,cte.AdmittedDate;

/*
Window functions use case: Ranking & Top N per category
Find the top 2 most expensive patients in each hospital.  
In the case of ties return the patient with the lowest PatientId.
The CTE is necessary here since we cannot put a Window function into a WHERE clause
**/

WITH RankedPatient (PatientId,Hospital,Tariff,PatientRank)
AS (
SELECT
	PatientId
	,Hospital
	,Tariff
	,ROW_NUMBER() OVER (PARTITION BY Hospital ORDER BY Tariff DESC,PatientId) AS PatientRank
FROM
	PatientStay)
SELECT
	rp.Hospital
	,rp.PatientId
	,rp.Tariff
	,rp.PatientRank
FROM
	RankedPatient rp
WHERE
	rp.PatientRank <= 2
ORDER BY
	rp.Hospital
	,rp.Tariff DESC;

/*
Using CTEs to break into simpler steps

The WHERE clause is simply to return a small dataset of 4 patients,
each with a different admitted date,to make the example easier to understand.
*/
WITH cte
AS (
SELECT
	 ps.AdmittedDate 
	,ps.Tariff
	,LEAD(ps.Tariff) OVER (ORDER BY ps.AdmittedDate) AS NextDayTariff
	,LAG(ps.Tariff) OVER (ORDER BY ps.AdmittedDate) AS PreviousDayTariff
FROM
	PatientStay ps
WHERE
	ps.Hospital = 'Oxleas'
	AND ps.Ward = 'Dermatology')
SELECT
	cte.AdmittedDate
	,cte.Tariff
	,cte.NextDayTariff
	,cte.PreviousDayTariff
	,cte.Tariff - cte.PreviousDayTariff AS ChangeOnPreviousDate
FROM
	cte;



/*
 * Optional Advanced section
 */
-- There is a more explicit way of writing a window specification using the RANGE or ROWS clause,for example
SELECT
	ps.AdmittedDate
	,ps.Tariff
	,ROW_NUMBER() OVER (ORDER BY ps.AdmittedDate) AS RowIndex
	,SUM(ps.Tariff) OVER (	ORDER BY ps.AdmittedDate RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTariff
FROM
	PatientStay ps
WHERE
	ps.Hospital = 'Oxleas'
	AND ps.Ward = 'Dermatology'
ORDER BY
	ps.AdmittedDate;
