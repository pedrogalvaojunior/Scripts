Declare @Contador Int,
           @Nome_Table VarChar(50),
           @Comando VarChar(200)

Set @Contador=0 

Declare Cursor_Tables Cursor For
 Select Name from sysobjects
 Where xtype='u'
 And    year(crdate)>=2002
 Order by name
 Open Cursor_Tables

While @Contador <=(Select Count(*) From SysObjects Where xType='U' And Year(CrDate)>=2002)
 Begin

  Fetch Next From Cursor_Tables
  Into @Nome_Table

  Set @Comando='Grant Select On '+@Nome_Table+' To Junior'
  Exec(@Comando)
  Print 'Table:'+@Nome_Table+' permiss�o de Select liberada para usu�rio:'+System_User

  Set @Comando='Grant Insert On '+@Nome_Table+' To Junior'
  Exec(@Comando)
  Print 'Table:'+@Nome_Table+', permiss�o de Insert liberada para usu�rio:'+System_User
  
  Set @Comando='Grant Update On '+@Nome_Table+' To Junior'
  Exec(@Comando)
  Print 'Table:'+@Nome_Table+', permiss�o de Update liberada para usu�rio:'+System_User

  Set @Comando='Grant Delete On '+@Nome_Table+' To Junior'
  Exec(@Comando)
  Print 'Table:'+@Nome_Table+', permiss�o de Delete liberada para usu�rio:'+System_User
  
  Set @Comando='Grant References On '+@Nome_Table+' To Junior'
  Exec(@Comando)
  Print 'Table:'+@Nome_Table+', permiss�o de References liberada para usu�rio:'+ System_User

  Print '------------------------------------------------//--------------------------------------'
  Set @Contador=@Contador+1
 End

CLOSE Cursor_Tables
DEALLOCATE Cursor_Tables