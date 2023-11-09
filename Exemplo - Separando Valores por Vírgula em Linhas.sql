Declare @Resultado Table (Numero Int) 

Declare @ListaValores VarChar(50), @PosicaoAtual Int             

Set @ListaValores='25,3545,45,6015,2569,14535,2544,4878,15'

While CharIndex(',',@ListaValores,0) <> 0
 Begin 
  Set @PosicaoAtual = SubString(@ListaValores,1,CharIndex(',',@ListaValores,0)-1) 
  Set @ListaValores = SubString(@ListaValores,CharIndex(',',@ListaValores,0)+1,Len(@ListaValores)) 

  If Len(@PosicaoAtual) > 0
    Insert Into @Resultado Values (Convert(Int, @PosicaoAtual))    
 End 

  If Len(@ListaValores) > 0
    Insert Into @Resultado Values (Convert(Int,@ListaValores))
    
Select * from @Resultado