CREATE FUNCTION [dbo].[WeekDiff]
(
	@StartDate DateTime,
	@EndDate DateTime
)
RETURNS int
AS
BEGIN
	DECLARE @StartDayOfStartWeek datetime;
	DECLARE @StartDayOfEndWeek datetime;

	SELECT @StartDayOfStartWeek = DATEADD(d, -DATEPART(dw, @StartDate) + 1, @StartDate);
	SELECT @StartDayOfEndWeek = DATEADD(d, -DATEPART(dw, @EndDate) + 1, @EndDate);
	RETURN DATEDIFF(d, @StartDayOfStartWeek, @StartDayOfEndWeek)/7;
END