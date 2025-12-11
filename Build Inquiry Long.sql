/*
This lesson shows how to disaggregate a period table .  This is a common problem.

A period table typically has a row for a period, typically defined by a StartDate and EndDate column.
Different rows have different periods with different start and end date values.
Each period has some numerical value, say Amount, associated with the entire period. 

We need to calculate the sum of the Amount over all rows and typically by calendar periods (year, quarter, month etc) that do not align with 
the periods in the table.

To do this we need to disaggregate the data down to a daily granularity then aggregate the data back up to the required 
calendar level with a Dates dimension table in the usual way.

Here are the steps
We first need to define the DailyAmount, the Amount divided by the number of days in the period (+1 if the  start and end dates are inclusive)
We then need to split each period row into a row for each date in the period
For example, if for a particular row, the StartDate is '2024-01-01' and the EndDate is '2024-01-31' we would need to create 31 rows 
with a new [Date] column between '2024-01-01'  '2024-01-31

*/

/*

-- Create the sample data required for this exercise

CREATE TABLE Inquiry (
    Id INT PRIMARY KEY,
    BuildingId INT,
    Amount DECIMAL(10, 2),
    StartDate DATE,
    EndDate DATE
);

-- Insert the data into the Inquiry table
INSERT INTO Inquiry (Id, BuildingId, Amount, StartDate, EndDate)
VALUES 
(1, 10, 900, '2023-01-01', '2023-01-31'),
(2, 10, 800, '2023-01-01', '2024-01-31'),
(3, 10, 400, '2023-01-01', '2023-03-31'),
(4, 20, 1000, '2023-01-01', '2023-02-28'),
(5, 20, 100, '2023-02-01', '2023-04-30'),
(6, 20, 300, '2023-03-01', '2023-06-30'),
(7, 30, 300, '2024-01-01', '2024-02-29'),
(8, 30, 600, '2024-02-01', '2024-02-29'),
(9, 30, 400, '2024-03-01', '2024-04-30'),
(10, 30, 900, '2024-03-01', '2024-05-31');

CREATE TABLE Building (
    BuildingId INT PRIMARY KEY,
    BuildingName NVARCHAR(100),
    SQM INT,
    Region NVARCHAR(50)
);

-- Insert the data into the Building table
INSERT INTO Building (BuildingId, BuildingName, SQM, Region)
VALUES 
(10, 'Poznan', 1000, 'North'),
(20, 'Warsaw', 2000, 'North'),
(30, 'Krakow', 3000, 'South');
*/


-- This shows how to calculate the NumberOfDays in each period, and the DailyAmount
select 
	 i.Id
	,i.BuildingId
	,i.StartDate
	,i.EndDate
	,i.Amount
	,DATEDIFF(DAY,i.StartDate,i.EndDate) + 1 AS NumberOfDays
	,i.Amount / (DATEDIFF(DAY,i.StartDate,i.EndDate) + 1) AS DailyAmount
from Inquiry i;

select * from Building;

select * from Inquiry

-- This is a typical Dates table,found in 
select * from vwDimDates d;

-- The purpose of this CTE is to calculate the DailyAmount We will use a similar CTE in the final statement
with cte AS
(
select 
	 i.Id
	,i.BuildingId
	,i.StartDate
	,i.EndDate
	--,i.Amount
	--,DATEDIFF(DAY,i.StartDate,i.EndDate) + 1 AS NumberOfDays
	,i.Amount / (DATEDIFF(DAY,i.StartDate,i.EndDate) + 1) AS DailyAmount
from Inquiry i
)
select * from cte;


select 
	 i.Id
	,i.BuildingId
	,i.StartDate
	,i.EndDate
	,i.Amount
from Inquiry i
CROSS JOIN vwDimDates d
WHERE d.[Date] >= i.StartDate 
AND d.[Date] <= i.EndDate;
go

CREATE view vwInquiryLong
as
with cte AS
(
select 
	 i.Id
	,i.BuildingId
	,i.StartDate
	,i.EndDate
	,i.Amount / (DATEDIFF(DAY,i.StartDate,i.EndDate) + 1) AS DailyAmount
from Inquiry i
)
select 
	d.[Date]
	,cte.Id
	,cte.BuildingId
	,cte.StartDate
	,cte.EndDate
	,cte.DailyAmount
	,b.SQM
from cte JOIN Building b ON cte.BuildingId = b.BuildingId
CROSS JOIN vwDimDates d
WHERE d.[Date] >= cte.StartDate 
AND d.[Date] <= cte.EndDate;

















/*
ALTER  VIEW vwDimDates AS
select 
	t.N ,
	cast(DATEADD(DAY, t.N, '2022-12-31') as DATE) As [Date]
from Tally t 
where  t.N <= 731
*/