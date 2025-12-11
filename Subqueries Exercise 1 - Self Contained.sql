/*
Subqueries Exercise 1 - Self Contained

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

-- Which property types have not been sold in the Ranmere Street? (use a self-contained subquery to answer this)

SELECT
	ptl.PropertyTypeName
FROM
	PropertyTypeLookup ptl
	-- complete the query below here

	
-- List properties sold for more than the average price
-- Use a simple subquery in the WHERE clause and in the column list
SELECT
	pp.TransactionID
	,pp.TransactionDate 
	,pp.Price 
	,pp.PropertyType
	,pp.PAON
	,pp.Street 
	,'write the subquery here' AS AveragePriceInRanmereStreet
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'Ranmere Street'	
	-- add the subquery  here
ORDER BY pp.Price ;


-- Optional - Advanced task
-- Calculate the price difference over the average price
-- Use a simple subquery in the WHERE clause and in the column list

-- Do this for all sales rather than a single street
