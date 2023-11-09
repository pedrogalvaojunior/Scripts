Create Table Fornecedores
 (Codigo Int Identity(1,1),
   RazaoSocial VarChar(100))

Create Table Compras
 (Codigo Int Identity(1,1),
  CodFornecedor Int,
  DataCompra DateTime,
  Valor Numeric(10,2))


Insert Into Fornecedores Values('Mercado 1')
Insert Into Fornecedores Values('Mercado 2')
Insert Into Fornecedores Values('Mercado 3')

Set Dateformat DMY

Insert Into Compras Values (1, '01/05/2005',10)
Insert Into Compras Values (1, '10/06/2005',20)
Insert Into Compras Values (1, '12/07/2005',30)

Insert Into Compras Values (1, '20/05/2006',10)
Insert Into Compras Values (1, '20/06/2006',20)
Insert Into Compras Values (1, '20/07/2006',30)

Insert Into Compras Values (2, '30/04/2007',100)
Insert Into Compras Values (2, '30/05/2007',110)
Insert Into Compras Values (2, '30/06/2007',120)

Insert Into Compras Values (3, '10/08/2007',10)
Insert Into Compras Values (3, '10/09/2007',15)
Insert Into Compras Values (3, '10/10/2007',5)

Insert Into Compras Values (3, '10/08/2008',10)
Insert Into Compras Values (3, '10/09/2008',15)
Insert Into Compras Values (3, '10/10/2008',5)


Select * from Fornecedores

Select * from Compras

Select F.Codigo, F.RazaoSocial, 
         C.Codigo As 'Código Compra',
         C.DataCompra,
         C.Valor
From Fornecedores F Inner Join Compras C
                              On F.Codigo = C.CodFornecedor
Where Year(DataCompra) Not In(2007,2008)

/* Este outro exemplo */

Select F.Codigo, F.RazaoSocial, 
         C.Codigo As 'Código Compra',
         C.DataCompra,
         C.Valor
From Fornecedores F Inner Join Compras C
                              On F.Codigo = C.CodFornecedor
Where Year(DataCompra) < 2007
