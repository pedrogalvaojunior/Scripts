USE TEMPDB
Go

-- Exemplo 1 --
Declare @Numeros Table
(Numero Int)


Set NoCount On

Declare @Contador TinyInt,
        @MenorValor TinyInt,
		@MaiorValor TinyInt

Set @Contador=1

While @Contador <=100
 Begin
  Insert Into @Numeros Values (@Contador)

  Set @Contador +=1
 End

Set @MenorValor=(Select MIN(Numero) from @Numeros Where Numero <=30)
Set @MaiorValor=(Select MAX(Numero) from @Numeros Where Numero <=30)

Select @MenorValor, @MaiorValor

Select @MenorValor
Union
Select Numero From @Numeros Where Numero Between @MenorValor+1 And @MaiorValor-1
Union
Select @MaiorValor
Go

-- Exemplo 2 -- Utilizando Stored Procedure --
Create Procedure P_ValorIntermediarios (@TotalNumeros SmallInt, @Limitador SmallInt)
As
Begin
 Set NoCount On

 Declare @Numeros Table
 (Numero Int)

 
 Declare @Contador SmallInt,
        @MenorValor SmallInt,
		@MaiorValor SmallInt

 Set @Contador=1

 While @Contador <=@TotalNumeros
  Begin
   Insert Into @Numeros Values (@Contador)

   Set @Contador +=1
  End

 Set @MenorValor=(Select MIN(Numero) from @Numeros Where Numero <=@Limitador)
 Set @MaiorValor=(Select MAX(Numero) from @Numeros Where Numero <=@Limitador)

 Select @MenorValor As 'Menor Valor', @MaiorValor As 'Maior Valor'
 
 Select @MenorValor
 Union
 Select Numero As 'Sequência Completa' From @Numeros Where Numero Between @MenorValor+1 And @MaiorValor-1
 Union
 Select @MaiorValor
End


Exec P_ValorIntermediarios 500, 250
Go