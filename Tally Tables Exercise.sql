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

-- UNION approaches

-- Recursive CTE approach


-- Tally table approach

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
	, '***' AS ZeroEstimate
	, '***' AS AverageEstimate
	, '***' AS LagAdmisssions
	, '***' AS LeadAdmisssions
	, '***' AS NeighbourEstimate
FROM cte LEFT JOIN #PatientAdmission pa ON cte.[AdmittedDate] = pa.[AdmittedDate]
ORDER BY cte.[AdmittedDate];

