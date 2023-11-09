Alter Function F_CalcularPorcentagem (@ValorVenda Float, @QTDEParcelas Int, @Juros Int)
Returns Int
As
Begin
 Declare @ValorAtualizadoVenda Float

 Set @ValorAtualizadoVenda=(IsNull(@ValorVenda,1)/IsNull(@QTDEParcelas,1))

 Set @ValorAtualizadoVenda=@ValorAtualizadoVenda+(@ValorAtualizadoVenda*IsNull(@Juros,1))/100

 Return(@ValorAtualizadoVenda)
End


Select dbo.F_CalcularPorcentagem(5000, 5, 10)