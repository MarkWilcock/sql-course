/*
 * Tally Tables Exercise

 * The temporary table, #PatientAdmission, has values for dates between the 1st and 8th January 2026 inclusive
 * But not all dates are present

AI prompt to hep get started:

 Act as a SQL expert.   
 A table PatientAdmission with columns AdmittedDate DATE and  NumAdmissions INT  
 should have rows with continuous dates from the earliest date (say 1 Jan 2026) and the latest date (say 31 Dec 2026) 
 There should be no gaps. how do I list any gaps
 I have a Tally table with column N with values between 1 and 10000.  Please use that in your response
 */

DROP TABLE IF EXISTS #PatientAdmission;
CREATE TABLE #PatientAdmission (AdmittedDate DATE, NumAdmissions INT);
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2026-01-01', 50);
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2026-01-02', 60);
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2026-01-03', 40);
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2026-01-05', 20);
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2026-01-07', 60);
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2026-01-08', 50);
SELECT * FROM #PatientAdmission;

/*
This task suggest three ways to create a table of contiguous dates for the period
 (1) Use the UNION clause
 (2) Use a recursive CTE
 (3) Use  the tally table
*/

-- Two UNION approaches
;
WITH cte (AdmittedDateString) AS
(SELECT  '2026-01-01'
UNION SELECT '2026-01-02'
UNION SELECT '2026-01-03'
UNION SELECT '2026-01-04'
UNION SELECT '2026-01-05'
UNION SELECT '2026-01-06'
UNION SELECT '2026-01-07'
UNION SELECT '2026-01-08')
select CAST(AdmittedDateString AS Date) AS AdmittedDate from CTE;

SELECT  DATEFROMPARTS(2026, 1, 1) AS AdmittedDate
UNION SELECT DATEFROMPARTS(2026, 1, 2)
UNION SELECT DATEFROMPARTS(2026, 1, 3)
UNION SELECT DATEFROMPARTS(2026, 1, 4)
UNION SELECT DATEFROMPARTS(2026, 1, 5)
UNION SELECT DATEFROMPARTS(2026, 1, 6)
UNION SELECT DATEFROMPARTS(2026, 1, 7)
UNION SELECT DATEFROMPARTS(2026, 1, 8);

-- Recursive CTE approach

WITH cte (AdmittedDate) AS
(
	SELECT  DATEFROMPARTS(2026, 1, 1)
	UNION ALL
	SELECT DATEADD(DAY, 1, AdmittedDate) from cte
	where cte.AdmittedDate < DATEFROMPARTS(2026, 1, 8)
)
SELECT * FROM cte;

-- Tally table approach
WITH cte ([AdmittedDate]) AS
(SELECT DATEADD(DAY, N-1, DATEFROMPARTS(2026, 1, 1))
FROM Tally
WHERE N <= 8)  -- DATEDIFF(DAY, DATEFROMPARTS(2026, 1, 1), DATEFROMPARTS(2026, 1, 8)) + 1)
SELECT cte.AdmittedDate FROM cte ORDER BY cte.AdmittedDate

/*
 The next tasks create a column with the actual value of patient admission on dates where recorded or estimates the patient admissions on missing dates
 (1) Add a column, ZeroEstimate, calculate as 0
 (2) Add a column, AverageEstimate,  calculate as the  average value for the entire period
 (3) Add a column, NeighbourEstimate,  calculate as the average of the values of the previous and next dates
*/


WITH cte ([AdmittedDate]) AS
(SELECT DATEADD(DAY, N-1, '2026-01-01')
FROM Tally
WHERE N <= 8)  
SELECT 
	cte.[AdmittedDate]
	, COALESCE (pa.NumAdmissions, 0) AS ZeroEstimate
	, COALESCE (pa.NumAdmissions, (SELECT AVG(NumAdmissions) FROM #PatientAdmission)) AS AverageEstimate
	, LAG(pa.NumAdmissions) OVER (ORDER BY cte.AdmittedDate) AS LagAdmisssions
	, LEAD(pa.NumAdmissions) OVER (ORDER BY cte.AdmittedDate) AS LeadAdmisssions
	, COALESCE (pa.NumAdmissions, (LAG(pa.NumAdmissions) OVER (ORDER BY cte.AdmittedDate))/2 + (LEAD(pa.NumAdmissions) OVER (ORDER BY cte.AdmittedDate))/2) AS NeighbourEstimate
FROM cte LEFT JOIN #PatientAdmission pa ON cte.[AdmittedDate] = pa.[AdmittedDate]
ORDER BY cte.[AdmittedDate];

