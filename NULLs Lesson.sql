/*
Dealing with NULL values
The Colour and Style columns of the Message table have NULL values for certain rows.
*/

/*
Use IS NOT NULL to filter where values are present.
List the messages that have a Colour value.
*/
SELECT
    m.*
FROM
    Message m
WHERE
    m.Colour IS NOT NULL;

/*
Use IS NULL to filter where values are missing.
List the messages with a missing Colour value.
*/
SELECT
    m.*
FROM
    Message m
WHERE
    m.Colour IS NULL;

/*
List the messages where both Colour and Style are missing.
*/
SELECT
    m.*
FROM
    Message m
WHERE
    m.Colour IS NULL
    AND m.Style IS NULL;

/*
Beware: NULLs introduce three-way logic (true, false, or unknown).
GreenCount + NotGreenCount < AllCount
*/

SELECT
    COUNT(*) AS AllCount
FROM
    Message;

SELECT
    COUNT(*) AS GreenCount
FROM
    Message m
WHERE
    m.Colour = 'Green';

SELECT
    COUNT(*) AS NotGreenCount
FROM
    Message m
WHERE
    m.Colour <> 'Green';

-- To count all rows that are not green, including rows where Colour is NULL, add an extra OR clause.
SELECT
    COUNT(*) AS NotGreenCount
FROM
    Message m
WHERE
    m.Colour <> 'Green'
    OR m.Colour IS NULL;


/*
Aggregate functions - apart from COUNT(*) - ignore NULLs.
We can use this to find the number of non-NULL rows.
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
ISNULL() returns a replacement value if the column value is NULL.
*/
SELECT
    m.MessageId
    ,m.Colour
    ,ISNULL(m.Colour, 'No Colour') AS FullColour
FROM
    Message m;

/*
COALESCE() returns the first non-NULL value from a list of arguments.
This is most useful when there are several columns each holding a different version of the same value.
For example: COALESCE(Forecast5, Forecast4, Forecast3, Forecast2, Forecast1, 0)
*/
SELECT
    m.MessageId
    ,m.Colour
    ,m.Style
    ,COALESCE(m.Colour, m.Style, 'Nothing to see here') AS CombinedCoalesce
FROM
    Message m;

/*
Advanced: count the number of rows with a non-NULL value for a column in two steps.
(1) Create a calculated column: use CASE to return 1 or 0 for each row depending on whether the column value is NULL.
(2) Sum that column — the total is the count of rows with a non-NULL value.
*/

-- Step 1
SELECT
    m.MessageId
    ,m.Colour
    ,CASE WHEN m.Colour IS NOT NULL THEN 1 ELSE 0 END AS IsColourPresent
FROM
    Message m;

-- Summarise for the whole table
SELECT
    COUNT(*) AS NumMessages
    ,SUM(CASE WHEN m.Colour IS NOT NULL THEN 1 ELSE 0 END) AS NumMessagesWithColour
FROM
    Message m;

-- Summarise for each region
SELECT
    m.Region
    ,COUNT(*) AS NumMessages
    ,SUM(CASE WHEN m.Colour IS NOT NULL THEN 1 ELSE 0 END) AS NumMessagesWithColour
FROM
    Message m
GROUP BY
    m.Region;
