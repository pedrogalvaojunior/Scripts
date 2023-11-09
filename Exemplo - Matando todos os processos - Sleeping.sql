Declare @SPID SmallInt,
           @Contador SmallInt,
           @Comando VarChar(20)

Declare @Id Table
 (CodId SmallInt)

Insert Into @ID
Select SPID from SysProcesses
Where Status='sleeping'

Select Top 1 @SPID = CodID from @ID
Where CodID > 0

While @Contador >=(Select Count(*) from @ID)
 Begin  
    
   Set @Comando='Kill '+Convert(VarChar(2),@SPID)
   
   Exec(@comando)
   
  Set @Contador = @Contador - 1 

  Select Top 1 @SPID = CodID from @ID
  Where CodID >@SPID
 End

