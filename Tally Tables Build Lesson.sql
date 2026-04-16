/*
 Creating a Tally Table
 Many databases, including the course database, may already have a tally table you can use.
 Before we see how to implement this, let's remind ourselves about UNION and CROSS JOIN
 */

-- A UNION stacks one table on another (like a VSTACK in Excel)
SELECT
	'A' AS MyColumn
UNION
SELECT
	'B'
UNION
SELECT
	'C';

/*
 CROSS JOIN creates a row for every combination of the left and right tables.
 There is no ON clause since no need for a matching column
 */
WITH TableAB (a, b) AS 
(
SELECT
	*
FROM
( VALUES 
	('a1', 'b1')
	, ('a2', 'b2')
	) ab (A	, B))
, TableXY (x, y) AS 
(
SELECT
	*
FROM
( VALUES 
	('x1', 'y1')
	,('x2', 'y2')
	) XY (x	, y)
)
SELECT
	*
FROM
	TableAB
CROSS JOIN TableXY;


/*
One way to build a tally tables  is to use a recursive CTE
This returns a Tally table with 10,000 rows
E1 is a table of 10 rows created by UNION of 10 SELECT statements 
E2 is a CROSS JOIN of E1 with itself so has 10 x 10 or 1000 rows
E4 is a CROSS JOIN of E2 with itself so has 100 x 100 or 10,000 rows
ROW_NUMBER() is Window function that generates an index 1,2,3,... over the 10,000 rows of E4
ROW_NUMBER() must have an ORDER BY clause 
If we need fewer than 10,000 rows the final statement use a WHERE cluase
*/

WITH E1(N) AS (
	    SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
	    UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
	)
	, E2(N) AS ( SELECT 1 FROM E1 a CROSS JOIN E1 b)
	, E4(N) AS ( SELECT 1 FROM E2 a CROSS JOIN E2 b)
	, FinalTally(N) AS ( SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM E4)
SELECT
	N
FROM
	FinalTally
WHERE
	N <= 1000
ORDER BY
	N;
