/*
SQL Course - CASE Lesson
We can add a new calculated column and use CASE to switch between options.
*/

/*
The simple CASE form matches an exact value.
In this case we want to create a column that groups hospitals.
There is a final ELSE clause as a catch-all, for any hospital that does not meet any of the WHEN values.
*/

SELECT
    ps.PatientId
    ,ps.Hospital
    ,CASE ps.Hospital
        WHEN 'PRUH' THEN 'Trust A'
        WHEN 'Oxleas' THEN 'Trust A'
        ELSE 'Trust B'
    END AS Trust
    ,ps.Ward
FROM
    dbo.PatientStay ps
ORDER BY
    ps.PatientId;

/*

The searched CASE form checks a condition.
In this case we want to group wards based on some complex logic.
This uses a 'match first' approach - the order of the WHEN THEN clauses may matter.
*/

SELECT
    ps.PatientId
    ,ps.Hospital
    ,ps.Ward
    ,CASE
        WHEN ps.Ward LIKE '%Surgery' THEN 'Surgical'
        WHEN ps.Ward IN ('Accident', 'Emergency', 'Emergency Surgery') THEN 'A&E'
        WHEN ps.Tariff > 8 THEN 'ICU'
        ELSE 'General'
    END AS WardType
FROM
    dbo.PatientStay ps
ORDER BY
    WardType;

/*
Count rows where a condition is true using SUM with CASE.
Each row scores 1 if the condition is true, 0 if not — SUM then adds those scores up.
Note the calculation uses 100.0 (not 100) to ensure the division gives a decimal result rather than a whole number.
*/

-- The row-by-row query uses CASE  to create a column with a value of 1 if the patient is in a surgical ward, 0 otherwise.

SELECT
    ps.Hospital
    ,ps.Ward
    ,CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END AS IsPatientInSurgicalWard
FROM
    dbo.PatientStay ps
ORDER BY
    ps.PatientID;

-- This query groups by hospital and sums those 0 or 1 values in the calculated column 
-- This has the effect of counting patients in each hospital that meet the CASE ... THEN 1  condition

SELECT
    ps.Hospital
    ,COUNT(*) AS NumberOfPatients
    ,SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END) AS NumberOfPatientsInSurgery
    ,(100.0 * SUM(CASE WHEN ps.Ward LIKE '%Surgery' THEN 1 ELSE 0 END)) / COUNT(*) AS PercentageOfPatientsInSurgery
FROM
    dbo.PatientStay ps
GROUP BY
    ps.Hospital
ORDER BY
    ps.Hospital;


/*
Optional advanced section

Work out which financial year a patient was admitted in.
This assumes the financial year starts on 1st March.
For example, a patient admitted in January 2024 is in FY-2023-2024,
and a patient admitted in March 2024 is in FY-2024-2025.
*/

SELECT
    ps.PatientId
    ,ps.AdmittedDate
    ,CASE
        WHEN DATEPART(MONTH, ps.AdmittedDate) >= 3
            THEN CONCAT('FY-', DATEPART(YEAR, ps.AdmittedDate), '-', DATEPART(YEAR, ps.AdmittedDate) + 1)
        ELSE CONCAT('FY-', DATEPART(YEAR, ps.AdmittedDate) - 1, '-', DATEPART(YEAR, ps.AdmittedDate))
    END AS FinancialYear
FROM
    dbo.PatientStay ps
WHERE
    ps.Hospital = 'PRUH'
ORDER BY
    ps.AdmittedDate
    ,ps.PatientId;
