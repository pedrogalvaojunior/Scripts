While 1=1

Begin
 Declare @Mensagem Varchar(20)=Convert(Varchar(24), GetDate(),120)

 Raiserror(@Mensagem,0,1) With NoWait

 Waitfor Delay '00:00:00:500'

End