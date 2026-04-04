/*
Football Case Study - Final
Contains both Foundation and Advanced Level SQL statements

FootballMatch and FootballCalendar are the two tables we will use in this exercise.
The FootballMatch table contains a row for every match played as of early April 2019 in the English Premier League.
The FootballCalendar table contains a row for every date in 2018 and 2019

Connect to the LearnSQL database
*/

SELECT TOP 10 fm.* FROM FootballMatch fm;
SELECT TOP 10 cal.* FROM FootballCalendar cal;

-- How many matches have been played?
SELECT COUNT(*) AS NumberOfMatches FROM FootballMatch;

-- Which date had the most matches?
SELECT
	TOP 1
       fm.[Date]
	, COUNT(*) AS NumberOfMatches
FROM
	dbo.FootballMatch fm
GROUP BY
	fm.[Date]
ORDER BY
	COUNT(*) DESC;

-- follow on: Which day of week had most matches?
SELECT
	DATENAME(DW, fm.DATE)
	, COUNT(*) AS NumberOfMatches
FROM
	dbo.FootballMatch fm
GROUP BY
	DATENAME(DW, fm.DATE)
ORDER BY
	NumberOfMatches DESC;

-- List all the teams in the Premier League in alphabetical order
SELECT
	DISTINCT
       m.HomeTeam AS Team
FROM
	dbo.FootballMatch m
ORDER BY
	m.HomeTeam;

/*
How many matches were played each month? Put the months in chronological order.
Implement this in two ways 
(a) using date functions such as MONTH and DATENAME
(b) joining to the FootballCalendar table
*/
SELECT
	YEAR(m.DATE)
	, DATENAME(MONTH, m.DATE)
	, COUNT(*) AS NumberOfMatches
FROM
	dbo.FootballMatch m
GROUP BY
	YEAR(m.DATE)
	, DATENAME(MONTH, m.DATE)
	, MONTH(m.DATE)
ORDER BY
	YEAR(m.DATE)
	, MONTH(m.DATE);

SELECT
	c.[Year]
	, c.[Month]
	, COUNT(*) AS NumberOfMatches
FROM
	dbo.FootballMatch m
INNER JOIN dbo.FootballCalendar c
        ON
	m.DATE = c.DATE
GROUP BY
	c.[Year]
	, c.[Month]
	, c.MonthKey
ORDER BY
	c.[Year]
	, c.MonthKey;

-- Were any matches played on a Thursday?
SELECT c.[DayOfWeekKey],
       c.[DayOfWeek],
       COUNT(*)
FROM dbo.FootballMatch m
    INNER JOIN dbo.FootballCalendar c
        ON m.[Date] = c.[Date]
GROUP BY c.[DayOfWeek],
         c.[DayOfWeekKey]
ORDER BY c.[DayOfWeekKey];

/*
In which matches did the home team score more than three goals?  
Give the date, home team, full time score as n-m, then away team
where n is the number of goals scored by the home team 
and m in the number of goals scored by the away team. 
Sort these matches, firstly by highest scoring game then by earliest date  for ties.
Hint: use the CONCAT() function to build the full time score
*/
SELECT
	m.[Date]
	, CONCAT(m.HomeTeam, ' ', m.FTHG, ' - ', m.FTAG, ' ', m.AwayTeam) AS FullTimeScore
FROM
	dbo.FootballMatch m
WHERE
	m.FTHG > 3
ORDER BY
	(m.FTHG + m.FTAG) DESC
	, m.[Date];

-- In which matches were more than 4 goals scored? 
SELECT
	m.DATE
	, m.HomeTeam
	, m.AwayTeam
	, CONCAT(m.HomeTeam, ' ', m.FTHG, ' - ', m.FTAG, ' ', m.AwayTeam) AS FullTimeScore
FROM
	dbo.FootballMatch m
WHERE
	(m.FTHG + m.FTAG) > 4
ORDER BY
	(m.FTHG + m.FTAG) DESC
	, m.DATE;

-- Is there an advantage to playing at home? 
-- How many home wins and away wins?  
SELECT
	SUM(CASE WHEN m.FTHG>m.FTAG THEN 1 ELSE 0 END) AS HomeWin
	, SUM(CASE WHEN m.FTHG<m.FTAG THEN 1 ELSE 0 END) AS AwayWin
FROM
	dbo.FootballMatch m;

-- expressed as a percentage
WITH cte AS (
SELECT
	CAST(SUM(CASE WHEN m.FTHG>m.FTAG THEN 1 ELSE 0 END) AS FLOAT) AS HomeWin
	, CAST(SUM(CASE WHEN m.FTHG<m.FTAG THEN 1 ELSE 0 END) AS FLOAT) AS AwayWin
	, CAST(SUM(CASE WHEN m.FTHG <> m.FTAG THEN 1 ELSE 0 END) AS FLOAT) AS EitherWin
	-- not a draw
FROM
	dbo.FootballMatch m)
SELECT
	cte.HomeWin / cte.EitherWin AS HomeWinPercentage
	, cte.AwayWin / cte.EitherWin AS AwayWinPercentage
FROM
	cte;

/*
**************
Advanced Level
**************
*/

-- Did any home team play two matches on the same day?
SELECT
	[Date]
	, HomeTeam
	, COUNT(*) AS NumberOfMatches
FROM
	dbo.FootballMatch
GROUP BY
	[Date]
	, HomeTeam
HAVING
	COUNT(*) > 1;

-- Do the dates in the FootballCalendar table cover the entire period of the 2018 and 2019 matches?
-- You can assume that the Calendar tables contains every date from the earliest to the latest date found
SELECT
	MIN(c.DATE) AS EarliestCalendarDate
	, MAX(c.DATE) AS LatestCalendarDate
FROM
	dbo.FootballCalendar c;

SELECT
	MIN(m.DATE) AS EarliestMatchDate
	, MAX(m.DATE) AS LatestMatchDate
FROM
	dbo.FootballMatch m;

-- Use the NOT EXISTS clause to see if there are any match dates not in the calendar?

/*
Which dates had no matches?
Hint: Use the NOT EXISTS or the NOT IN clause
*/
SELECT
	c.[Date]
FROM
	FootballCalendar c
WHERE
	NOT EXISTS
(	SELECT *  FROM	FootballMatch m WHERE m.[Date] = c.[Date]);

SELECT 
	c.[Date]
FROM 
	FootballCalendar c
WHERE c.[Date] NOT IN
      (SELECT DISTINCT m.[Date] FROM FootballMatch m);

/*
What was the average number of goals scored per match?
Hint: you will need to CAST the expression for the number of goals to a FLOAT so that AVG() returns an accurate result
*/
SELECT
	AVG(CAST(m.FTHG + m.FTAG AS FLOAT)) AS AverageGoals
FROM
	dbo.FootballMatch m;

/*
-- Which matches had more than the average number of goals?
-- Hint: use a subquery in the WHERE clause
*/
SELECT
	m1.DATE
	, m1.HomeTeam
	, m1.AwayTeam
	, m1.FTHG
	, m1.FTAG
FROM
	dbo.FootballMatch m1
WHERE
	(m1.FTHG + m1.FTAG) >
(
	SELECT
		AVG(CAST(m.FTHG + m.FTAG AS FLOAT))
	FROM
		dbo.FootballMatch m
);

/*
Get the dates of the latest three home matches for each team
Write using  Window functions.  
Have a look at an alternative approach using CROSS APPLY in the Final SQL script
*/

-- Using Window functions
WITH cte (HomeTeam
, AwayTeam
, [Date]
, DateReverseOrder)
AS (
SELECT
	m.HomeTeam
	, m.AwayTeam
	, m.[Date]
	, ROW_NUMBER() OVER (PARTITION BY m.HomeTeam
ORDER BY
	m.[Date] DESC)
FROM
	dbo.FootballMatch m)
SELECT
	cte.HomeTeam
	, cte.AwayTeam
	, cte.DATE
	, cte.DateReverseOrder
FROM
	cte
WHERE
	cte.DateReverseOrder <= 3
ORDER BY
	cte.HomeTeam
	, cte.DateReverseOrder;

-- Using CROSS APPLY
WITH cte (TeamName)
AS (
	SELECT 	DISTINCT HomeTeam FROM dbo.FootballMatch)
SELECT
	cte.TeamName
	, f.DATE
FROM
	cte
    CROSS APPLY
(
	SELECT TOP 3
           m.DATE
	FROM
		dbo.FootballMatch m
	WHERE
		m.HomeTeam = cte.TeamName
	ORDER BY
		DATE DESC
) f
ORDER BY
	cte.TeamName ASC
	, f.DATE DESC;
