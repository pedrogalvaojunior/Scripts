Set DateFormat dmy

Declare @DiaFinal Int,
           @ContarDias Int

Set @DiaFinal = (Select DatePart(Day,GetDate()))
Set @ContarDias=0

Set Datefirst 1

While @DiaFinal >= (Select DatePart(Day,GetDate())) And @DiaFinal < 28
 Begin
  Set @ContarDias = @ContarDias + 1
  Set @DiaFinal=(Select DatePart(Day,GetDate()+@ContarDias))
 End

SELECT @@DATEFIRST AS '1st Day',  DATEPART(dw,GetDate()+@ContarDias) AS 'Today', @ContarDias As "Total de Dias"



