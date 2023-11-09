Declare @TBClientes Table
 (Codigo Int,
   Nome Varchar(10))
   
Declare @TbEnderecos Table
(CodEndereco Int Identity(1,1),
  CodCliente Int,
  Descricao Varchar(20))

Insert Into @TBClientes Values (1,'Pedro')
Insert Into @TBClientes Values (2,'Pedro II')
Insert Into @TBClientes Values (3,'Pedro III')

Insert Into @TbEnderecos Values (1,'Rua 1 - Casa 1')
Insert Into @TbEnderecos Values (1,'Rua 1 - Casa 2')
Insert Into @TbEnderecos Values (1,'Rua 2 - Casa 3')
Insert Into @TbEnderecos Values (2,'Rua 1 - Casa 4')

--Select * from @TBClientes

--Select * from @TbEnderecos

/*Select Tb1.Nome, Tb2.Descricao from @TBClientes Tb1 Inner Join @TbEnderecos Tb2
																											On Tb1.Codigo = Tb2.CodCliente
Where Tb1.Codigo=1*/


Declare @TabelaAuxiliar Table
 (Codigo Int Identity,
   CodCliente Int,
   NomeCliente Varchar(10), 
   Descricao VarChar(1000)) 
   
Declare @Contador Int,
                @CodCliente Int,
                @NovoEndereco Varchar(1000)

Set @Contador=1
Set @CodCliente=1
Set @NovoEndereco=Null

While @Contador <=(Select Count(CodEndereco) from @TbEnderecos Where CodCliente=@CodCliente)
 Begin
  
  If @Contador=1   
   Set @NovoEndereco=(Select Descricao From @TbEnderecos Where CodCliente=@CodCliente And CodEndereco=@Contador)
  Else
   Set @NovoEndereco=@NovoEndereco+' | '+(Select Descricao From @TbEnderecos Where CodCliente=@CodCliente And CodEndereco=@Contador)   

  Set @Contador += 1  
 End 

Insert Into @TabelaAuxiliar Values ((Select Codigo from @TBClientes Where Codigo=@CodCliente),(Select Nome from @TBClientes Where Codigo=@CodCliente),@NovoEndereco)

Select CodCliente, NomeCliente, Descricao As 'Endereço' from @TabelaAuxiliar													

