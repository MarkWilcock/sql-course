/*
Useful SQL Functions
********************

Objective: Introduce several common, very useful SQL functions
We will see these used in the lab exercises later in the course.

These are shown with simplest possible example, usually using values as arguments but
in practice, the arguments will be column names
*/

/*
Date functions include DATEFROMPARTS, DATENAME, DATEPART, DATEADD, DATEDIFF, YEAR, MONTH, DAY
*/

-- CURRENT_TIMESTAMP and GETDATE() return the current date and time
-- CAST a datetime value to a date datatype to return the date (without any time component)
SELECT CURRENT_TIMESTAMP AS TheDateTimeNow;
SELECT GETDATE() AS TheDateTimeNow;
SELECT CAST(GETDATE() AS DATE) AS TodaysDate;

-- DATENAME() returns part of a date as a string
-- See https://www.w3schools.com/sql/func_sqlserver_datename.asp for interval argument examples
SELECT m.MessageId
       ,m.ReceivedDate
       ,DATENAME(WEEKDAY,m.ReceivedDate) AS ReceivedWeekDay
FROM Message m;

-- DATEPART() returns part of a date as a number
SELECT m.MessageId
       , m.ReceivedDate
       , DATEPART(WEEKDAY, m.ReceivedDate) AS ReceivedWeekDay
FROM Message m;

-- DATEFROMPARTS() Returns a date given the year, month number and day of month
SELECT DATEFROMPARTS(2022, 5, 18) AS TheDate;

-- FORMAT returns a string given a data and a format specifier 
SELECT FORMAT(DATEFROMPARTS(2022, 1, 18), 'dd-MMM-yyyy');
SELECT FORMAT(DATEFROMPARTS(2022, 1, 18), 'ddd dd-MMMM-yy');

-- DATEADD adds an interval to a date
-- Note that SQL will understand a string with a yyyy-mm-dd format as a date
SELECT DATEADD(WEEK, 1, '2022-05-18');
SELECT DATEADD(MONTH, -2, '2022-05-18');

-- DATEDIFF() will return the number of intervals between two dates
SELECT DATEDIFF(DAY, '2022-06-10', '2022-07-10');
SELECT DATEDIFF(WEEK, '2022-06-10', '2022-07-10');

/*
String functions
*/

/*
CONCAT - appends several  columns / values together.  
ImplicitLy converts these to string saving us the trouble

Note that the + operator can concatenate strings but all datatypes must be strings 
*/
SELECT
	m.MessageId
	, m.ReceivedDate
	, m.Region
	, m.Category
	, m.Movement
	, CONCAT(m.MessageId, m.Region, m.ReceivedDate, m.Movement) AS Combined
    ,  CAST(m.MessageId AS VARCHAR) + m.Region + CAST(m.ReceivedDate AS VARCHAR) + CAST(m.Movement AS VARCHAR) AS CombinedWithPlus
FROM Message m;

-- LEFT returns the first number_of_chars 
SELECT
	m.MessageId
	, m.Region
	, LEFT(m.Region, 3) AS RegionCode
FROM
	Message m;

-- SUBSTRING returns a part of the string
SELECT
	m.MessageId
	, m.Region
	,SUBSTRING(m.Region, 2, 2) AS RegionPart
FROM 
Message m;

-- LEN returns the length of a string
SELECT
	m.MessageId
	, m.Region
	, LEN(m.Region) AS RegionLength
FROM
	Message m;

/*
Other functions
COALESCE(item1, item2, ...) - returns the first non-null value in a list
ISNULL(expression, replacement) - returns the replacement value if expression is NULL. Otherwise returns expression 
*/

-- Create a small temporary table with a NULL value to demo these functions
DROP TABLE IF EXISTS #Person;

CREATE TABLE #Person
(
    Name VARCHAR(10)
    , Weight INT,
);

-- A field with a NULL value is a field with no value.
INSERT INTO #Person
VALUES
	('Mark', 100)
	,('Mary', 200)
	,('David', NULL); -- There is not an amount for David

SELECT * FROM #Person;

SELECT p.Name
       ,p.Weight
       ,ISNULL(p.Weight, 101) AS FullAmount
       ,COALESCE(p.Weight, 102) AS NewAmount
FROM #Person p;


-- END

/*
 * Oracle version
SELECT SYSTIMESTAMP AS TheDateTimeNow FROM dual;
SELECT SYSDATE AS TodaysDate FROM dual;
 */

/*
 * Oracle version
-- See https://www.databasestar.com/oracle-to_char/ for example format masks
SELECT m.MessageId,
       m.ReceivedDate,
       TO_CHAR(m.ReceivedDate, 'DAY') AS ReceivedWeekDay
FROM Message m;
 */

/*
 * Oracle version
-- See https://database.guide/extract-datetime-function-in-oracle/ for list of date parts to extract
SELECT m.MessageId,
       m.ReceivedDate,
       EXTRACT(DAY FROM m.ReceivedDate) AS ReceivedWeekDay,
       EXTRACT(MONTH FROM m.ReceivedDate) AS ReceivedMonth
FROM Message m;
 */

/*
 * Oracle version
SELECT 
       m.MessageId,
       m.Region,
       LENGTH (m.Region) AS RegionLength
FROM Message m;
 */

/*
 * Oracle version
SELECT DATE'2022-01-18' FROM DUAL;
SELECT DATE'2022-01-18' + 1 FROM DUAL;

SELECT TO_CHAR(DATE'2022-01-18', 'DD-MON-YY') AS DateString FROM DUAL;
SELECT TO_CHAR(DATE'2022-01-18', 'DAY DD-MONTH-YY') AS DateString FROM DUAL;
 */

/*
 * Oracle version
SELECT 
       m.MessageId,
       m.Region,
       SUBSTR(m.Region, 2, 2) AS RegionPart
FROM Message m;
 */

/*
 * Oracle version
-- Use || as the concatenation operator.  Note that this implicity converts datatypes to string
-- Oracle CONCAT can only take two arguments so we need to nest these
SELECT m.MessageId AS "MessageIdentifier",
       m.ReceivedDate || m.Region || m.Category || m.Movement AS CombinedColumnOperator,
       CONCAT(m.ReceivedDate, CONCAT(m.Region, CONCAT(m.Category, m.MOVEMENT))) AS CombinedColumnConcat
FROM Message m;
 */

/*
 * Oracle version
-- Oracle does not have a LEFT function. Use SUBSTR instead.
SELECT 
       m.MessageId,
       m.Region,
       SUBSTR(m.Region, 1, 3) AS RegionCode
FROM Message m;

 */

