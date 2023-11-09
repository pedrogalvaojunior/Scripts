Use DBMonitor
Go

Create Table T1
 (Codigo Int)
Go

Alter Trigger T_ValidarHorario
On T1
For Insert, Update, Delete
As  
Begin
  Set NoCount On
  Set DateFirst 7

  Declare @Horario TinyInt,
               @DiaSemana TinyInt

  Set @Horario = DATEPART(HH, Getdate())
  Set @DiaSemana = DATEPART(WeekDay,GetDate())
 
  If (@Horario = 23 And @DiaSemana = 6)
   Begin
    Begin Tran
    Select 'error....'

 	Rollback Transaction
    Begin Transaction   
   End
End

Insert Into T1 Values(4)

Select * from T1

