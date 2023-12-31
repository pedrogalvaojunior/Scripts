SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

ALTER PROCEDURE dbo.spTST_CalendarDisplay
(
    @inYear as int,
    @vcLanguage varchar(130)
)
AS
SET NOCOUNT ON
BEGIN
 	--**********************************************************************************************************
 	-- Description - A stored procedure which will build up a calendar display for a specific year
 	-- Parameters  - @inYear = Integer value of the year to be displayed
 	--             - @vcLangauge = String reference to determine the month and day name display
 	--                             Must refer to an alias in the syslanguages table
 	-- Programmer  - Darren Sunderland
 	-- Date        - 04 March 2008
 	--**********************************************************************************************************

 	SET DATEFIRST 1
 	DECLARE @tbFullYear TABLE 
	(
		WeekNo int,MonthNo int,    Day1 varchar(2),Day2 varchar(2),
  		Day3 varchar(2),Day4 varchar(2),Day5 varchar(2),
  		Day6 varchar(2),Day7 varchar(2)
 	)
 	DECLARE @tbReturn TABLE
 	(
  		RowID int IDENTITY(1,1),WeekNumber varchar(20),Day1 varchar(10),
  		Day2 varchar(10),Day3 varchar(10),Day4 varchar(10),
  		Day5 varchar(10),Day6 varchar(10),Day7 varchar(10)
 	)
 	DECLARE @tbDays TABLE
 	(
  		Blank varchar(20),Day1 varchar(10),
  		Day2 varchar(10),Day3 varchar(10),
  		Day4 varchar(10),Day5 varchar(10),
  		Day6 varchar(10),Day7 varchar(10)
 	)
 	DECLARE @inWeek int
 	DECLARE @inCount int
 	DECLARE @inDays int
 	DECLARE @dtStart datetime
 	DECLARE @vcMonths varchar(200)
 	DECLARE @vcDays varchar(100)
 
 	-- Initialise settings
 	SET @inWeek = 1
 	SET @inCount = 0
 	SET @dtStart = CONVERT(datetime,CAST(@inYear as char(4))+'-01-01')
 	SELECT @vcMonths=months+',',@vcDays=days+',' FROM [master].[dbo].[syslanguages] WHERE [alias]=@vcLanguage

 	-- Build up day names for language setting
 	INSERT INTO @tbDays VALUES('','','','','','','','')
 	SET @inDays = 1
 	WHILE @inDays < 8 BEGIN
  		IF @inDays=1
   			UPDATE @tbDays SET Day1=LEFT(@vcDays,CHARINDEX(',',@vcDays)-1)
  		ELSE IF @inDays=2
   			UPDATE @tbDays SET Day2=LEFT(@vcDays,CHARINDEX(',',@vcDays)-1)
  		ELSE IF @inDays=3
   			UPDATE @tbDays SET Day3=LEFT(@vcDays,CHARINDEX(',',@vcDays)-1)
  		ELSE IF @inDays=4
   			UPDATE @tbDays SET Day4=LEFT(@vcDays,CHARINDEX(',',@vcDays)-1)
  		ELSE IF @inDays=5
   			UPDATE @tbDays SET Day5=LEFT(@vcDays,CHARINDEX(',',@vcDays)-1)
  		ELSE IF @inDays=6
   			UPDATE @tbDays SET Day6=LEFT(@vcDays,CHARINDEX(',',@vcDays)-1)
  		ELSE IF @inDays=7
   			UPDATE @tbDays SET Day7=LEFT(@vcDays,CHARINDEX(',',@vcDays)-1)
  		SET @vcDays = RIGHT(@vcDays,LEN(@vcDays)-CHARINDEX(',',@vcDAys))
  		SET @inDays = @inDays+1
 	END
 
 	-- Build up full year calendar
 	WHILE YEAR(@dtStart)=@inYear BEGIN
  		IF (DATEPART(day,@dtStart)=1 AND DATEPART(weekday,@dtStart)<>'1') OR (DATEPART(day,@dtStart)=1 AND DATEPART(month,@dtStart)=1)
   			INSERT INTO @tbFullYear (WeekNo,MonthNo)VALUES(@inWeek,DATEPART(month,DATEADD(day,1,@dtStart)))
  		IF DATEPART(weekday,@dtStart) = 1
   			UPDATE @tbFullYear SET Day1=DATEPART(day,@dtStart) WHERE WeekNo=@inWeek AND MonthNo=DATEPART(month,@dtStart)
  		ELSE IF DATEPART(weekday,@dtStart) = 2
   			UPDATE @tbFullYear SET Day2=DATEPART(day,@dtStart) WHERE WeekNo=@inWeek AND MonthNo=DATEPART(month,@dtStart)
  		ELSE IF DATEPART(weekday,@dtStart) = 3
   			UPDATE @tbFullYear SET Day3=DATEPART(day,@dtStart) WHERE WeekNo=@inWeek AND MonthNo=DATEPART(month,@dtStart)
  		ELSE IF DATEPART(weekday,@dtStart) = 4
   			UPDATE @tbFullYear SET Day4=DATEPART(day,@dtStart) WHERE WeekNo=@inWeek AND MonthNo=DATEPART(month,@dtStart)
  		ELSE IF DATEPART(weekday,@dtStart) = 5
   			UPDATE @tbFullYear SET Day5=DATEPART(day,@dtStart) WHERE WeekNo=@inWeek AND MonthNo=DATEPART(month,@dtStart)
  		ELSE IF DATEPART(weekday,@dtStart) = 6
   			UPDATE @tbFullYear SET Day6=DATEPART(day,@dtStart) WHERE WeekNo=@inWeek AND MonthNo=DATEPART(month,@dtStart)
  		ELSE IF DATEPART(weekday,@dtStart) = 7 BEGIN
  			UPDATE @tbFullYear SET Day7=DATEPART(day,@dtStart) WHERE WeekNo=@inWeek AND MonthNo=DATEPART(month,@dtStart)
   			SET @inWeek = @inWeek + 1
		 	INSERT INTO @tbFullYear (WeekNo,MonthNo)VALUES(@inWeek,DATEPART(month,DATEADD(day,1,@dtStart)))
		END
  		SET @inCount = @inCount + 1
  		SET @dtStart = DATEADD(day,1,@dtStart)
 	END

 	-- Remove null values
 	UPDATE @tbFullYear SET Day1='' WHERE Day1 IS NULL
 	UPDATE @tbFullYear SET Day2='' WHERE Day2 IS NULL
 	UPDATE @tbFullYear SET Day3='' WHERE Day3 IS NULL
 	UPDATE @tbFullYear SET Day4='' WHERE Day4 IS NULL
 	UPDATE @tbFullYear SET Day5='' WHERE Day5 IS NULL
 	UPDATE @tbFullYear SET Day6='' WHERE Day6 IS NULL
 	UPDATE @tbFullYear SET Day7='' WHERE Day7 IS NULL

 	-- Build up output display
 	SET @inCount = 1
 	WHILE @inCount < 13 BEGIN
 		INSERT INTO @tbReturn SELECT CAST(' 'as char(2)),'','',LEFT(@vcMonths,CHARINDEX(',',@vcMonths)-1),CAST(@inYear as char(4)),'','',''
 		SET @vcMonths=RIGHT(@vcMonths,LEN(@vcMonths)-CHARINDEX(',',@vcMonths))
 		INSERT INTO @tbReturn SELECT * FROM @tbDays
 		INSERT INTO @tbReturn SELECT CAST(WeekNo as varchar(2)),Day1,Day2,Day3,Day4,Day5,Day6,Day7 FROM @tbFullYear WHERE MonthNo=@inCount
 		INSERT INTO @tbReturn SELECT ' ','','','','','','',''
  		SET @inCount = @inCount + 1
 	END

 	SELECT WeekNumber,Day1,Day2,Day3,Day4,Day5,Day6,Day7 FROM @tbReturn ORDER BY RowID
END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO