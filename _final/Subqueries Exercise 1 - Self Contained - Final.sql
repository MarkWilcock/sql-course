/*
Subqueries Exercise 1 - Final

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

/*
 * Secton 1 - self contained queries
 */

-- Which property types have not been sold in the Ranmere Street? (use a self-contained subquery to answer this)

SELECT
	ptl.PropertyTypeName
FROM
	PropertyTypeLookup ptl
	-- complete the query below here
WHERE ptl.PropertyTypeCode NOT IN (SELECT DISTINCT pp.propertyType FROM PricePaidSW12 pp WHERE pp.Street = 'Ranmere Street');


-- List properties sold for more than the average price
-- Use a simple subquery in the WHERE clause and in the column list
SELECT
	pp.TransactionID
	,pp.TransactionDate 
	,pp.Price 
	,pp.PropertyType
	,pp.PAON
	,pp.Street 
	,(SELECT AVG(pp.Price) FROM PricePaidSW12 pp WHERE pp.Street = 'Ranmere Street') AS AveragePriceInRanmereStreet
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'Ranmere Street'	
	AND pp.Price >
      (
	SELECT AVG(pp.Price) FROM PricePaidSW12 pp WHERE pp.Street = 'Ranmere Street' 
)
ORDER BY pp.Price ;

-- Alternatively,we can use a  CTE to make shorter and more readable
WITH ranmereSales
AS (
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
	pp.Street = 'Ranmere Street')
SELECT
	*
FROM
	ranmereSales
WHERE
	ranmereSales.Price > (SELECT AVG(ranmereSales.Price) FROM ranmereSales);

-- Optional - Advanced task
-- Calculate the price difference over the average price
-- Use a simple subquery in the WHERE clause and in the column list
WITH ranmereSales
AS (
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
	pp.Street = 'Ranmere Street')
SELECT
	ranmereSales.TransactionID
	,ranmereSales.TransactionDate 
	,ranmereSales.PropertyType
	,ranmereSales.PAON
	,ranmereSales.Street 
	,ranmereSales.Price
	,(SELECT AVG(ranmereSales.Price) FROM ranmereSales ) AS AveragePriceOnCambrayRoad
	,ranmereSales.Price - (SELECT AVG(ranmereSales.Price) FROM ranmereSales) AS AmountOverAveragePriceOnCambrayRoad
FROM
	ranmereSales
WHERE
	ranmereSales.Price > (SELECT AVG(ranmereSales.Price) FROM ranmereSales);


-- Do this for all sales rather than a single street
SELECT
	pp.TransactionDate
	,pp.PAON
	,pp.SAON
	,pp.Price
	,(	SELECT AVG(CAST(p1.Price AS BIGINT)) FROM PricePaidSW12 p1 ) AS AveragePriceInSW12
FROM
	PricePaidSW12 pp
WHERE
	pp.Price >
	(SELECT AVG(CAST(Price AS BIGINT)) FROM 	PricePaidSW12)
ORDER BY
	pp.Price;
