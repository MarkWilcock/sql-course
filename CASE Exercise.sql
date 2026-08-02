/*
SQL Course - CASE Exercise
*/

-- Simple CASE form:   CASE <column> WHEN <value> THEN <result> ... ELSE <result> END
-- Searched CASE form: CASE WHEN <condition> THEN <result> ... ELSE <result> END

/*
Create a new column HospitalLocation
Kings College and Kingston hospitals are 'Inner', other hospitals are 'Outer'
Use the simple CASE form
*/

SELECT
    ps.PatientId
    ,ps.Hospital
    ,'???' AS HospitalLocation
FROM
    dbo.PatientStay ps
ORDER BY
    ps.PatientId;

/*
Create a new column WardType
Any ward that contains 'Surgery' is 'Surgical', otherwise 'Non Surgical'
Use the searched CASE form
*/

SELECT
    ps.PatientId
    ,ps.Hospital
    ,ps.Ward
    ,'???' AS WardType
FROM
    dbo.PatientStay ps
ORDER BY
    ps.PatientId;

/*
Create a new column DetailsKnown
If the patient's Ethnicity is provided, this has the value 'Yes'.
If the patient's Ethnicity is not recorded, this has the value 'No'.
*/

SELECT
    ps.PatientId
    ,ps.Hospital
    ,ps.Ward
    ,ps.Ethnicity
    ,'???' AS DetailsKnown
FROM
    dbo.PatientStay ps
ORDER BY
    ps.PatientId;

/*
Create a new column PatientTariffGroup
A patient with a Tariff of 7 or more is in the 'High Tariff' group
A patient with a Tariff of 4 or more but below 7 is in the 'Medium Tariff' group
A patient with a Tariff below 4 is in the 'Low Tariff' group

Optional advanced question: how many patients are in each PatientTariffGroup?
*/

SELECT
    ps.PatientId
    ,ps.AdmittedDate
    ,ps.Tariff
    ,'???' AS PatientTariffGroup
FROM
    dbo.PatientStay ps
ORDER BY
    ps.PatientId;
