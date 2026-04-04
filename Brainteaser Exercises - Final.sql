/*
Brainteaser Exercises - Final
A set of brainteaser exercise to consolidate SQL lessons
*/

/*
This exercise analyses the data quality of BadMessage table,that  contains list of messages. 
*/
SELECT
	bm.MessageId
	,bm.ReceivedDate
	,bm.Region
	,bm.Category
	,bm.Movement
FROM
	BadMessage bm
ORDER BY
	bm.MessageId;

/*
We have been told that the MessageId column has unique and contiguous values  
i.e. there are no dupicates and no missing values (so no gaps in the sequence of MessageId values).

There are three tasks:
1. Check for duplicates in the MessageId column
2. Differentiate between identical and conflicting duplicates
3. Check for missing MessageId values
*/

/*
Task 1: .  Let's check for duplicates in the MessageId column. If there are duplicates,
(1) list the duplicate MessageId values and the number of times they are duplicated
(2) list (all columns of) the duplicated rows

Consider two approaches; one that uses Window functions and one that does not.
*/
-- 

-- answer
-- (1) List the duplicate MessageId values and the number of times they are duplicated
-- Group By Message Id,counting the rows and filter when the count is greater than  1
SELECT
	bm.MessageId
	,COUNT(*) AS MessageCountById
FROM
	BadMessage bm
GROUP BY
	bm.MessageId
HAVING
	COUNT(*) > 1;

-- (2) list (all columns of) the duplicated rows

SELECT * FROM BadMessage bm 
WHERE MessageId  IN (
SELECT
	bm.MessageId
FROM
	BadMessage bm
GROUP BY
	bm.MessageId
HAVING
	COUNT(*) > 1)
ORDER BY bm.MessageId ;

-- Window functions approach
WITH cte AS (
SELECT
	bm.MessageId
	-- ,bm.ReceivedDate
	-- ,bm.Region
	-- ,bm.Category
	-- ,bm.Movement
	,COUNT(*) OVER (PARTITION BY bm.MessageId) AS MessageCount
FROM
	BadMessage bm
)
SELECT * FROM cte
WHERE cte.MessageCount > 1
ORDER BY 
	cte.MessageId;

-- An alternative Window Functions approach
WITH cte (MessageId,MessageCount) AS (
SELECT
	bm.MessageId
	,COUNT(*) OVER (PARTITION BY bm.MessageId)
FROM
	BadMessage bm
)
,
cte2 (MessageId) AS (
SELECT
	DISTINCT cte.MessageId
FROM
	cte
WHERE
	cte.MessageCount > 1
)
SELECT
	bm.*
FROM
	BadMessage bm
INNER JOIN cte2 ON
	bm.MessageId = cte2.MessageId
ORDER BY
	bm.MessageId

/*
Task 2: differentiate between identical and conflicting duplicates
* identical duplicates have the same values in all columns
* conflicting duplicates have different values in at least one column
*/

SELECT
	bm.MessageId
	,bm.ReceivedDate
	,bm.Region
	,bm.Category
	,bm.Movement
	,COUNT(*) OVER (PARTITION BY bm.MessageId) AS MessageCount 		
	,COUNT(*) OVER (PARTITION BY bm.MessageId,bm.ReceivedDate,bm.Region,bm.Category,bm.Movement) AS IdenticalRowCount 	
	,CASE WHEN COUNT(*) OVER (PARTITION BY bm.MessageId) = 
	            COUNT(*) OVER (PARTITION BY bm.MessageId,bm.ReceivedDate,bm.Region,bm.Category,bm.Movement) 
		THEN 'Identical' 
		ELSE 'Conflicting' END AS DuplicateType
FROM	
	BadMessage bm
WHERE
	bm.MessageId IN (
		SELECT
			MessageId
		FROM
			BadMessage
		GROUP BY
			MessageId
		HAVING
			COUNT(*) > 1
	)	

/*
Task 3. Check for missing MessageId values
Hint: the database has a tally (sequence) table named Tally that contains a sequence of numbers from 1 to 100,000
*/

SELECT N as MissingMessageId
from Tally
WHERE N NOT IN (SELECT MessageId
	FROM BadMessage)
	AND N <= (SELECT MAX(MessageId)
	FROM BadMessage)

/*
	Another approach is order the rows by MessageId and to calculate the difference between the MessageId of one row and the next
*/

DROP TABLE IF EXISTS #temp
SELECT
	bm.MessageId
	,bm.ReceivedDate
	,bm.Region
	,bm.Category
	,bm.Movement
	,LAG(bm.MessageId) OVER (ORDER BY bm.MessageId) LagMessageId
	,bm.MessageId - LAG(bm.MessageId) OVER (ORDER BY bm.MessageId) AS StepMessageId
INTO #temp
	FROM
	BadMessage bm;

select MessageId - 1 AS MissingMessageId from #temp 
WHERE StepMessageId = 2;
	
