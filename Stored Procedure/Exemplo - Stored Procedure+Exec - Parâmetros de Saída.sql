Alter Procedure P_Teste @Valor1 Int, @Valor2 Int OutPut
 As
  Begin
   Declare @Total Int
   
	Set @Total=10
	
	Set @Total=@Total+@Valor1

	Print @Total  
  End   
 

Declare @Comando VarChar(500),
             @NomeProcedure VarChar(20),
             @Valor Int 
          
Set @NomeProcedure='P_Teste' 
Set @Valor=2
   
Set @Comando='Declare @Resultado Int Exec '+@NomeProcedure+' '+Convert(VarChar(3),@Valor)+','+'@Resultado'

Exec(@Comando)


  
 
  