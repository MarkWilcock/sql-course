# Claude.md

This repo contains lessons and exercises to learn SQL.

When reviewing or improving the SQL or comments, write in plain English and avoid technical jargon. The goal is to make the SQL and comments easy to understand for someone who is new to SQL.

When formatting the SQL, use the following rules:

- Uppercase for SQL keywords (e.g., SELECT, FROM, WHERE).
- Indent column names in the SELECT statement by four spaces.
- Put column names on separate lines in the SELECT statement.
- Put commas between column names at the beginning of the line
- Put the SELECT, FROM, WHERE, HAVING, GROUP BY, and ORDER BY clauses on separate lines.
- Finish the statement with a semi-colon.

Here is an example of well formatted SQL.

```sql
SELECT
    ps.PatientId
    ,ps.AdmittedDate
    ,ps.DischargeDate
    ,ps.Hospital
    ,ps.Ward
    ,DATEDIFF(DAY, ps.AdmittedDate, ps.DischargeDate) + 1 AS LengthOfStay
FROM
    PatientStay ps
WHERE
    ps.Hospital IN ('Oxleas', 'PRUH')
    AND ps.AdmittedDate BETWEEN '2024-02-01' AND '2024-02-28'
    AND ps.Ward LIKE '%Surgery'
ORDER BY
    ps.AdmittedDate DESC
    ,ps.PatientId DESC;
```
