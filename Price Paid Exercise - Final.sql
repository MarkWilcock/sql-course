/*
Land Registry Case Study
This uses public data of property sales in England from the Land Registry at https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads
The data has been filtered to properties in the London SW12 postcode  
*/
-- How many sales in total? 
SELECT
	COUNT(*)
FROM
	PricePaidSW12;

/*
How many sales in each property type?
Order the rows in the result set by number of sales (highest first)
*/
SELECT 
	p.PropertyType
	, COUNT(*) NumberOfSales
FROM
	PricePaidSW12 p
GROUP BY
	p.PropertyType
ORDER BY
	NumberOfSales DESC;

/*
How many sales in each year?
Since the year of the sales is not a column in the table, calculate it with the YEAR() function
Order the rows in the result set by Year (earliest first)
*/
SELECT 	YEAR('2022-09-21') AS TheYear;

SELECT
	TOP 5 YEAR(P.TransactionDate) YearSold
FROM
	PricePaidSW12 p;

SELECT 
	YEAR(p.TransactionDate) TheYear
	, COUNT(*) NumberOfSales
FROM
	PricePaidSW12 p
GROUP BY
	YEAR(p.TransactionDate)
ORDER BY
	YEAR(p.TransactionDate);

-- What was the total market value IN £ Millions of all the sales each year?
SELECT
	YEAR(p.TransactionDate) TheYear
	, COUNT(*) "Number Of Sales"
	, SUM(p.Price) / 1000000.0 AS TotalMarketValue
	-- note the use of a decimal number to implicitly cast as float to avoid integer division
FROM
	PricePaidSW12 p
GROUP BY
	YEAR(p.TransactionDate)
ORDER BY
	YEAR(p.TransactionDate);

-- What are the earliest and latest dates of a sale?
SELECT
	MIN(p.TransactionDate) EarliestDate
	, MAX(p.TransactionDate) LatestDate
FROM
	PricePaidSW12 p;

-- How many different property types are there?  

SELECT
	DISTINCT p.PropertyType
FROM
	PricePaidSW12 p;

SELECT
	p.PropertyType
	, COUNT(*) AS NumberOfSales
FROM
	PricePaidSW12 p
GROUP BY
	p.PropertyType
ORDER BY
	p.PropertyType;

-- And how many different values of IsNew, Duration?
SELECT
	p.Duration
	, COUNT(*) AS NumberOfSales
FROM
	PricePaidSW12 p
GROUP BY
	p.Duration;

SELECT
	p.IsNew
	, COUNT(*) AS NumberOfSales
FROM
	PricePaidSW12 p
GROUP BY
	p.IsNew;

-- List all the sales in 2018 between £400,000 and £500,000 in Cambray Road (a street in SW12)
SELECT
	p.TransactionDate
	, p.Price
	, p.PropertyType
	, p.PostCode
	, p.SAON
	, p.Street
FROM
	PricePaidSW12 p
WHERE
	p.Street = 'CAMBRAY ROAD'
	AND YEAR(p.TransactionDate) = 2018	-- performance note: this becomes a non SARGABLE query
	AND p.Price
      BETWEEN 400000 AND 500000;

/*
1.  List the 25 latest sales in Ormeley Road with the following fields: TransactionDate, Price, PostCode, PAON 
2. Join on PropertyTypeLookup to get the PropertyTypeName
3.  Use a CASE statement for PropertyTypeName column
*/
	SELECT
	TOP 25 p.TransactionDate
	, p.Price
	, p.PostCode
	, p.PAON
	, pt.PropertyTypeName
FROM
	PricePaidSW12 p
LEFT JOIN PropertyTypeLookup pt ON p.PropertyType = pt.PropertyTypeCode
WHERE
	p.Street = 'ORMELEY ROAD'
ORDER BY
	p.TransactionDate DESC;


SELECT
	TOP 25
       p.TransactionDate
	, p.Price
	, p.PostCode
	, p.PAON
	, CASE
		p.PropertyType
           WHEN 'T' THEN 'Terraced'
		WHEN 'D' THEN 'Detached'
		WHEN 'S' THEN 'Semi'
		WHEN 'O' THEN 'Other'
		WHEN 'F' THEN 'Flat'
		ELSE '?'
	END PropertyTypeName
FROM
	PricePaidSW12 p
WHERE
	p.Street = 'ORMELEY ROAD'
ORDER BY
	p.TransactionDate DESC;

/*
List properties that have been sold three times or more in the last ten years.  
Assume that a property is uniquely identified by the combination of the postcode, PAON and SAON fields.
*/
	-- Note  that we can get today's date and a date 10 years ago with the following statements
SELECT 	CURRENT_TIMESTAMP;

SELECT 	CAST(CURRENT_TIMESTAMP AS DATE);

SELECT	DATEADD(YEAR, -10, CAST(CURRENT_TIMESTAMP AS DATE));

-- List properties
SELECT
	p.PostCode
	, p.PAON
	, p.SAON
	, COUNT(*) NumberOfSales
FROM
	PricePaidSW12 p
WHERE
	p.TransactionDate >= DATEADD(YEAR, -10, CAST(CURRENT_TIMESTAMP AS DATE))
GROUP BY
	p.PostCode
	, p.PAON
	, p.SAON
HAVING
	COUNT(*) >= 3
ORDER BY
	NumberOfSales DESC;  -- note that  we can reference NumberOfSales here

/*
Count properties by the number of times sold 
How many properties were sold once, twice, three times etc.
This is a two step process
(1) List properties sold in the last 10 years - columns required are Postcode, PAON, SAON and NumberOfSales
(2) Count the properties grouping by the NumberOfSales
*/
-- Option 1: Use a subquery
SELECT
	prop.NumberOfSales
	, COUNT(*) AS PropertyCount
FROM
	(
	SELECT
		p.PostCode
		, p.PAON
		, p.SAON
		, COUNT(*) NumberOfSales
	FROM
		PricePaidSW12 p
	GROUP BY
		p.PostCode
		, p.PAON
		, p.SAON
) prop
GROUP BY
	prop.NumberOfSales
ORDER BY
	prop.NumberOfSales DESC;

-- Option 1A: Use a subquery and a calculated Address column for more readability
SELECT
	prop.NumberOfSales
	, COUNT(*) AS PropertyCount
FROM
	(
	SELECT
		p2.PropertyAddress
		, COUNT(*) NumberOfSales
	FROM
		(
		SELECT
			CONCAT(p.PAON, ',', p.SAON, ','	, p.Street, ','	, p.PostCode) AS PropertyAddress
		FROM
			PricePaidSW12 p
    ) p2
	GROUP BY
		p2.PropertyAddress
) prop
GROUP BY
	prop.NumberOfSales
ORDER BY
	prop.NumberOfSales DESC;

-- Option 2: Use WITH and a CTE
WITH prop
AS (
SELECT
	p.PostCode
	, p.PAON
	, p.SAON
	, COUNT(*) NumberOfSales
FROM
	PricePaidSW12 p
GROUP BY
	p.PostCode
	, p.PAON
	, p.SAON)
SELECT
	prop.NumberOfSales
	, COUNT(*) PropertyCount
FROM
	prop
GROUP BY
	prop.NumberOfSales
ORDER BY
	prop.NumberOfSales DESC;

-- Option 3: Use a temp table(Microsoft SQL only)
DROP TABLE IF EXISTS #tempPP;

SELECT
	p.PostCode
	, p.PAON
	, p.SAON
	, COUNT(*) NumberOfSales
INTO
	#tempPP
FROM
	PricePaidSW12 p
GROUP BY
	p.PostCode
	, p.PAON
	, p.SAON;

SELECT
	#tempPP.NumberOfSales
	, COUNT(*) PropertyCount
FROM
	#tempPP
GROUP BY
	#tempPP.NumberOfSales
ORDER BY
	#tempPP.NumberOfSales DESC;

-- Which properties were flipped more than 8 times?
WITH prop
AS (
SELECT
	CONCAT(p.PAON, ',', p.SAON	, ','	, p.Street	, ',', p.PostCode) AS PropertyAddress
FROM
	PricePaidSW12 p
)
SELECT
	prop.PropertyAddress
	, COUNT(*) NumberOfSales
FROM
	prop
GROUP BY
	prop.PropertyAddress
HAVING
	COUNT(*) > 8
ORDER BY
	COUNT(*) DESC;
