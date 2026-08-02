/*
COVID Cases Analysis
This uses Window functions to calculate cumulative totals and moving avarages, and to rank within groups

This uses a public dataset from https://coronavirus.data.gov.uk/details/cases.
This has the number of cases reported each day for each of the four countries of the UK
I have renamed some column names from the original dataset to make them more clear.
*/

-- Let's take a quick look at a few rows in the table
SELECT TOP 20 *
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
	, 'your answer' AS CumulativeCases
FROM
	CovidCase cc
where cc.DateRecorded <= '2020-03-15' -- keep # rows returned manageable to avoid scrolling much
ORDER BY
	cc.Country
	, cc.DateRecorded;

/*
To work on the UK as a whole (not by country) 
we must first group by date (to aggregate over the 4 countries) to get the UK total daily cases
Since we have several queries at UK  level, we will use a temp table to do this once.
*/

DROP TABLE IF EXISTS #uk_cases;

SELECT
	cc.DateRecorded
	, SUM(cc.DailyCases)
INTO #uk_cases
FROM
	CovidCase cc
GROUP BY
	cc.DateRecorded;


/*
Calculate the cumulative number of cases in the UK as a whole
Create a resultset with three columns: DateRecorded, DailyCases and CumulativeCases
Note: we must first group by date (to aggregate over the 4 countries) to get the UK total daily cases
*/

SELECT
	uk.DateRecorded
	, uk.DailyCases
	, 'your answer' CumulativeCases
FROM
	#uk_cases uk
ORDER BY
	uk.DateRecorded;

/*
Find the three days with the highest number of cases in the UK
Create a resultset with three columns: DateRecorded, DailyCases and Ranking, and with three rows
*/

SELECT
	uk.DateRecorded
	, uk.DailyCases
	, 'your answer' AS Ranking
FROM
	#uk_cases uk;

/*
Find the three days with the highest number of cases in each country 
Create a resultset with 
* four columns: Country, DateRecorded, DailyCases and Ranking 
* 12 rows (4 rows for each country with Ranking of 1,2,and 3
*/
WITH  cte AS  (
SELECT
	cc.Country
	, cc.DateRecorded
	, cc.DailyCases
FROM
	CovidCase cc)
SELECT
	*
FROM
	cte

/*
Advanced Section
*/

/*
Find the three days with the highest number of cases in each country (using a CROSS APPLY approach).
Create exactly the same resultset as the previous approach.
*/
SELECT
	DISTINCT
    cc.Country
	,m.DateRecorded
	,m.DailyCases
	,m.Ranking
FROM
	CovidCase cc
    CROSS APPLY
(
	SELECT
		TOP 3
        z.Country
		,z.DateRecorded
		,z.DailyCases
		,RANK() OVER (PARTITION BY z.country ORDER BY z.DailyCases DESC) AS Ranking
	FROM
		CovidCase z
	WHERE
		z.Country = cc.Country
	ORDER BY
		z.DailyCases DESC
) m
ORDER BY
	cc.Country
	,m.DailyCases DESC;

/*
Advanced example: Calculate the seven day moving average of cases by country
*/
SELECT
	cc.DateRecorded
	,cc.Country
	,cc.DailyCases
	,AVG(cc.DailyCases) OVER (PARTITION BY cc.Country ORDER BY cc.DateRecorded ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) SevenDayMovingAverageCases
FROM
	CovidCase cc
ORDER BY
	cc.Country
	,cc.DateRecorded;