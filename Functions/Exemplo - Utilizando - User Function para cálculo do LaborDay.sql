CREATE   FUNCTION dbo.udf_DT_NthDayInMon (
    @nYear as int          
  , @nMonth as int         
  , @nthOccurance as int   
  , @sDayName as varchar(9)

)  RETURNS datetime
   WITH SCHEMABINDING 
AS BEGIN

DECLARE @OnDate datetime
   , @dtFirstOfMonth datetime 
   , @nFirstIsOnADW INT
   , @nDWofDayName int 
   , @nDays2Add2GetToFirstDay int
   , @dtFirstOccurs datetime


IF @nthOccurance > 5 RETURN NULL

SELECT @sDayName = LEFT(UPPER(LTRIM(RTRIM(@sDayName))),3)
    , @dtFirstOfMonth = CONVERT (SMALLDATETIME
                                    , CONVERT(CHAR(4), @nYear) 
                             + '-' + CONVERT(VARCHAR(2), @nMonth)
                             + '-' + CONVERT(VARCHAR(2), 1)
                                , 110 -- required for determinism
                               )

SELECT @nFirstIsOnAdw = 
         1 + (datediff (d
                      , Convert(datetime, '1899-12-31', 120)
                      , @dtFirstOfMonth
                        ) 
               % 7
              )

select @nDWofDayName =  CASE @sDayName
													WHEN 'SUN' then 1 
													WHEN 'SUNDAY'  THEN 1
													WHEN 'MON' THEN 2 
													WHEN 'MONDAY' THEN 2
													WHEN 'TUE' THEN 3 
													WHEN 'TUESDAY' THEN 3
													WHEN 'WED' THEN 4 
													WHEN 'WEDNESDAY' THEN 4
													WHEN 'THU' THEN 5 
													WHEN 'THURSDAY' THEN 5
													WHEN 'THR' THEN 5 -- Alt Abrev.
													WHEN 'FRI' THEN 6 
													WHEN 'FRIDAY'  THEN 6
													WHEN 'SAT' THEN 7 
													WHEN 'SATURDAY' THEN 7
												ELSE -1 

END

IF @nDWofDAyName < 0 RETURN NULL

SET @nDays2Add2GetToFirstDay = (7 - (@nFirstIsOnADW - @nDWOfDayName)) % 7

SET @dtFirstOccurs = dateadd (d, @nDays2Add2GetToFirstDay, @dtFirstOfMonth)

Set @onDate = dateadd(d, 7 * (@nthOccurance - 1), @dtFirstOccurs )

IF MONTH(@OnDate) <> @nMonth SET @ONDATE = NULL
   RETURN @OnDate
END 
go

Select dbo.udf_DT_NthDayInMon('2014', 9, 1, 'Mon');