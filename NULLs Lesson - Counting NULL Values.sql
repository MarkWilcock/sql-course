/*
NULLs Lesson - Counting NULL Values 
Summarise (GROUP BY) and Count the number of NULL values in a column
Uses Land Registry pricePaid data
*/
SELECT
	TOP 10  *
FROM
	PricePaidSW12 pp;

SELECT
	COUNT(*) NumberOfSales
FROM
	PricePaidSW12 pp;

SELECT
	COUNT(*) NumberOfSales
FROM
	PricePaidSW12 pp
WHERE
	Locality IS NULL;

SELECT
	TOP 10 pp.TransactionID
	,pp.PostCode
	,pp.Locality
	,CASE
		WHEN pp.Locality IS NULL THEN 0
		ELSE 1
	END AS LocalityNumber
FROM
	PricePaidSW12 pp;

SELECT
	pp.PropertyType
	,SUM(CASE WHEN pp.Locality IS NULL THEN 0 ELSE 1 END) AS LocalityCount
	,Count(*) AS NumberofSales
FROM
	PricePaidSW12 pp
GROUP BY
	pp.PropertyType;

SELECT
	YEAR(pp.TransactionDate) AS YEAR
	,SUM(CASE WHEN pp.Locality IS NULL THEN 0 ELSE 1 END) AS LocalityCount
	,Count(*) AS NumberofSales
FROM
	PricePaidSW12 pp
GROUP BY
	YEAR(pp.TransactionDate)
ORDER BY
	YEAR(pp.TransactionDate);
