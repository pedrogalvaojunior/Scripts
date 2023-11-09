SELECT LEN(RIGHT(135.900,LEN(135.900)-CHARINDEX('.',135.900))) as qtde

select Len(Right(135.900,Len(135.900)-Charindex('.',135.900)))

select Charindex('.',135.900)

select Right(155.900,Charindex('.',155.900)-1) As "Parte Decimal"

Select Right(10.200,CharIndex('.',10.200)) As "Parte Decimal"

Select Right(130.200,Len(130.200)-CharIndex('.',130.200)) As "Parte Decimal"

DECLARE @Numero Money
SET @Numero = 255.55
Select @Numero - FLOOR(@NUMERO)