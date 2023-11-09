Declare @ValorMes Int,
           @Data DateTime

Set NoCount On
Set DateFormat DMY

Set @ValorMes=0
Set @Data='01/01/2006'

While @ValorMes <12
 Begin
  
  Print 'Data-->'+Convert(Char(11),DateAdd(Month,@ValorMes,@Data))
  Set @ValorMes=@ValorMes+1 
 End