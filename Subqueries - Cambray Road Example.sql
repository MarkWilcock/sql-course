/*
Subqueries - Cambray Road Example
Which properties on Cambray Road sold for more than the average price for the street
*/

-- List properties sold
SELECT
	*
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'CAMBRAY ROAD';

-- Get the average price
SELECT
	AVG(pp.Price)
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'CAMBRAY ROAD';

-- List properties sold for more than the average price
-- Use a simple subquery in the WHERE clause
SELECT
	pp.TransactionDate
	,pp.PAON
	,pp.SAON
	,pp.Price
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'CAMBRAY ROAD'
	AND pp.Price >
      (
	SELECT	AVG(pp.Price) FROM PricePaidSW12 pp WHERE pp.Street = 'CAMBRAY ROAD' );

-- List only properties sold for more than the average price (again)
-- Use a  CTE to make shorter and more readable
WITH cambraySales
AS (
SELECT
	pp.TransactionDate
	,pp.PAON
	,pp.SAON
	,pp.Price
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'CAMBRAY ROAD')
SELECT
	*
FROM
	cambraySales
WHERE
	cambraySales.Price > (SELECT AVG(cambraySales.Price)FROM cambraySales);

-- Calculate the price difference over the average price
-- Use a simple subquery in the WHERE clause and in the column list
WITH cambraySales
AS (
SELECT
	pp.TransactionDate
	,pp.PAON
	,pp.SAON
	,pp.Price
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'CAMBRAY ROAD')
SELECT
	cambraySales.Price
	,(SELECT AVG(cambraySales.Price) FROM cambraySales ) AS AveragePriceOnCambrayRoad
	,cambraySales.Price - (SELECT AVG(cambraySales.Price) FROM cambraySales) AS AmountOverAveragePriceOnCambrayRoad
FROM
	cambraySales
WHERE
	cambraySales.Price > (SELECT AVG(cambraySales.Price) FROM cambraySales);

-- Do this for all of SW12 rather than a single street
SELECT
	pp.TransactionDate
	,pp.PAON
	,pp.SAON
	,pp.Price
	,(
	SELECT AVG(CAST(p1.Price AS BIGINT)) FROM PricePaidSW12 p1 ) AS AveragePriceInSW12
	,pp.Price - (SELECT AVG(CAST(p1.Price AS BIGINT)) FROM PricePaidSW12 p1 ) AS PriceOverAverageInSW12
FROM
	PricePaidSW12 pp
WHERE
	pp.Price >
	(SELECT AVG(CAST(Price AS BIGINT)) FROM 	PricePaidSW12)
ORDER BY
	pp.Price;


-- Do this for each street in SW12
-- Note this is a correlated subqueries both in the column list and in the WHERE clause
SELECT
	pp.TransactionDate
	,pp.PAON
	,pp.SAON
	,pp.Price
	,pp.Street
	,(
           SELECT AVG(cast(p1.Price AS BIGINT))
           FROM PricePaidSW12 p1
           WHERE p1.street = pp.Street
       ) AS AveragePriceOnStreet
       ,Price -
       (
           SELECT AVG(cast(p1.Price AS BIGINT))
           FROM PricePaidSW12 p1
           WHERE p1.street = pp.Street
       ) AS PriceOverAverageOnStreet
FROM PricePaidSW12 pp
WHERE pp.Price >
(
    SELECT AVG(CAST(p2.Price AS BIGINT))
    FROM PricePaidSW12 p2
    WHERE p2.Street = pp.Street
)
ORDER BY pp.Price;


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

-- END

/*
 * Oracle version - does not need to cast to bigint
SELECT 
	pp.TransactionDate,
	pp.PAON,
	pp.SAON,
	pp.Price,
	(SELECT AVG(p1.Price) FROM PricePaidSW12 p1) AS AveragePriceInSW12,
	pp.Price - (SELECT AVG(p1.Price) FROM PricePaidSW12 p1) as PriceOverAverageInSW12
FROM PricePaidSW12 pp
WHERE pp.Price > (SELECT AVG(Price)FROM PricePaidSW12)
ORDER BY pp.Price;
*/

/*
 * Oracle version - does not need to cast to bigint

SELECT pp.TransactionDate,
       pp.PAON,
       pp.SAON,
       pp.Price,
       pp.Street,
       (SELECT AVG(p1.Price) FROM PricePaidSW12 p1 WHERE p1.street = pp.Street) AS AveragePriceOnStreet,
       Price - (SELECT AVG(p1.Price) FROM PricePaidSW12 p1 WHERE p1.street = pp.Street) AS PriceOverAverageOnStreet
FROM PricePaidSW12 pp
WHERE pp.Price >
(
    SELECT AVG(p2.Price)
    FROM PricePaidSW12 p2
    WHERE p2.Street = pp.Street
)
ORDER BY pp.Price;
 */
