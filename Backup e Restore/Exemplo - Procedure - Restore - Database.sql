Alter PROCEDURE #P_Restaurar @Caminho VarChar(50)
As
 Begin
  
  Declare @Comando VarChar(500)

  Set @Comando='Restore Database NorthWind From Disk = '+''''+@Caminho+'\*.bak'+''''

  Print @comando
 End

#P_Restaurar 'C:\Backup'

