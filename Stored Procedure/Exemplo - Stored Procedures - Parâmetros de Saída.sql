Create Procedure #P_Calcular @N1 TinyInt, @N2 TinyInt, @MSN VarChar(40) = Null OutPut
As
  Begin
  
   Declare @Total SmallInt

   Set @Total=0
   Set @Total=@N1+@N2

   If @Total =2
    Set @MSN='O Valor �: '+Convert(VarChar(3),@Total)			
   Else
    Set @MSN='A soma dos valores de entrada �: '+Convert(VarChar(3),@Total)			

   Print @MSN
  End

#P_Calcular 1,2

--Utilizando o resultado do par�metro de Sa�da --
Create Procedure #P_Calcular1 @N1 TinyInt, @N2 TinyInt, @Total SmallInt = Null OutPut 
As
  Begin
 
   Set @Total=@N1+@N2
  End


-- Declarando vari�veis para utiliza��o do par�metro de sa�da --
 Declare @Total SmallInt 
 Execute #P_Calcular1 2,5,@Total Output
 
 If @Total <=3
  Print 'Menor'
 Else
  Print 'Maior'		
