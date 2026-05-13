# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

This repo contains SQL lessons and exercises for training courses run by Zomalex Limited. There are three courses — Foundation, Intermediate, and Advanced — each designed to run over one or two days. The courses are intended to be run in a classroom environment with a trainer.  These are not self-paced courses.

Ignore the files in the _final subfolder from any analysis or review unless specifically requested. These are completed answer versions of the exercises and should not be used for training or improving the SQL in the lesson and exercise files.

## SQL Dialect

All SQL is written for **Microsoft SQL Server (T-SQL)**. Use T-SQL syntax for date functions (e.g., `DATEDIFF`, `DATEADD`), string functions, and other server-specific features.

## File Naming Conventions

- `[Topic] Lesson.sql` — teaching material with explanations and examples
- `[Topic] Exercise.sql` — exercises for students to complete (some queries are intentionally incomplete)
- `[Topic] Exercise - Final.sql` — completed answer versions of the exercises
- `setup/` — scripts to create temporary tables so lessons can run without access to a permanent database

## Datasets

The SQL Lesson use data from three course databases: LearnSQL, Chinnook and Northwind.

In the LearnSQL database, one teaching table is a fictional hospital dataset. The main table is `PatientStay`, which contains columns: `PatientId`, `AdmittedDate`, `DischargeDate`, `Hospital`, `Ward`, `Tariff`, and `Ethnicity`. A supporting lookup table `DimHospital` joins on the `Hospital` column.

Other tables in LearnSQL database include UK Price Paid (property), football/league tables, airport data, and UK Covid cases.

## Writing Style

When reviewing or improving SQL or comments, write in plain English and avoid technical jargon. The goal is to make the SQL and comments easy to understand for someone who is new to SQL.

## SQL Formatting Rules

- Uppercase for SQL keywords (e.g., SELECT, FROM, WHERE).
- Indent column names in the SELECT statement by four spaces.
- Put column names on separate lines in the SELECT statement.
- Put commas between column names at the beginning of the line. There can be a space after the comma.  For example, both `, ps.AdmittedDate` and `,ps.AdmittedDate` are both acceptable. However, this should be consistently applied within a SQL statement.
- Put the SELECT, FROM, WHERE, HAVING, GROUP BY, and ORDER BY clauses on separate lines.
- Finish the statement with a semi-colon.
- Indent WHERE and other clauses by four spaces.

An example of good SQL formatting is shown below:

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
