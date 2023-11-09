Declare @Valores Table
(Codigo Int Identity(1,1),
 ValorNumerico SmallInt Default 0)


Insert Into @Valores Values (50),(-22),(-5),(-10),(1)

Select ValorNumerico,
       Case 
	    When (ValorNumerico) <0 Then 'Saída' 
	    When (ValorNumerico) >=1 Then 'Entrada' 
	  End As Operacao
From @Valores