/*
Combining and Joining Tables

Simplest examples of merging and appending tables

*/
-- View the contents of the tables

SELECT
    fx.CountryCode
    ,fx.CurrencyCode
FROM
    CurrencyFX fx;

SELECT
    g.CountryCode
    ,g.CapitalCity
FROM
    Geography g;

-- An INNER JOIN only keeps rows with matching values in both left and right tables
-- The INNER JOIN is the default JOIN; best to specify exactly what you want
SELECT
    g.CountryCode AS GeoCountryCode
    ,g.CapitalCity
    ,fx.CountryCode AS FxCountryCode
    ,fx.CurrencyCode
FROM
    Geography g
    INNER JOIN CurrencyFX fx ON
    fx.CountryCode = g.CountryCode;


/*
A LEFT JOIN returns all rows from the left table and matching values from the right table.
If there is no matching value from the right table, the result table has NULL values in the columns originating in the right table
*/
SELECT
    g.CountryCode AS GeoCountryCode
    ,g.CapitalCity
    ,fx.CountryCode AS FxCountryCode
    ,fx.CurrencyCode
FROM
    Geography g
    LEFT JOIN CurrencyFX fx ON
    fx.CountryCode = g.CountryCode;

/*
A RIGHT JOIN returns all rows from the right table and matching values from the left table.
If there is no matching value from the left table, the result table has NULL values in the columns originating in the left table
*/
SELECT
    g.CountryCode AS GeoCountryCode
    ,g.CapitalCity
    ,fx.CountryCode AS FxCountryCode
    ,fx.CurrencyCode
FROM
    Geography g
    RIGHT JOIN CurrencyFX fx ON
    fx.CountryCode = g.CountryCode;

/*
<Table B> RIGHT JOIN <Table A> gives same results as <Table A> LEFT JOIN <Table B>
For this reason, right joins are rarely used
*/
SELECT
    g.CountryCode AS GeoCountryCode
    ,g.CapitalCity
    ,fx.CountryCode AS FxCountryCode
    ,fx.CurrencyCode
FROM
    CurrencyFX fx
    RIGHT JOIN Geography g ON
    fx.CountryCode = g.CountryCode;

/*
A FULL JOIN returns all rows from both tables.
If there is no match from either table, the result table has NULL values in the columns originating in the unmatched table

FULL JOIN and FULL OUTER JOIN are exactly the same.
*/
SELECT
    g.CountryCode AS GeoCountryCode
    ,g.CapitalCity
    ,fx.CountryCode AS FxCountryCode
    ,fx.CurrencyCode
FROM
    Geography g
    FULL OUTER JOIN CurrencyFX fx ON
    fx.CountryCode = g.CountryCode;

/*
A CROSS JOIN returns every combination of rows (cartesian product).
*/
SELECT
    g.CountryCode AS GeoCountryCode
    ,g.CapitalCity
    ,fx.CountryCode AS FxCountryCode
    ,fx.CurrencyCode
FROM
    Geography g
    CROSS JOIN CurrencyFX fx;

/*
A semi-join returns the rows from the first table that have matching values in the second table.
It only returns the columns from the first table
There is no SQL SEMI JOIN operator, use IN() or EXISTS() to accomplish a semi-join
*/
SELECT
    g.CountryCode
    ,g.CapitalCity
FROM
    Geography g
WHERE
    g.CountryCode IN
    (SELECT fx.CountryCode FROM CurrencyFX fx);

SELECT
    g.CountryCode
    ,g.CapitalCity
FROM
    Geography g
WHERE
    EXISTS
    (SELECT * FROM CurrencyFX fx WHERE fx.CountryCode = g.CountryCode);

/*
An anti-join returns the rows from the first table that do not have matching values in the second table.
It only returns the columns from the first table
There is no SQL ANTI JOIN operator, use NOT IN() or NOT EXISTS() to accomplish an anti-join
*/

SELECT
    g.CountryCode
    ,g.CapitalCity
FROM
    Geography g
WHERE
    g.CountryCode NOT IN
    (SELECT fx.CountryCode FROM CurrencyFX fx);

SELECT
    g.CountryCode
    ,g.CapitalCity
FROM
    Geography g
WHERE
    NOT EXISTS
    (SELECT * FROM CurrencyFX fx WHERE fx.CountryCode = g.CountryCode);

-- Set operators (UNION, INTERSECT, EXCEPT)

-- UNION appends (or stacks) two queries removing any duplicates
SELECT
    CountryCode
FROM
    Geography g
UNION
SELECT
    CountryCode
FROM
    CurrencyFX fx;

-- UNION ALL appends (or stacks) two queries keeping any duplicates
SELECT
    CountryCode
FROM
    Geography g
UNION ALL
SELECT
    CountryCode
FROM
    CurrencyFX fx;

-- INTERSECT returns rows with values found in both queries
SELECT
    CountryCode
FROM
    Geography g
INTERSECT
SELECT
    CountryCode
FROM
    CurrencyFX fx;

-- This is equivalent to the following INNER JOIN
SELECT
    g.CountryCode
FROM
    Geography g
    INNER JOIN CurrencyFX fx ON
    g.CountryCode = fx.CountryCode;

-- EXCEPT returns the rows from the first query that are not in the second query
-- It provides a similar result to the left anti-join
SELECT
    CountryCode
FROM
    Geography g
EXCEPT
SELECT
    CountryCode
FROM
    CurrencyFX fx;
