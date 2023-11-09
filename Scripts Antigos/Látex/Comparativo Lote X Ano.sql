Declare @LoteProducao Char(6),
           @AnoMovimentacao Char(4)

Set @LoteProducao='083045'
Set @AnoMovimentacao=(Select SubString(Convert(Char(4), Year(GetDate())),3,2))

If SubString(@LoteProducao,4,2) = @AnoMovimentacao
 Begin
  Set @LoteProducao='06'
  Print 'Lote:'+@LoteProducao
 End
 Else
   Begin 
    Set @AnoMovimentacao='20'+SubString(@LoteProducao,4,2)
    Print '20'+SubString(@LoteProducao,4,2)
   End

If @AnoMovimentacao='2004' 
 (Select * from CtLuvas2004)
Else
 (Select * from CtLuvas)

