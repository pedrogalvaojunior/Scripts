Create Procedure #P_CalcularParcelas @ValorTotal Float, @Parcelas TinyInt
As
 Begin
  Declare @ValorParcelas Float

  Set @ValorParcelas=Round(@ValorTotal/@Parcelas,2)

  Declare @Tabela_Parcelamento Table
   (ValorParcela Float,
    NumeroParcela TinyInt Identity(1,1))

  While @Parcelas > 0 
   Begin

    If @Parcelas = 0
     Break
    Else
     Insert Into @Tabela_Parcelamento Values(@ValorParcelas)

   Set @Parcelas = @Parcelas - 1
   End

  Select * from @Tabela_Parcelamento
 End

#P_CalcularParcelas 100, 4