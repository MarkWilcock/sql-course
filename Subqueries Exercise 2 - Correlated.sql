/*
Subqueries Exercise 2 - Correlated

A correlated subquery in SQL is a subquery that references columns from the outer query,
It is executed once for each row processed by the outer query. 
The subquery is re-evaluated for every row,making it useful for row-by-row comparisons 
but potentially less efficient than non-correlated subqueries.
*/

/*
List the patient stays in Surgical wards.  (These wards end with the word 'Surgery'.)
Note: You can list patients in all wards apart from surgical wards by using NOT exists
*/

SELECT
	ps.PatientId
	,ps.Hospital
	,ps.Ward
	,ps.Tariff
FROM
	PatientStay ps
WHERE
	EXISTS (
	SELECT 1 FROM dbo.PatientStay sub WHERE Ward LIKE '%Surgery' and ps.PatientId = sub.PatientId
	);


/*
This next tasks use two related tables
* PricePaidSW12 - sales of properties in London SW12 from 1995 to 2019. 
* PropertyTypeLookup - a lookup table on the PropertyType column of PricePaidSW12.  This contains a one letter code e.g. 'D'.  

The PropertyTypeLookup has a column PropertyTypeCode with matching values and a column PropertyTypeName with the description e.g. 'Detached'

The queries focus sales on a particular street,Ranmere Street
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

	
-- List properties sold for more than the average price in the street -  for each and every street in SW12
-- Use correlated subqueries both in the column list and in the WHERE clause
SELECT
	pp.TransactionDate
	,pp.PAON
	,pp.SAON
	,pp.Price
	,pp.Street
	,'write the subquery here' AS AveragePriceOnStreet
FROM PricePaidSW12 pp
-- 'write the subquery here'
ORDER BY pp.Street,pp.Price;


