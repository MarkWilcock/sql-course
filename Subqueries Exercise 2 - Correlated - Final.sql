/*
Subqueries Exercise 2 - Correlated - Final

This exercise will use two related tables
* PricePaidSW12 - sales of properties in London SW12 from 1995 to 2019. 
* PropertyTypeLookup - a lookup table on the PropertyType column of PricePaidSW12.  This contains a one letter code e.g. 'D'.  
  The PropertyTypeLookup has a column PropertyTypeCode with matching values and a column PropertyTypeName with the description e.g. 'Detached'

In this example we will focus sales in  a particular street,Ranmere Street
*/

-- List properties sold in Ranmere Street
SELECT
	pp.TransactionID
	,pp.TransactionDate 
	,pp.Price 
	,pp.PropertyType
	,pp.PAON
	,pp.Street 
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'Ranmere Street'

-- Get the average price of properties sold in Ranmere Street
SELECT
	AVG(pp.Price)
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'Ranmere Street';


-- Which property types have not been sold in Ranmere Street? (use a correlated subquery to answer this)

SELECT
	ptl.PropertyTypeName
FROM
	PropertyTypeLookup ptl
	-- complete the query below here
WHERE NOT EXISTS (SELECT * FROM PricePaidSW12 pp WHERE pp.Street = 'Ranmere Street' AND pp.PropertyType = ptl.PropertyTypeCode);

-- List properties sold for more than the avearage price in the street -  for each and every street in SW12
-- Use correlated subqueries both in the column list and in the WHERE clause
SELECT
	pp.TransactionDate
	,pp.PAON
	,pp.SAON
	,pp.Price
	,pp.Street
	,( SELECT AVG(cast(p1.Price AS BIGINT)) FROM PricePaidSW12 p1 WHERE p1.street = pp.Street) AS AveragePriceOnStreet
FROM PricePaidSW12 pp
WHERE pp.Price >
(
    SELECT AVG(CAST(p2.Price AS BIGINT))
    FROM PricePaidSW12 p2
    WHERE p2.Street = pp.Street
)
ORDER BY pp.Street,pp.Price;


-- use a CTE to simplify and shorten the query above
WITH streetCTE
AS (
SELECT
	pp.TransactionDate
	,pp.PAON
	,pp.SAON
	,pp.Price
	,pp.Street
	,(SELECT AVG(cast(p1.Price AS BIGINT))
               FROM PricePaidSW12 p1
               WHERE p1.street = pp.Street
           ) AS AveragePriceInStreet
    FROM PricePaidSW12 pp)
SELECT *
FROM streetCTE
WHERE streetCTE.Price > streetCTE.AveragePriceInStreet
ORDER BY streetCTE.Price;

