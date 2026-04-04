/*
Airports Exercise 

Data source: https://ourairports.com/data/
Data dictionary: https://ourairports.com/help/data-dictionary.html

In this exercise we analyse the countries,airports and airports_frequencies table
These have  matching columns: 
* airports.ident matches airport_frequencies.airport_ident
* countries.code matches airports.iso_country
*/

-- Show 10 sample rows of the airports table
SELECT 	TOP 10 * FROM 	countries c;

-- Show 10 sample rows of the airports table
SELECT 	TOP 10 * FROM 	airports a;

-- Show 10 sample rows of the airports_frequencies table
SELECT 	TOP 10 * FROM airport_frequencies af;

-- These are the more interesting columns of the airports table  that we use in this exercise
SELECT TOP 10
	a.ident
	,a.iata_code
	,a.name
	,a.[type]
	,a.latitude_deg
	,a.longitude_deg
	,a.elevation_ft
	,a.iso_country
FROM airports a;

-- How many airports are in the airports table?
SELECT 	COUNT(*)  AS NumberOfAirports FROM airports a;

-- How many frequencies are in the airport_frequencies table?
SELECT COUNT(*) AS NumberOfFrequencies FROM airport_frequencies af;

-- How many airports of each type?
SELECT 
	a.type
	,COUNT(*) AS NumberOfAirports
FROM
	airports a
GROUP BY
	a.[type];

-- Is the airport.ident column unique? i.e. there are no duplicate values
SELECT
	COUNT(*) AS NumberOfRows
	,COUNT(DISTINCT ident) AS NumberOfUniqueIdents
	FROM airports a;

/*
Do a data quality check on the airports_frequencies table
Are there any orphan rows (frequencies without a matching airports)?
You can do this is several ways: LEFT JOIN,NOT IN,NOT EXISTS,...
*/
-- left join approach
SELECT
	COUNT(*) AS NumberOfOrphanRows
FROM
	airport_frequencies af
LEFT JOIN
	airports a
ON  af.airport_ident = a.ident
WHERE
	a.ident IS NULL;

-- NOT EXISTS approach	
SELECT count(*) FROM airport_frequencies af
WHERE
	NOT EXISTS (
	SELECT
		*
	FROM
		airports a
	WHERE
		a.ident = af.airport_ident);

-- NOT IN approach	
SELECT count(*) FROM airport_frequencies af
WHERE af.airport_ident NOT IN (
SELECT
	ident
FROM
	airports)

/*
1. List airports.  Show the following columns: ident,iata_code,name,latitude_deg,longitude_deg 
2. Filter to those airports
  (a) of large_airports type 
  (b) in the United Kingdom or France (iso_country  GB,FR) 
  [advanced - in Europe i.e.,country.continent = 'EU']
  (c) that have a latitude between 49 and 54 degrees
3. Order from the most northern airports to most southern airports
*/
SELECT
	a.ident
	,a.iata_code
	,a.name
	,a.iso_country
	,a.latitude_deg
	,a.longitude_deg
FROM
	airports a
WHERE
	a.type = 'large_airport'
	--AND a.iso_country IN ('GB','FR')
	AND a.iso_country IN (SELECT code FROM countries WHERE continent = 'EU')
	AND a.latitude_deg BETWEEN 49 AND 54
ORDER BY 
	a.latitude_deg DESC;

/*
List the iso_country of the 5 countries with the most airports 
List in order of number of airports (highest first)
*/

SELECT
	TOP 5
	a.iso_country
	,COUNT(*) AS NumberOfAirports
FROM
	airports a
GROUP BY
	a.iso_country
ORDER BY
	NumberOfAirports DESC;

/*
How many airports are in those 5 countries (with the most airports)?
Use three different approaches: temp table,CTE,subquery
*/

-- Write the temp table approach below here

DROP TABLE IF EXISTS #ByCountry

SELECT
	TOP 5
	a.iso_country
	,COUNT(*) AS NumberOfAirports
INTO
	#ByCountry
FROM
	airports a
GROUP BY
	a.iso_country
ORDER BY
	NumberOfAirports DESC;

SELECT * FROM #ByCountry

SELECT
	SUM(NumberOfAirports) AS TopNumberOfAirports
FROM
	#ByCountry;

-- CTE Approach,CTE does not have column headers
WITH TopCountries AS
(
SELECT
	TOP 5
	a.iso_country
	,COUNT(*) AS NumberOfAirports
FROM
	airports a
GROUP BY
	a.iso_country
ORDER BY
	NumberOfAirports DESC
)
SELECT
	SUM(NumberOfAirports) AS TopNumberOfAirports
FROM
	TopCountries;

-- Write the CTE approach below here

-- CTE Approach,CTE has column headers
WITH cte (Country,NumberOfAirports) AS
(
SELECT
	TOP 5
	a.iso_country
	,COUNT(*) AS NumberOfAirports  -- we use colunm alias here so that we can order by it
FROM
	airports a
GROUP BY
	a.iso_country
ORDER BY
	NumberOfAirports DESC
)
SELECT
	SUM(cte.NumberOfAirports) AS TopNumberOfAirports
FROM
	cte;

-- Write the subquery approach below here
SELECT
	SUM(TopT.NumberOfAirports) AS TopNumberOfAirports
FROM
	(
	SELECT
		TOP 5
		a.iso_country
		,COUNT(*) AS NumberOfAirports
	FROM
		airports a
	GROUP BY
		a.iso_country
	ORDER BY
		NumberOfAirports DESC
) TopT;

/*
List those large airports (if any) without a frequency 
*/
SELECT 
	a.ident
	,a.iata_code
	,a.name
	,a.type
	,a.latitude_deg
	,a.longitude_deg
	,a.elevation_ft
	,a.iso_country
FROM airports a
where a.type = 'large_airport'
and not exists (select * from airport_frequencies af WHERE af.airport_ident = a.ident);

/*
List airports (if any) that have missing (NULL) values for *both* latitude or longitude.
*/
SELECT 
	a.ident
	,a.iata_code
	,a.name
	,a.type
	,a.latitude_deg
	,a.longitude_deg
	,a.elevation_ft
	,a.iso_country
FROM airports a
WHERE (a.latitude_deg IS NULL AND a.longitude_deg IS NULL);

/*
List airports (if any) that have missing (NULL) values for *either* latitude or longitude  but not both.
This may indicate some sort of data quality issue.
*/
SELECT 
	a.ident
	,a.iata_code
	,a.name
	,a.type
	,a.latitude_deg
	,a.longitude_deg
	,a.elevation_ft
	,a.iso_country
FROM airports a
WHERE (a.latitude_deg IS NULL OR a.longitude_deg IS NULL)
AND NOT (a.latitude_deg IS NULL AND a.longitude_deg IS NULL);