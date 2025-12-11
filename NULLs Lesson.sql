/*
Dealing with NULL values
The Colour and Style columns of the Message table have empty (NULL) values for certain rows
*/

/*
Use IS NOT NULL to filter where values are present
List the messages with a colour 
*/
SELECT 
	m.*
FROM
	Message m
WHERE
	m.Colour IS NOT NULL;

/*
Use IS NULL to filter where values are missing
List the messages with  a missing colour 
*/
SELECT 
	m.*
FROM
	Message m
WHERE
	m.Colour IS NULL;

/*
List the messages with both a missing colour and style
*/
SELECT 
	m.*
FROM
	Message m
WHERE
	m.Colour IS NULL
	AND m.Style IS NULL;

/*
Beware: NULLS introduce 3 way predicate logic
GreenCount + NotGreenCount < AllCount
*/

SELECT COUNT(*) as AllCount FROM Message;

SELECT COUNT(*) as GreenCount FROM Message m WHERE m.Colour = 'Green';

SELECT COUNT(*) as NotGreenCount FROM Message m WHERE m.Colour <> 'Green';

-- If we want to count all rows that are not green including NULL rows we need to add the extra OR clause
SELECT
	COUNT(*) AS NotGreenCount
FROM
	Message m
WHERE
	m.Colour <> 'Green'
	OR m.Colour IS NULL;


/*
Aggregate functions,apart from COUNT(*),ignore NULLS
We can use this to find the number of non NULL rows
*/

SELECT
	COUNT(*) AS AllCount
FROM
	Message m;

SELECT
	COUNT(m.Colour) AS NonNullColourColumnCount
FROM
	Message m;

/*
ISNULL() returns a replacement string if a value is NULL 
*/
SELECT 
	m.MessageId
	,m.Colour
	,ISNULL(m.Colour,'No Colour') AS FullColour
FROM
	Message m;

/*
COALESCE() returns the first non NULL value in the list of arguments
More useful where these are several columns each with a different version of same quantity: 
e.g. COALSECE(Forecast5,Forecast4,Forecast3,Forecast2,Forecast1,0)
*/
SELECT 
	m.MessageId
	,m.Colour
	,m.Style
	,COALESCE(m.Colour,m.Style, 'Nothing to see here') AS CombineCoalesce
FROM
	Message m;

/*
Advanced:  count the number of rows with a NON NULL value for a column in 2 steps
(1) Create a caluclated column: use CASE to first return a 0 or 1 for each row depending on whether the column has a NULL or NON NULL value 
(2) sum the column - the sum of 1 and 0 is the count of rows with non NULL values
*/

-- Step 1
SELECT 
	m.MessageId
	,m.Colour
	,CASE WHEN Colour IS NOT NULL THEN 1 ELSE 0 END IsColourPresent 
FROM Message m;

-- Summarise for whole table
SELECT 
	COUNT(*) NumMessages
	,SUM(CASE WHEN Colour IS NOT NULL THEN 1 ELSE 0 END) NumMessagesWithColourPresent 
FROM Message m;

-- Summarise For each region
SELECT 
	m.Region
	,COUNT(*) NumMessages
	,SUM(CASE WHEN Colour IS NOT NULL THEN 1 ELSE 0 END) NumMessagesWithColourPresent 
FROM Message m
GROUP BY m.Region;

