CREATE SCHEMA Auxiliary
-- We put our auxiliary tables and stuff in a separate schema
-- One of the great new things in SQL Server 2005
go

CREATE FUNCTION Auxiliary.Computus
-- Computus (Latin for computation) is the calculation of the date of
-- Easter in the Christian calendar
-- http://en.wikipedia.org/wiki/Computus
-- I'm using the Meeus/Jones/Butcher Gregorian algorithm
(
    @Y INT -- The year we are calculating easter sunday for
)
RETURNS DATETIME
AS
BEGIN
DECLARE
@a INT,
@b INT,
@c INT,
@d INT,
@e INT,
@f INT,
@g INT,
@h INT,
@i INT,
@k INT,
@L INT,
@m INT

SET @a = @Y % 19
SET @b = @Y / 100
SET @c = @Y % 100
SET @d = @b / 4
SET @e = @b % 4
SET @f = (@b + 8) / 25
SET @g = (@b - @f + 1) / 3
SET @h = (19 * @a + @b - @d - @g + 15) % 30
SET @i = @c / 4
SET @k = @c % 4
SET @L = (32 + 2 * @e + 2 * @i - @h - @k) % 7
SET @m = (@a + 11 * @h + 22 * @L) / 451
RETURN(DATEADD(month, ((@h + @L - 7 * @m + 114) / 31)-1, cast(cast(@Y AS VARCHAR) AS Datetime)) + ((@h + @L - 7 * @m + 114) % 31))
END
GO


CREATE TABLE [Auxiliary].[Calendar] (
-- This is the calendar table
  [Date] datetime NOT NULL,
  [Year] int NOT NULL,
  [Quarter] int NOT NULL,
  [Month] int NOT NULL,
  [Week] int NOT NULL,
  [Day] int NOT NULL,
  [DayOfYear] int NOT NULL,
  [Weekday] int NOT NULL,
  [Fiscal_Year] int NOT NULL,
  [Fiscal_Quarter] int NOT NULL,
  [Fiscal_Month] int NOT NULL,
  [KindOfDay] varchar(10) NOT NULL,
  [Description] varchar(50) NULL,
  PRIMARY KEY CLUSTERED ([Date])
)
GO

ALTER TABLE [Auxiliary].[Calendar]
-- In Celkoish style I'm manic about constraints (Never use em ;-))
-- http://www.celko.com/

ADD CONSTRAINT [Calendar_ck] CHECK (  ([Year] > 1900)
AND ([Quarter] BETWEEN 1 AND 4)
AND ([Month] BETWEEN 1 AND 12)
AND ([Week]  BETWEEN 1 AND 53)
AND ([Day] BETWEEN 1 AND 31)
AND ([DayOfYear] BETWEEN 1 AND 366)
AND ([Weekday] BETWEEN 1 AND 7)
AND ([Fiscal_Year] > 1900)
AND ([Fiscal_Quarter] BETWEEN 1 AND 4)
AND ([Fiscal_Month] BETWEEN 1 AND 12)
AND ([KindOfDay] IN ('HOLIDAY', 'SATURDAY', 'SUNDAY', 'BANKDAY')))
GO




SET DATEFIRST 1;
-- I want my table to contain datedata acording to ISO 8601
-- http://en.wikipedia.org/wiki/ISO_8601
-- thus first day of a week is monday
WITH Dates(Date)
-- A recursive CTE that produce all dates between 1999 and 2020-12-31
AS
(
SELECT cast('1999' AS DateTime) Date -- SQL Server supports the ISO 8601 format so this is an unambigious shortcut for 1999-01-01
UNION ALL                            -- http://msdn2.microsoft.com/en-us/library/ms190977.aspx
SELECT (Date + 1) AS Date
FROM Dates
WHERE
Date < cast('2021' AS DateTime) -1
),

DatesAndThursdayInWeek(Date, Thursday)
-- The weeks can be found by counting the thursdays in a year so we find
-- the thursday in the week for a particular date
AS
(
SELECT
Date,
CASE DATEPART(weekday,Date)
WHEN 1 THEN Date + 3
WHEN 2 THEN Date + 2
WHEN 3 THEN Date + 1
WHEN 4 THEN Date
WHEN 5 THEN Date - 1
WHEN 6 THEN Date - 2
WHEN 7 THEN Date - 3
END AS Thursday
FROM Dates
),

Weeks(Week, Thursday)
-- Now we produce the weeknumers for the thursdays
-- ROW_NUMBER is new to SQL Server 2005
AS
(
SELECT ROW_NUMBER() OVER(partition by year(Date) order by Date) Week, Thursday
FROM DatesAndThursdayInWeek
WHERE DATEPART(weekday,Date) = 4
)
INSERT INTO Auxiliary.Calendar
SELECT
d.Date,
YEAR(d.Date) AS Year,
DATEPART(Quarter, d.Date) AS Quarter,
MONTH(d.Date) AS Month,
w.Week,
DAY(d.Date) AS Day,
DATEPART(DayOfYear, d.Date) AS DayOfYear,
DATEPART(Weekday, d.Date) AS Weekday,

-- Fiscal year may be different to the actual year in Norway the are the same
-- http://en.wikipedia.org/wiki/Fiscal_year
YEAR(d.Date) AS Fiscal_Year,
DATEPART(Quarter, d.Date) AS Fiscal_Quarter,
MONTH(d.Date) AS Fiscal_Month,

CASE
-- Holidays in Norway
-- For other countries and states: Wikipedia - List of holidays by country
-- http://en.wikipedia.org/wiki/List_of_holidays_by_country
    WHEN (DATEPART(DayOfYear, d.Date) = 1)          -- New Year's Day
    OR (d.Date = Auxiliary.Computus(YEAR(Date))-7)  -- Palm Sunday
    OR (d.Date = Auxiliary.Computus(YEAR(Date))-3)  -- Maundy Thursday
    OR (d.Date = Auxiliary.Computus(YEAR(Date))-2)  -- Good Friday
    OR (d.Date = Auxiliary.Computus(YEAR(Date)))    -- Easter Sunday
    OR (d.Date = Auxiliary.Computus(YEAR(Date))+39) -- Ascension Day
    OR (d.Date = Auxiliary.Computus(YEAR(Date))+49) -- Pentecost
    OR (d.Date = Auxiliary.Computus(YEAR(Date))+50) -- Whitmonday
    OR (MONTH(d.Date) = 5 AND DAY(d.Date) = 1)      -- Labour day
    OR (MONTH(d.Date) = 5 AND DAY(d.Date) = 17)     -- Constitution day
    OR (MONTH(d.Date) = 12 AND DAY(d.Date) = 25)    -- Cristmas day
    OR (MONTH(d.Date) = 12 AND DAY(d.Date) = 26)    -- Boxing day
    THEN 'HOLIDAY'
    WHEN DATEPART(Weekday, d.Date) = 6 THEN 'SATURDAY'
    WHEN DATEPART(Weekday, d.Date) = 7 THEN 'SUNDAY'
    ELSE 'BANKDAY'
END KindOfDay,
CASE
-- Description of holidays in Norway
    WHEN (DATEPART(DayOfYear, d.Date) = 1)            THEN 'New Year''s Day'
    WHEN (d.Date = Auxiliary.Computus(YEAR(Date))-7)  THEN 'Palm Sunday'
    WHEN (d.Date = Auxiliary.Computus(YEAR(Date))-3)  THEN 'Maundy Thursday'
    WHEN (d.Date = Auxiliary.Computus(YEAR(Date))-2)  THEN 'Good Friday'
    WHEN (d.Date = Auxiliary.Computus(YEAR(Date)))    THEN 'Easter Sunday'
    WHEN (d.Date = Auxiliary.Computus(YEAR(Date))+39) THEN 'Ascension Day'
    WHEN (d.Date = Auxiliary.Computus(YEAR(Date))+49) THEN 'Pentecost'
    WHEN (d.Date = Auxiliary.Computus(YEAR(Date))+50) THEN 'Whitmonday'
    WHEN (MONTH(d.Date) = 5 AND DAY(d.Date) = 1)      THEN 'Labour day'
    WHEN (MONTH(d.Date) = 5 AND DAY(d.Date) = 17)     THEN 'Constitution day'
    WHEN (MONTH(d.Date) = 12 AND DAY(d.Date) = 25)    THEN 'Cristmas day'
    WHEN (MONTH(d.Date) = 12 AND DAY(d.Date) = 26)    THEN 'Boxing day'
END Description

FROM DatesAndThursdayInWeek d
-- This join is for getting the week into the result set
     inner join Weeks w
     on d.Thursday = w.Thursday

OPTION(MAXRECURSION 0)
GO

CREATE FUNCTION Auxiliary.Numbers
(
@AFrom INT,
@ATo INT,
@AIncrement INT
)
RETURNS @RetNumbers TABLE
(
[Number] int PRIMARY KEY NOT NULL
)
AS
BEGIN
WITH Numbers(n)
AS
(
SELECT @AFrom AS n
UNION ALL
SELECT (n + @AIncrement) AS n
FROM Numbers
WHERE
n < @ATo
)
INSERT @RetNumbers
SELECT n from Numbers
OPTION(MAXRECURSION 0)
RETURN;
END
GO

CREATE FUNCTION Auxiliary.iNumbers
(
@AFrom INT,
@ATo INT,
@AIncrement INT
)
RETURNS TABLE
AS
RETURN(
WITH Numbers(n)
AS
(
SELECT @AFrom AS n
UNION ALL
SELECT (n + @AIncrement) AS n
FROM Numbers
WHERE
n < @ATo
)
SELECT n AS Number from Numbers
)
GO