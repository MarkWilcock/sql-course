/*
The Chinook database contains details of an online music store.
Here are some example answers to the question
*/
-- List all customers
SELECT
	*
FROM
	Customer c;

-- List all customers. Show only the CustomerId, FirstName and LastName columns
SELECT
	c.CustomerId
	, c.FirstName
	, c.LastName
FROM
	Customer c;

-- List customers in the United Kingdom  
SELECT
	c.CustomerId
	, c.FirstName
	, c.LastName
FROM
	Customer c
WHERE
	c.Country = 'United Kingdom';


-- List customers whose first names begins with an A.
-- Hint: use LIKE and the % wildcard
SELECT
	c.CustomerId
	, c.FirstName
	, c.LastName
FROM
	Customer c
WHERE
	c.FirstName LIKE 'A%';


-- List Customers with an apple email address
SELECT
	c.CustomerId
	, c.FirstName
	, c.LastName
	, c.Email
FROM
	Customer c
WHERE
	c.Email LIKE '%@apple.%';


-- Which customers have the initials LK?
SELECT
	c.CustomerId
	, c.FirstName
	, c.LastName
FROM
	Customer c
WHERE
	c.FirstName LIKE 'L%'
	AND c.LastName LIKE 'K%';

/*
Which employees were born in the 1960s?  Show only the EmployeeId, FirstName, LastName and BirthDate columns
Note: Define a date value as with the region independent format 'yyyy-mm-dd' e.g. '1969-12-31'
*/

SELECT
	e.EmployeeId
	, e.LastName
	, e.FirstName
	, e.BirthDate
FROM
	Employee e
WHERE
	e.BirthDate >= '1960-01-01'
	AND e.BirthDate <= '1969-12-31';

-- A more elegant approach is to use BETWEEN
SELECT
	e.EmployeeId
	, e.LastName
	, e.FirstName
	, e.BirthDate
FROM
	Employee e
WHERE
	e.BirthDate BETWEEN '1960-01-01' AND '1969-12-31';

-- Which are the corporate customers i.e. those with a value, not NULL, in the Company column?
SELECT
	c.CustomerId
	, c.FirstName
	, c.LastName
	, c.Email
	, c.Company
FROM
	Customer c
WHERE
	c.Company IS NOT NULL;

-- When was the oldest employee born?  Who is that?
SELECT
	MIN(e.BirthDate)
FROM
	Employee e;

SELECT
	TOP 1 e.FirstName
	, e.LastName
	, e.BirthDate
FROM
	Employee e
ORDER BY
	e.BirthDate;

-- How many customers are in each country.  Order by the most popular country first.
SELECT
	c.Country
	, COUNT(*) NumberOfCustomers
FROM
	Customer c
GROUP BY
	c.Country
ORDER BY
	NumberOfCustomers DESC;
	
-- List the albums in alphabetical order of Title
SELECT
	ab.*
FROM
	Album ab
ORDER BY
	ab.Title;

-- List 10 albums and their artist.  Order by album title.
SELECT
	TOP 10
	ab.Title AS AlbumTitle
	, ar.Name ArtistName
FROM
	Album ab
JOIN Artist ar ON
	ab.ArtistId = ar.ArtistId
ORDER BY
	AlbumTitle;

-- List the 10 latest invoices. Include the InvoiceId, InvoiceDate and Total
-- Then  also include the customer full name (first and last name together)
SELECT
	TOP 10	
i.InvoiceId
	, i.InvoiceDate
	, i.CustomerId
	, c.FirstName + ' ' + c.LastName CustomerName
	, i.Total
FROM
	Invoice i
INNER JOIN Customer c
        ON
	i.CustomerId = c.CustomerId
ORDER BY
	i.InvoiceDate DESC;

-- List the City, CustomerId and LastName of all customers in Paris and London, 
-- and the Total of their invoices
SELECT
	c.City
	, c.CustomerId
	, c.LastName
	, SUM(i.Total) InvoiceTotal
FROM
	Customer c
INNER JOIN Invoice i
        ON
	c.CustomerId = i.CustomerId
WHERE
	c.City IN ( 'Paris', 'London' )
GROUP BY
	c.City
	, c.CustomerId
	, c.LastName;


-- Show all details about customer Michelle Brooks.  List salient details of her invoices.
SELECT
	c.*
FROM
	Customer c
WHERE
	c.FirstName = 'Michelle'
	AND c.LastName = 'Brooks';

SELECT
	c.LastName
	, i.*
FROM
	Customer c
INNER JOIN Invoice i
        ON
	c.CustomerId = i.CustomerId
WHERE
	c.FirstName = 'Michelle'
	AND c.LastName = 'Brooks';

-- List countries, and the number of customers and the total invoiced amount
-- Order  high to low in terms of the number of customers
SELECT 
	c.Country
	, count(DISTINCT c.CustomerId) NumberOfCustomers
	, SUM(i.Total) InvoiceTotal
FROM
	Customer c
INNER JOIN Invoice i ON
	i.CustomerId = c.CustomerId
GROUP BY
	c.Country
ORDER BY
	NumberOfCustomers DESC;

-- What are the top 10 most popular artists in terms of number of tracks bought by customers?
SELECT
	ar.Name ArtistName
	, COUNT(*) NumberOfTracks
	, SUM(il.UnitPrice) Price
FROM
	InvoiceLine il
JOIN Track t ON
	il.TrackId = t.TrackId
JOIN Album ab ON
	ab.AlbumId = t.AlbumId
JOIN Artist ar ON
	ar.ArtistId = ab.ArtistId
GROUP BY
	ar.Name
HAVING
	COUNT(*) > 10
ORDER BY
	NumberOfTracks DESC;


-- END

/* Oracle version 
SELECT e.EmployeeId, e.LastName, e.FirstName, e.BirthDate
FROM Employee e
WHERE e.BirthDate >= TO_DATE('1960-01-01', 'yyyy-mm-dd')
	AND e.BirthDate <= TO_DATE('1969-12-31', 'yyyy-mm-dd');
*/

/* Oracle version 
 * 
SELECT 
	ab.Title AlbumTitle, 
	ar.Name ArtistName
FROM Album ab JOIN Artist ar on ab.ArtistId = ar.ArtistId
ORDER BY AlbumTitle
FETCH FIRST 10 ROWS ONLY; 
*/

/* Oracle version 
SELECT 
i.InvoiceId,
       i.InvoiceDate,
       i.CustomerId,
       c.FirstName || ' ' || c.LastName CustomerName,
       i.Total
FROM Invoice i
    INNER JOIN Customer c
        ON i.CustomerId = c.CustomerId
ORDER BY i.InvoiceDate DESC
FETCH FIRST 10 ROWS ONLY; 
*/
/* Oracle version 
SELECT e.EmployeeId, e.LastName, e.FirstName, e.BirthDate
FROM Employee e
WHERE e.BirthDate BETWEEN TO_DATE('1960-01-01', 'yyyy-mm-dd')
	AND  TO_DATE('1969-12-31', 'yyyy-mm-dd');
*/

/* Oracle version 
SELECT 
	* FROM Employee e 
ORDER BY e.BirthDate
FETCH FIRST ROW ONLY; 
*/
