EXEC sp_msforeachtable 'ALTER TABLE ? NoCHECK CONSTRAINT ALL'

EXEC sp_msforeachtable 'delete from ?'

EXEC sp_msforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL'

Set NoCount On

Declare @Comando VarChar(500),
              @Contador TinyInt,
              @ID Int

Declare CursorID Cursor For
 Select sf.constid from sysforeignkeys sf
 Open CursorID

Set @Contador = 1
 
While @Contador <=(Select Count(sf.constid) from sysforeignkeys sf)
 Begin
  Fetch Next From CursorId Into @ID
   
  Select @Comando='Alter Table '+so.name+' NoCheck Constraint '+object_name(constid)
  From sys.objects so Inner Join sysforeignkeys sf
                                   On so.object_id = sf.fkeyid
  Where sf.constid = @ID

  Set @Contador = @Contador + 1
  Exec(@Comando)
  
  Select @Comando= 'Delete From '+so.name 
  From sys.objects so Inner Join sysforeignkeys sf
                                    On so.object_id = sf.fkeyid
  Where sf.constid = @ID   
     
  Exec(@Comando)
 End
 
Close CursorID
DEALLOCATE CursorID