Declare @Contador Int

Set @Contador=1

While @Contador <10
 Begin
 
  Select Replicate('0',@Contador)+Convert(VarChar(2),@Contador)

  Set @Contador=@Contador+1
 End


Create Table #Tabela
 (Codigo Int Identity(1,1))

Insert Into #Tabela Default Values
Go 10

Select Replicate('0',Convert(VarChar(2),Codigo)) from #Tabela
Go


