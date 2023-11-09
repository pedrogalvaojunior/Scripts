Declare @Testo Varchar(20)
Set @Testo='1000G00'

If IsNumeric(SubString(@Testo,5,1))=0
  Print SubString(@Testo,5,1)+'Não é numérico'



Declare @String varchar(1000)
 Set @string = '1000G00'

 Declare @Start int
 Declare @End int

 Select @Start = 1, @end = len(@String)
  
 While @start <= @end
 Begin

 If Isnumeric(substring(@String,@Start,1))=0
    Print substring(@String,@Start,1) + ' nao e numerico '
 
 Set @Start = @Start + 1
 End



