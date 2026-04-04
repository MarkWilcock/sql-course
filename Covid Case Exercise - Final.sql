/*
COVID Cases Analysis
This uses Window functions to calculate cumulative totals and moving avarages, and to rank within groups

This uses a public dataset from https://coronavirus.data.gov.uk/details/cases.
This has the number of cases reported each day for each of the four countries of the UK
I have renamed some column names from the original dataset to make them more clear.
*/

-- Let's take a quick look at a few rows in the table
SELECT
    TOP 20 *
FROM CovidCase cc
ORDER BY cc.DateRecorded DESC;

/*
Calculate the cumulative number of cases by each country (on or before March 15th 2020)
Create a resultset with four columns: Country, DateRecorded, DailyCases and CumulativeCases
and with a row for every date and country
*/
SELECT
	cc.Country
	, cc.DateRecorded
	, cc.DailyCases
	, SUM(cc.DailyCases) OVER (PARTITION BY cc.Country ORDER BY cc.DateRecorded) CumulativeCases
FROM
	CovidCase cc
where cc.DateRecorded <= '2020-03-15' -- keep # rows returned manageable to avoid scrolling much
ORDER BY
	cc.Country
	, cc.DateRecorded;

/*
Calculate the cumulative number of cases in the UK as a whole
Create a resultset with three columns: DateRecorded, DailyCases and CumulativeCases
Note: we must first group by date (to aggregate over the 4 countries) to get the UK total daily cases
*/

WITH  uk (DateRecorded, DailyCases) AS (
SELECT
	cc.DateRecorded
	, SUM(cc.DailyCases)
FROM
	CovidCase cc
GROUP BY
	cc.DateRecorded
    )
SELECT
	uk.DateRecorded
	, uk.DailyCases
	, SUM(uk.DailyCases) OVER (ORDER BY uk.DateRecorded) CumulativeCases
FROM
	uk
ORDER BY
	uk.DateRecorded;

/*
Find the three days with the highest number of cases in the UK
Create a resultset with three columns: DateRecorded, DailyCases and Ranking, and with three rows
*/

WITH
    uk (DateRecorded, DailyCases)
    AS (
SELECT
	cc.DateRecorded
	, SUM(cc.DailyCases)
FROM
	CovidCase cc
GROUP BY
	cc.DateRecorded
    )
,
    topuk AS  (
SELECT
	uk.DateRecorded
	,  uk.DailyCases
	, RANK() OVER (ORDER BY uk.DailyCases DESC) Ranking
	-- RANK() is better than ROW_NUMBER() in case where two dates have exactly the same number of cases
	--ROW_NUMBER() OVER (ORDER BY uk.DailyCases DESC) Ranking
FROM
	uk
    )
SELECT
	topuk.*
FROM
	topuk
WHERE
	topuk.Ranking <= 3;

-- More simply, we can use a TOP 3 ... ORDER BY approach
WITH
    uk (DateRecorded, DailyCases)
    AS
    (
SELECT
	cc.DateRecorded
	, SUM(cc.DailyCases)
FROM
	CovidCase cc
GROUP BY
	cc.DateRecorded
    )
SELECT
	TOP 3
    uk.DateRecorded
	, uk.DailyCases
	, RANK() OVER (ORDER BY uk.DailyCases DESC) Ranking
FROM
	uk
ORDER BY
	Ranking;

/*
Find the three days with the highest number of cases in each country 
Create a resultset with 
* four columns: Country, DateRecorded, DailyCases and Ranking 
* 12 rows (4 rows for each country with Ranking of 1,2,and 3
*/
WITH
    cte
    AS
    (
SELECT
	cc.Country
	, cc.DateRecorded
	, cc.DailyCases
	, RANK() OVER (PARTITION BY cc.Country
ORDER BY
	cc.DailyCases DESC) Ranking
FROM
	CovidCase cc
    )
SELECT
	cte.DateRecorded
	, cte.Country
	, cte.DailyCases
	, cte.Ranking
FROM
	cte
WHERE
	cte.Ranking <= 3
ORDER BY
	cte.Country
	, cte.Ranking;

/*
Advanced Section
*/

/*
Find the three days with the highest number of cases in each country (using a CROSS APPLY approach)
Create exactly the same resultset as the previous approach
*/
SELECT
	DISTINCT
    cc.Country
	, m.DateRecorded
	, m.DailyCases
	, m.Ranking
FROM
	CovidCase cc
    CROSS APPLY
(
	SELECT
		TOP 3
        z.Country
		, z.DateRecorded
		, z.DailyCases
		, RANK() OVER (PARTITION BY z.country ORDER BY DailyCases DESC) AS Ranking
	FROM
		CovidCase z
	WHERE
		z.Country = cc.Country
	ORDER BY
		z.DailyCases DESC
		-- FETCH FIRST 3 ROWS ONLY -- Oracle

) m
ORDER BY
	cc.Country
	,
         m.DailyCases DESC;

/*
Calculate the seven day moving average of cases by country
Create a resultset with four columns: Country, DateRecorded, DailyCases and CumulativeCases
*/
SELECT
	cc.DateRecorded
	, cc.Country
	, cc.DailyCases
	, AVG(cc.DailyCases) OVER (PARTITION BY cc.Country ORDER BY cc.DateRecorded ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) SevenDayMovingAverageCases
FROM
	CovidCase cc
ORDER BY
	cc.Country
	, cc.DateRecorded;