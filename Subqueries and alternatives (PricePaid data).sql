/*
SQL Course
Subqueries Lesson 3
Compare IN  EXISTS and other methods of finding missing values
Land Registry Price Paid dataset

Question: which postcodes in SW12 have not had a single property sale since the Land Registry records begin?
Table PostcodeSW12,from the ONS,contains every postcode in SW12
The pcds column matches the PricePaidSW12.PostCode column. pcds is a unique key.
This is the post code format with a single space between the two parts.
The PostcodeSW12 contains lots of other attributes for the post code e.g. lat and long
*/

-- sample the data

SELECT TOP 10 * FROM PostcodeSW12;

SELECT TOP 10 * FROM PricePaidSW12;


/*
NOT IN self-contained query approach
*/
SELECT pcds FROM PostcodeSW12 c WHERE c.pcds NOT IN ( SELECT DISTINCT PostCode FROM PricePaidSW12 );

/*
NOT EXISTS correlated query approach
*/
SELECT
    pcds
FROM PostcodeSW12 c
WHERE NOT EXISTS
    (SELECT 1 FROM PricePaidSW12 WHERE PostCode = c.pcds);

  /*
LEFT JOIN approach

The LEFT JOIN returns all rows from the PostcodeSW12 table and will return a NULL value for any column on PricePaidSW12
where there is no match.
The query filters rows where a PricePaidSW12 column IS NULL and so returns the postcode without sales
*/
SELECT
    c.pcds
FROM PostcodeSW12 c
    LEFT JOIN PricePaidSW12 p ON c.pcds = p.PostCode
WHERE p.Price IS NULL;

/*
EXCEPT approach
*/
SELECT
	pcds
FROM
	PostcodeSW12
EXCEPT
SELECT
	DISTINCT p.PostCode
FROM
	PricePaidSW12 p;

-- This statement suggested by a student
SELECT pc.pcds
       ,(
           SELECT COUNT(*)FROM PricePaidSW12 pp WHERE pp.PostCode = pc.pcds
       ) AS NumberOfSales
       ,(
           SELECT AVG(PP.Price)FROM PricePaidSW12 pp WHERE pp.PostCode = pc.pcds
       ) AS AveragePrice
FROM PostcodeSW12 pc
ORDER BY NumberOfSales DESC;

-- more usual formulation with join
SELECT
	pc.pcds
	,COUNT(*) AS NumberOfSales
	,AVG(pp.Price) AS AveragePrice
FROM
	PostcodeSW12 pc
INNER JOIN PricePaidSW12 pp ON pc.pcds = pp.PostCode
GROUP BY
	pcds
ORDER BY
	NumberOfSales DESC;