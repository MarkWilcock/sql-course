/*
Foundation Lab
Creating Objects in SQL
Purpose: Create objects in SQL and set all the properties to achieve a robust well performing database: tables, views, sequences

Each comment describes a task
Write  SQL statement(s)  for the task under the comment

The script must be able to run repeatedly (which is why you will need to drop tables so that you can recreate them)
The SQL script must be able to run completely and correctly on another database.
*/

/*
Tidy up any previous runs by dropping (deleting) any objects that this script creates.  
Use the IF EXISTS clause for brevity.
*/
DROP VIEW IF EXISTS [PersonView];
DROP TABLE IF EXISTS Person;
DROP VIEW IF EXISTS [AddressView];
DROP TABLE IF EXISTS [Address];

/*
Create an Address  table with columns: 
    AddressKey INT
    HouseNumber INT
    StreetName VARCHAR(100)
    PostCode VARCHAR(8)
Set the AddressKey column as the primary key
Set the AddressKey column as an identity column
All columns must be not NULL
*/
CREATE TABLE [Address]
(
    AddressKey INT NOT NULL IDENTITY(1,1) PRIMARY KEY
    ,HouseNumber INT NOT NULL
    ,StreetName VARCHAR(100) NOT NULL
    ,PostCode VARCHAR(8) NOT NULL
);

/*
Add three  rows to the table for the addresses
with the following values for HouseNumber, StreetName and PostCode
    32, 'Acacia Avenue', 'SL1 1AA'
    52, 'Cambray Road', 'SW12 9ES'
    10, 'Downing Street', 'SW1A 2AA'
Use a single statement, not three statements
*/

INSERT INTO Address (HouseNumber, StreetName, PostCode)
VALUES
	(32, 'Acacia Avenue', 'SL1 1AA')
	,(52, 'Cambray Road', 'SW12 9ES')
	,(10, 'Downing Street', 'SW1A 2AA');

-- Check that the data in the Address tables is as expected
SELECT * FROM Address;

/*
Create a view, named AddressView,  that has columns for the HouseNumber and PostCode columns only
*/
GO
CREATE VIEW AddressView
AS
SELECT a.HouseNumber,
       a.PostCode
FROM Address a;
GO

-- Check the view works as expected.
SELECT * FROM AddressView;

/*
Create a Person table with columns: 
    PersonKey INT 
    AddressKey  INT 
    FirstName VARCHAR(100),
    LastName VARCHAR(100)
    DateOfBirth DATE  
Set the PersonKey column as the primary key.
Set the PersonKey column as an identity column
All columns must be NOT NULL.
*/
CREATE TABLE Person
(
    PersonKey INT NOT NULL IDENTITY (1,1) PRIMARY KEY
    ,AddressKey INT FOREIGN KEY REFERENCES Address (AddressKey) NOT NULL
    ,FirstName VARCHAR(100) NOT NULL
    ,LastName VARCHAR(100) NOT NULL
    ,DateOfBirth DATE NOT NULL
);

-- Check that the rows are now in the Person table
SELECT * FROM Person;

/*
Create a foreign key relationship 
so that AddressKey in the Person table references the AddressKey column in the Address table. 
*/
--ALTER TABLE Person ADD FOREIGN KEY (AddressKey) REFERENCES Address (AddressKey);

/*
Add two sample rows to the table
* Boris Johnson in Downing Street (use variables)
* Theresa May in Cambray Road (use a SQL sub query)
*/


SELECT
	a.AddressKey
FROM
	Address a
WHERE
	a.PostCode = 'SW1A 2AA'
	AND a.HouseNumber = 10;

DECLARE @AddressKeyPM INT;
SELECT
	@AddressKeyPM = a.AddressKey
FROM
	Address a
WHERE
	a.PostCode = 'SW1A 2AA'
	AND a.HouseNumber = 10;
SELECT @AddressKeyPM;

INSERT INTO Person (AddressKey, FirstName, LastName, DateOfBirth)
VALUES (
    @AddressKeyPM 
    ,'Boris'
    ,'Johnson'
    ,'1965-06-19')


INSERT INTO Person (AddressKey, FirstName, LastName, DateOfBirth)
VALUES (
    ,(SELECT a.AddressKey from Address a WHERE a.PostCode = 'SL1 1AA' and a.HouseNumber = 32)
    ,'Theresa'
    ,'May'
    ,'1959-01-19')

-- Check that the Person table now has these two rows of data.
SELECT * FROM Person;

/*
Show that the foreign key constraint is active
Try insert a row with a value for Addresskey that is not in the Address table
e.g. Kier Starmer, born on '1963-01-19', with AddressKey 12345
Note the error message
*/
INSERT INTO Person (AddressKey, FirstName, LastName, DateOfBirth)
VALUES (
    12345 -- there is no Address with this value of AddressKey 
    ,'Kier'
    ,'Starmer'
    ,'1963-01-19');

-- Create a PersonView view that the FirstName and LastName (but not the DateOfBirth)

CREATE VIEW PersonView AS
SELECT
	p.FirstName
	, p.LastName
FROM
	Person p;

SELECT * FROM PersonView;


-- Extend the view to include the House Number and PostCode from the Address table
ALTER VIEW PersonView
AS
SELECT
	p.FirstName
	, p.LastName
	, a.HouseNumber
	, a.StreetName
	, a.PostCode
FROM
	Person p
INNER JOIN Address a ON	p.AddressKey = a.AddressKey;


-- Check that the view is working correctly
SELECT * FROM PersonView;

-- END

/*

DROP SEQUENCE IF EXISTS PersonKeySequence;
DROP SEQUENCE IF EXISTS AddressKeySequence;

The AdressKey column will be a autonumber field
Create a sequence to populate the AddressKey column
Name it AddressKeySequence
CREATE SEQUENCE AddressKeySequence
AS INT
START WITH 1
INCREMENT BY 1
NO CYCLE;

INSERT INTO Address
(
    AddressKey,
    HouseNumber,
    StreetName,
    PostCode
)
VALUES
(NEXT VALUE FOR AddressKeySequence, 32, 'Acacia Avenue', 'SL1 1AA'),
(NEXT VALUE FOR AddressKeySequence, 52, 'Cambray Road', 'SW12 9ES'),
(NEXT VALUE FOR AddressKeySequence, 10, 'Downing Street', 'SW1A 2AA');

*/
