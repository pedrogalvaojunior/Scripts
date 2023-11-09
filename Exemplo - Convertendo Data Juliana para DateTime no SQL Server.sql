create FUNCTION dbo.JulianDate_To_StandardDate(@JulianDate INTEGER)
RETURNS smalldatetime 


AS 
BEGIN


Declare @year  as int 
Declare @dayofyear  as int


Declare @STD_Dt  as smalldatetime 
Declare @DayoftheMonth  as int


 select @year =(case when (0+(LEFT(@JulianDate,2))<30)  then 2000  else 1900 end ) +  cast(substring( (case when len(ltrim(rtrim(@JulianDate)))<6 then '0'+ cast(@JulianDate as varchar) else cast(@JulianDate as varchar) end)  ,2,2) as int)
 set @dayofyear = RIGHT(@JulianDate,3)



Declare @MonthoftheYear  as varchar(3)


declare @IsLeap as bit
declare @Jan as int
declare @Feb as int
declare @Mar as int
declare @Apr as int
declare @May as int
declare @Jun as int
declare @Jul as int
declare @Aug as int
declare @Sep as int
declare @Oct as int
declare @Nov as int
declare @Dec as int


declare @JanStart as int
declare @FebStart as int
declare @MarStart as int
declare @AprStart as int
declare @MayStart as int
declare @JunStart as int
declare @JulStart as int
declare @AugStart as int
declare @SepStart as int
declare @OctStart as int
declare @NovStart as int
declare @DecStart as int
declare @DecEnd as int


declare @Months as int 


declare @MonthStart as int 
declare @MonthEnd as int 


set @Months = 1 


set @Jan = 31
set @Feb = 28
set @Mar = 31
set @Apr = 30
set @May = 31
set @Jun = 30
set @Jul = 31
set @Aug = 31
set @Sep = 30
set @Oct = 31
set @Nov = 30
set @Dec = 31




  IF @year % 400 = 0
     -- Years divisible by 400 (e.g. 1600, 2000) are always leap years
     set @IsLeap = 1 
  ELSE
  BEGIN
    IF @year % 100 = 0
       -- Years not divisible by 400 but divisible by 100 (e.g. 1900) are never leap years
     set @IsLeap =0
    ELSE
    BEGIN
      IF @year % 4 = 0
         -- Years not divisible by 400 or 100 but divisible by 4 (e.g. 1976) are always leap years
     set @IsLeap =1
      ELSE
     set @IsLeap =0
    END
  END


if @IsLeap = 1
        set @Feb = 29
else 
        set @Feb = 28




set  @JanStart = 1
set  @FebStart = @Jan
set  @MarStart =@Jan+@Feb 
set  @AprStart =@Jan+@Feb+@Mar 
set  @MayStart =@Jan+@Feb+@Mar+@Apr
set  @JunStart =@Jan+@Feb+@Mar+@Apr+@May 
set  @JulStart =@Jan+@Feb+@Mar+@Apr+@May+@Jun 
set  @AugStart =@Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul 
set  @SepStart =@Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul+@Aug 
set  @OctStart =@Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul+@Aug+@Sep 
set  @NovStart =@Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul+@Aug+@Sep+@Oct 
set  @DecStart =@Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul+@Aug+@Sep+@Oct+@Nov 




WHILE (@Months) < 13
BEGIN


set @MonthStart = case @Months when 1 then @JanStart
                                when 2 then @FebStart
                                when 3 then @MarStart
                                when 4 then @AprStart
                                when 5 then @MayStart
                                when 6 then @JunStart
                                when 7 then @JulStart
                                when 8 then @AugStart
                                when 9 then @SepStart
                                when 10 then @OctStart
                                when 11 then @NovStart
                                when 12 then @DecStart end



set @MonthEnd = case @Months    when 1 then @Jan 
                                when 2 then @Jan+@Feb 
                                when 3 then @Jan+@Feb+@Mar 
                                when 4 then @Jan+@Feb+@Mar+@Apr
                                when 5 then @Jan+@Feb+@Mar+@Apr+@May 
                                when 6 then @Jan+@Feb+@Mar+@Apr+@May+@Jun 
                                when 7 then @Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul
                                when 8 then @Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul+@Aug
                                when 9 then @Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul+@Aug+@Sep
                                when 10 then @Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul+@Aug+@Sep+@Oct
                                when 11 then @Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul+@Aug+@Sep+@Oct+@Nov 
                                when 12 then @Jan+@Feb+@Mar+@Apr+@May+@Jun+@Jul+@Aug+@Sep+@Oct+@Nov+@Dec end




   IF ( @dayofyear  >=@MonthStart and @dayofyear <=@MonthEnd )
        begin



set @DayoftheMonth = case @Months when 1 then 0
                                when 2 then @FebStart 
                                when 3 then @MarStart 
                                when 4 then @AprStart 
                                when 5 then @MayStart 
                                when 6 then @JunStart 
                                when 7 then @JulStart 
                                when 8 then @AugStart 
                                when 9 then @SepStart 
                                when 10 then @OctStart 
                                when 11 then @NovStart 
                                when 12 then @DecStart  end



set @MonthoftheYear = case @Months      when 1 then 'Jan'
                                when 2 then 'Feb'  
                                when 3 then 'Mar'
                                when 4 then 'Apr'
                                when 5 then 'May' 
                                when 6 then 'Jun' 
                                when 7 then 'Jul'
                                when 8 then 'Aug'
                                when 9 then 'Sep'
                                when 10 then 'Oct'
                                when 11 then 'Nov' 
                                when 12 then 'Dec' end



set @DayoftheMonth = @dayofyear - @DayoftheMonth 


set @STD_Dt = cast(@DayoftheMonth as varchar(2) )+'-'+cast(@MonthoftheYear as varchar(3))+'-'+cast(ltrim(rtrim(@year)) as varchar(4))


      BREAK
        end



set @Months = @Months + 1 


END


return @STD_Dt


END
GO



