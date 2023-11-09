Declare @ValorDecimal decimal(4,2);
set @ValorDecimal = 1.75;

Select CAST(DATEADD(MINUTE,(@ValorDecimal - FLOOR(@ValorDecimal)) * 60, 
            DATEADD(hour,FLOOR(@ValorDecimal),'00:00')) AS TIME)



Declare @ValorDecimal decimal(4,2);
Set @ValorDecimal = 1.5;

Select CAST(CAST(@ValorDecimal / 24 as DATETIME) AS TIME)