Set DateFirst 1

Declare @DiadaSemana TinyInt,
        @Hora Char(5)

Select @DiadaSemana = DATEPART (WeekDay, Getdate()), @Hora=Convert(Char(5),GetDate(),114)

If (@DiadaSemana = 1)
Begin

 If (@Hora='12:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Segunda\Protheus10-Segunda-Manha.bak' With Init, Format;
 
 If (@Hora='22:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Segunda\Protheus10-Segunda-Noite.bak' With Init, Format;
End
 
If (@DiadaSemana = 2)
Begin

 If (@Hora='12:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Terça\Protheus10-Terça-Manha.bak' With Init, Format;
 
 If (@Hora='22:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Terça\Protheus10-Terça-Noite.bak' With Init, Format;
End

If (@DiadaSemana = 3)
Begin

 If (@Hora='12:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Quarta\Protheus10-Quarta-Manha.bak' With Init, Format;
 
 If (@Hora='22:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Quarta\Protheus10-Quarta-Noite.bak' With Init, Format;
End

If (@DiadaSemana = 4)
Begin

 If (@Hora='12:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Quinta\Protheus10-Quinta-Manha.bak' With Init, Format;
 
 If (@Hora='22:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Quinta\Protheus10-Quinta-Noite.bak' With Init, Format;
End

If (@DiadaSemana = 5)
Begin

 If (@Hora='12:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Sexta\Protheus10-Sexta-Manha.bak' With Init, Format;
 
 If (@Hora='22:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Sexta\Protheus10-Sexta-Noite.bak' With Init, Format;
End

If (@DiadaSemana = 6)
Begin

 If (@Hora='12:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Sábado\Protheus10-Sábado-Manha.bak' With Init, Format;
 
 If (@Hora='22:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Sábado\Protheus10-Sábado-Noite.bak' With Init, Format;
End

If (@DiadaSemana = 7)
Begin

 If (@Hora='12:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Domingo\Protheus10-Domingo-Manha.bak' With Init, Format;
 
 If (@Hora='22:00')
  Backup Database Protheus10 To Disk = 'F:\Backup-SQL\Domingo\Protheus10-Domingo-Noite.bak' With Init, Format;
End