Declare @Tabela Table
 (Codigo Int Identity(1,1),
    Valores Decimal(7,4))
   
Insert Into @Tabela Values(9.1700)
Insert Into @Tabela Values(8.4000)
Insert Into @Tabela Values(10.0000)

Select Codigo,
  Case  
   When CHARINDEX('.',Valores,1)=2 Then '00'+Convert(VarChar(10),Valores)
   When CHARINDEX('.',Valores,1)=3 Then '0'+Convert(VarChar(10),Valores)
  End As Valores
  from @Tabela

Select Codigo,
  Case CHARINDEX('.',Valores,1)-1
   When 1 Then '00'+Convert(VarChar(10),Valores)
   When 2 Then '0'+Convert(VarChar(10),Valores)
  End As Valores
  from @Tabela
