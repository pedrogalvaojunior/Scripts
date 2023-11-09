Declare @TotalLinhas SmallInt,
           @Contador SmallInt

Set @Contador=1

Set @TotalLinhas=1000

Create Table #Teste
 (Codigo Int Identity(1,1),
  Descricao VarChar(20))

While @Contador <= @TotalLinhas
 Begin
  Insert Into #Teste Values('Usuário - '+Convert(VarChar(4),@Contador))

  Set @Contador=@Contador+1
 End 


Select * from #Teste
Order By Codigo