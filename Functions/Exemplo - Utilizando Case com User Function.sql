Create Function F_Scalar_Valor (@Numero Int)
Returns Int
As
 Begin
  Declare @Numero2 Int
  Set @Numero2=1

  Set @Numero2=@Numero2+@Numero
  
  Return (@Numero2)
 End


Select Case dbo.F_Scalar_Valor(1)
	       When 1 Then 'Número 1'
	       When 2 Then 'Número 2'
         End As Resultado
