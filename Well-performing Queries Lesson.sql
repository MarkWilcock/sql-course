/*
Mark Wilcock
June 2024

Guidelines for well-performing SQL queries
Note: Best to use SSMS so can see  query plans (DBeaver community edition does not seem to allow this)

This lesson uses several tables in the LearnSQL database

The PricePaidSW12 table has 
* a PK on TransactionID,
* FKs on PostCode and PropertyType 
* additional indexes on Postcode and TransactionDate

The PostCodeSW12 has a PK on the pcds column.
This is the postcode format that matches the PostCode column in PricePaidSW12 table
*/

/*
Indexes speed up data retrieval.  Put indexes on columns in JOIN / WHERE / ORDER BY clauses
Compare the statistics and the estimated query plan with the WHERE clause 
on columns that have an index e.g. Postcode  and columns that do not e.g. PAON
*/

-- clear the buffer cache so that the statistics are accurate
DBCC DROPCLEANBUFFERS;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT 
	pps.TransactionID
	,pps.TransactionDate
	,pps.Price
	,pps.PostCode
	,pps.PAON
	,pps.SAON
	,pps.Street
FROM
	PricePaidSW12 pps
	--WHERE pps.PAON = '52';
WHERE
	pps.Postcode = 'SW12 0EN';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
/*
Avoid SELECT *,list the columns needed
*/
DBCC DROPCLEANBUFFERS;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT 
	*
FROM PricePaidSW12 pps
--WHERE pps.PAON = '52';
WHERE pps.Postcode = 'SW12 0EN';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
/*
Filter data as much as possible and as early as possible
e.g. if creating a temp table for subsequent operations
*/
DBCC DROPCLEANBUFFERS;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

DROP TABLE IF EXISTS #tempPricePaid;

SELECT 
	pps.TransactionID
	,pps.TransactionDate
	,pps.Price
	,pps.PostCode
	,pps.PAON
	,pps.SAON
	,pps.Street 
INTO
	#tempPricePaid
FROM
	PricePaidSW12 pps
WHERE
	pps.Postcode = 'SW12 0EN';

-- do some futher processing on the filtered temp table
SELECT 
	tp.TransactionID,
	tp.TransactionDate,
	tp.Price, 
	CONCAT(tp.PAON,tp.SAON,tp.Street,tp.PostCode) AS Address
FROM  #tempPricePaid tp
ORDER BY tp.TransactionDate;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
/*
In a subquery,use EXISTS or a JOIN codition rather than IN

In these  queries we want to find sales of properties in postcodes in the  most deprived part  of the area
according to the imd column of the PostCodeSW12 table
imd (Index of Multiple Deprivation) is a rank (1 through 32844) score  with 1 being the most deprived and 32844 being the least deprived

*/
-- Example of a subquery that uses IN
DBCC DROPCLEANBUFFERS;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT 
	pps.TransactionID
	,pps.TransactionDate
	,pps.Price
	,pps.PostCode
	,pps.PAON
	,pps.SAON
	,pps.Street
FROM
	PricePaidSW12 pps
WHERE pps.Postcode IN (SELECT DISTINCT pcds FROM PostcodeSW12 where imd <=10000)

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- Replace IN with EXISTS
DBCC DROPCLEANBUFFERS;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT 
	pps.TransactionID
	,pps.TransactionDate
	,pps.Price
	,pps.PostCode
	,pps.PAON
	,pps.SAON
	,pps.Street
FROM
	PricePaidSW12 pps
WHERE EXISTS (SELECT 1 FROM PostcodeSW12 pc where pc.imd <=10000 and pc.pcds = pps.PostCode)

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- Replace IN with a join
DBCC DROPCLEANBUFFERS;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT 
	pps.TransactionID
	,pps.TransactionDate
	,pps.Price
	,pps.PostCode
	,pps.PAON
	,pps.SAON
	,pps.Street
FROM PricePaidSW12 pps
INNER JOIN PostcodeSW12 pc ON pc.pcds = pps.PostCode
WHERE pc.imd <= 10000

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

/*
Ensure that a query is SARGable (Search ARGument)able
e.g. Avoid functions in a where clause which means that the optimiser cannot use an index
*/

-- This query is not SARGable because the YEAR function wraps TransactionDate
DBCC DROPCLEANBUFFERS;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT 
	pps.TransactionID
	,pps.TransactionDate
	,pps.Price
	,pps.PostCode
	,pps.PAON
	,pps.SAON
	,pps.Street
FROM PricePaidSW12 pps
WHERE YEAR(pps.TransactionDate) = 1995

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- This query is SARGable
DBCC DROPCLEANBUFFERS;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT 
	pps.TransactionID
	,pps.TransactionDate
	,pps.Price
	,pps.PostCode
	,pps.PAON
	,pps.SAON
	,pps.Street
FROM PricePaidSW12 pps
WHERE pps.TransactionDate BETWEEN '1995-01-01' AND '1995-12-31'

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

/*
Use INNER JOIN if possible e.g. there is data integrity constraing on the join columns
*/

/*
Never use cursors.  use set based operations instead.
*/
