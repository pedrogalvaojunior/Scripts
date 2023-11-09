Declare @DataInicial Date = GetDate(),
        @DataFinal Date = GetDate()+30

;With Calendario (Data)
As
(
 Select @DataInicial As Data
 Union All
 Select DateAdd(day, 1, Data) 
 From Calendario
 Where Data <= @DataFinal
)
Select * from Calendario

