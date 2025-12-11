/*
CTE Subquery TempTable Comparison 

Calculate the total price of all properties sold in each financial year,which starts on 1st April.
We implement this in three ways using 
- a common table expression (CTE) and the WITH statement
- a simple (self-contained) subquery
- a temporary table
*/

-- We use a CASE statement to create a FinancialYear column
SELECT
	TOP 100
       pp.TransactionID
	,pp.TransactionDate
	,pp.Price
	,DATEPART(YEAR,pp.TransactionDate) AS CalendarYear
	,CASE
		WHEN DATEPART(MONTH,PP.TransactionDate) >= 4 THEN
               CONCAT('FY ',DATEPART(YEAR,pp.TransactionDate),'-',DATEPART(YEAR,pp.TransactionDate) + 1)
		ELSE
               CONCAT('FY ',DATEPART(YEAR,pp.TransactionDate) - 1,'-',DATEPART(YEAR,pp.TransactionDate))
	END FinancialYear
FROM
	PricePaidSW12 pp;


/*
Option 1: Use a common table expression CTE and the WITH statement
*/
WITH sale
AS (
SELECT
	pp.TransactionID
	,pp.TransactionDate
	,pp.Price
	,DATEPART(YEAR,pp.TransactionDate) AS CalendarYear
	,CASE
		WHEN DATEPART(MONTH,PP.TransactionDate) >= 4 THEN
                   CONCAT('FY ',DATEPART(YEAR,pp.TransactionDate),'-',DATEPART(YEAR,pp.TransactionDate) + 1)
		ELSE
                   CONCAT('FY ',DATEPART(YEAR,pp.TransactionDate) - 1,'-',DATEPART(YEAR,pp.TransactionDate))
	END FinancialYear
FROM
	PricePaidSW12 pp)
SELECT
	sale.FinancialYear
	,SUM(sale.Price) / 1000000.0 AS TotalPriceInMillions
FROM
	sale
GROUP BY
	sale.FinancialYear
ORDER BY
	sale.FinancialYear;



/*
Option 2: Use a simple subquery
*/
SELECT sale.FinancialYear,
       SUM(sale.Price) / 1000000.0 AS TotalPriceInMillions
FROM
(
    SELECT pp.TransactionID,
           pp.TransactionDate,
           pp.Price,
           DATEPART(YEAR,pp.TransactionDate) AS CalendarYear,
           CASE
               WHEN DATEPART(MONTH,PP.TransactionDate) >= 4 THEN
                   CONCAT('FY ',DATEPART(YEAR,pp.TransactionDate),'-',DATEPART(YEAR,pp.TransactionDate) + 1)
               ELSE
                   CONCAT('FY ',DATEPART(YEAR,pp.TransactionDate) - 1,'-',DATEPART(YEAR,pp.TransactionDate))
           END FinancialYear
    FROM PricePaidSW12 pp
) sale
GROUP BY sale.FinancialYear
ORDER BY sale.FinancialYear;


/*
Option 3: Use a temporary table
Microsoft T-SQL only
*/

DROP TABLE IF EXISTS #sale;

SELECT
	pp.TransactionID
	,pp.TransactionDate
	,pp.Price
	,DATEPART(YEAR,pp.TransactionDate) AS CalendarYear
	,CASE
		WHEN DATEPART(MONTH,PP.TransactionDate) >= 4 THEN
               CONCAT('FY ',DATEPART(YEAR,pp.TransactionDate),'-',DATEPART(YEAR,pp.TransactionDate) + 1)
		ELSE
               CONCAT('FY ',DATEPART(YEAR,pp.TransactionDate) - 1,'-',DATEPART(YEAR,pp.TransactionDate))
	END FinancialYear
INTO
	#sale
FROM
	PricePaidSW12 pp;

SELECT TOP 25
       *
FROM #sale;

SELECT
	#sale.FinancialYear
	,SUM(#sale.Price) / 1000000.0 AS TotalPriceInMillions
FROM
	#sale
GROUP BY
	#sale.FinancialYear
ORDER BY
	#sale.FinancialYear;

-- END

/*
Oracle version
Option 1: Use a common table expresion CTE and the WITH statement

WITH sale AS (
SELECT 
       pp.TransactionID,
       pp.TransactionDate,
       pp.Price,
       EXTRACT(YEAR FROM pp.TransactionDate) AS CalendarYear,
       CASE
           WHEN EXTRACT(MONTH FROM pp.TransactionDate) >= 4 THEN
               'FY '|| TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate)) || '-' || TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate) + 1 )
           ELSE
               'FY '|| TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate) - 1)  || '-' || TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate))
       END FinancialYear
FROM PricePaidSW12 pp
)
SELECT 
    sale.FinancialYear,
    SUM(sale.Price) /1000000.0 AS TotalPriceInMillions
 FROM sale
 GROUP BY sale.FinancialYear
 ORDER BY sale.FinancialYear;
*/

/*
 Oracle version
SELECT 
       pp.TransactionID,
       pp.TransactionDate,
       pp.Price,
       EXTRACT(YEAR FROM pp.TransactionDate) AS CalendarYear,
       CASE
           WHEN EXTRACT(MONTH FROM pp.TransactionDate) >= 4 THEN
               'FY '|| TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate)) || '-' || TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate) + 1 )
           ELSE
               'FY '|| TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate) - 1)  || '-' || TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate))
       END FinancialYear
FROM PricePaidSW12 pp
FETCH FIRST 100 ROWS ONLY;
 */


/*
Option 2: Use a simple subquery
Oracle version

SELECT
    sale.FinancialYear,
    SUM(sale.Price) /1000000.0 AS TotalPriceInMillions
FROM (
SELECT 
       pp.TransactionID,
       pp.TransactionDate,
       pp.Price,
       EXTRACT(YEAR FROM pp.TransactionDate) AS CalendarYear,
       CASE
           WHEN EXTRACT(MONTH FROM pp.TransactionDate) >= 4 THEN
               'FY '|| TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate)) || '-' || TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate) + 1 )
           ELSE
               'FY '|| TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate) - 1)  || '-' || TO_CHAR(EXTRACT(YEAR FROM pp.TransactionDate))
       END FinancialYear
FROM PricePaidSW12 pp
) sale
 GROUP BY sale.FinancialYear
 ORDER BY sale.FinancialYear;
*/
