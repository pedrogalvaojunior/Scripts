DECLARE @date VARCHAR(50),@I INT;

SET @date = '2016-01-01 13:16:43.350'

SET @I = 0

WHILE @I < 12
 BEGIN
  SELECT DATENAME(Weekday,(SELECT EOMONTH ( @date,@I ))) + ', ' 
  + DATENAME(MM,(SELECT EOMONTH ( @date,@I )))
  + ' ' + DATENAME(d,(SELECT EOMONTH ( @date,@I ))) +','
  + CAST(DATEPART(YEAR,(SELECT EOMONTH ( @date,@I ))) AS NVARCHAR(4))

  SET @I = @I + 1
 END