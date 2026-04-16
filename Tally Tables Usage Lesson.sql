/*
A tally table, also known as a numbers table or sequence table, is a utility table in SQL 
that contains a sequence of numbers (e.g., 1, 2, 3, ..., N) in a single column. 

This table can be incredibly useful for a variety of tasks in SQL querying and data manipulation.
For example, tally tables can easily generate a sequence of dates, numbers, or time intervals without using recursive queries or loops. This is particularly useful for filling in gaps in data, generating date ranges, or creating bins for histograms.
*/

-- Many databases, including the course database, may already have a tally table you can use.
SELECT * FROM Tally WHERE N < 10;

/*
Exercise: write a SQL statement to find out how many rows are in this table.  Are the values contiguous?
*/

/*
 * Using a Tally Table
 * 
 * We can use a Tally table to create a Dates (Calendar) table
 * This sort of table is essential in analytical databases
 * For example, we use the Tally table  to create a table of dates in 2024.
 */

-- Here is a simple, but not good, way to build a Dates table for 2024
SELECT 
	t.N AS DayOfYear
	,DATEADD(DAY, t.N, '2023-12-31') AS TheDate
FROM 
	Tally t WHERE N <=366
order by 1

-- A better approach is to use SQL variables to set the start and end dates
DECLARE @StartDate DATE;
DECLARE @EndDate DATE;
SELECT @StartDate = DATEFROMPARTS(2024, 1, 1);
SELECT  @EndDate = DATEFROMPARTS(2024, 12, 31);
DECLARE @NumberOfDays INT = DATEDIFF(DAY, @StartDate, @EndDate) + 1;
SELECT 
	DATEADD(DAY, N-1, @StartDate) AS Date
FROM 
	Tally
WHERE
	N <= @NumberOfDays
ORDER BY Date;

	