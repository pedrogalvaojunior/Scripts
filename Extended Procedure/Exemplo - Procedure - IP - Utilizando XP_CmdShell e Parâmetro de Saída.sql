Create Procedure P_RetornarIP @IP VarChar(25) Output
As
 Begin

  Set NoCount On
  Declare @Auditoria2 Table
  (Codigo Int Identity(1,1),
   IP VarChar(2000)) 

  Set RowCount 8
  Insert Into @Auditoria2
  exec master.dbo.xp_cmdshell 'ipconfig'  

  Select @IP=(Select Replace(Substring(IP,CharIndex(':',IP,1),25),':','') from @Auditoria2
  Where Codigo = 8)
  
 End

Create Table Auditoria
 (Codigo Int Identity(1,1),
  HostName VarChar(20) Null)

Declare @IP VarChar(25)
Exec P_RetornarIP @IP OutPut

Insert Into Auditoria Values (@IP)

Select * from Auditoria