Create Table #Exemplo
 (Codigo Int Identity(1,1),
  Data DateTime)

Insert Into #Exemplo Values(GetDate())
Insert Into #Exemplo Values(GetDate()+1)
Insert Into #Exemplo Values(GetDate()+2)

Select * from #Exemplo

Drop Procedure P_Exemplo @Codigo Int, @Data DateTime
As
 Begin
  
  Set @Data=(Select Case when @Data Is Null then getDate()  Else @Data  End)

  Select * from #Exemplo
  Where Codigo = @Codigo
  And     Data = @Data
 End

P_Exemplo 1, null










