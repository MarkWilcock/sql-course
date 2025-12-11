/*
Brainteaser Exercises 
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
Task 1:  Let's check for duplicates in the MessageId column. If there are duplicates,
(1) list the duplicate MessageId values and the number of times they are duplicated
(2) list (all columns of) the duplicated rows

Consider two approaches; one that uses Window functions and one that does not.
*/

-- write your answer here

/*
Task 2: differentiate between identical and conflicting duplicates
* identical duplicates have the same values in all columns
* conflicting duplicates have different values in at least one column
*/

-- write your answer here

/*
Task 3. Check for missing MessageId values
Hint: the database has a tally (sequence) table named Tally that contains a sequence of numbers from 1 to 100,000
*/

-- write your answer here
