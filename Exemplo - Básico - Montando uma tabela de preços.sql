Set NoCount On

Declare @Produtos Table
 (Codigo Int Identity(1,1),
   Descricao VarChar(20))

Insert Into @Produtos Values('Arroz')
Insert Into @Produtos Values('Feijão')
Insert Into @Produtos Values('Milho')
Insert Into @Produtos Values('Bolacha')

Declare @TabelaPrecos Table
 (Codigo Int Identity(1,1),
   CodProduto Int,
   Preco Float,
   Data DateTime)


Insert Into @TabelaPrecos Values(1,10.00,GetDate())
Insert Into @TabelaPrecos Values(1,20.00,GetDate()+2)
Insert Into @TabelaPrecos Values(1,30.00,GetDate()+4)
Insert Into @TabelaPrecos Values(1,40.00,GetDate()+6)

Insert Into @TabelaPrecos Values(2,12.00,GetDate())
Insert Into @TabelaPrecos Values(2,22.00,GetDate()+2)
Insert Into @TabelaPrecos Values(2,32.00,GetDate()+4)
Insert Into @TabelaPrecos Values(2,42.00,GetDate()+6)

Insert Into @TabelaPrecos Values(3,13.00,GetDate())
Insert Into @TabelaPrecos Values(3,23.00,GetDate()+2)
Insert Into @TabelaPrecos Values(3,33.00,GetDate()+4)
Insert Into @TabelaPrecos Values(3,43.00,GetDate()+6)

Insert Into @TabelaPrecos Values(4,14.00,GetDate())
Insert Into @TabelaPrecos Values(4,24.00,GetDate()+2)
Insert Into @TabelaPrecos Values(4,34.00,GetDate()+4)
Insert Into @TabelaPrecos Values(4,44.00,GetDate()+6)

SELECT DISTINCT * FROM @TabelaPrecos TP INNER JOIN (SELECT MAX(data) maxdata FROM @TabelaPrecos
                                                                          GROUP BY CodProduto) DataMax
                                                          ON CONVERT(VARCHAR(10),DataMax.Maxdata,103) = CONVERT(VARCHAR(10),TP.data,103)


/*Declare @TabelaPrecos2 Table
 (Codigo Int Identity(1,1),
   CodProduto Int,
   Preco Float,
   Data DateTime)
 
Declare @Contador Int,
           @CodProduto Int
           
Set @Contador=0
Set @CodProduto=0

While @Contador <(Select Count(*) From @TabelaPrecos) And (@CodProduto <=4)
 Begin
  Set @CodProduto=@CodProduto+1  

  Insert Into @TabelaPrecos2 

  Select top 1 CodProduto, Preco, Data From @TabelaPrecos 
  Where CodProduto = @CodProduto
    
  Set @Contador = @Contador+1   

 End

Select * from @TabelaPrecos2
*/




 