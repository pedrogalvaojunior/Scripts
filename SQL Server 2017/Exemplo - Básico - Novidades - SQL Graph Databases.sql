-- Criando o Banco de Dados --
Create Database SQLGraphDatabases
Go

-- Acessando o Banco de Dados --
Use SQLGraphDatabases
Go

-- Criando a Node Table Products --
Create Table Products 
(ProductID TinyInt Primary Key, 
 ProductName Varchar(100)
 ) As Node
Go

-- Inserindo dados na Node Table Products --
Insert Into Products
Values (1,'SQL Server'),
              (2,'Azure'),
			  (3,'Windows')
Go

-- Consultando os dados --
Select ProductId, ProductName from Products
Go

-- Exibindo toda estrutura da Node Table Products --
Select * from Products
Go

-- Criando a Edge Table Microsoft --
Create Table Microsoft As Edge
Go

-- Consultando a estrutura da Edge Table Microsoft --
Select * from Microsoft
Go

-- Inserindo os dados na Edge Table Microsoft com base na Node Table Products --

-- Azure com SQL Server --
Insert Into Microsoft ($from_id , $to_id )
Values ((Select $node_id from Products where ProductId=2),
               (Select $node_id from Products where ProductId=1))
Go

-- Windows com SQL Server --
Insert Into Microsoft ($from_id ,$to_id )
Values ((Select $node_id from Products where ProductId=3),
               (Select $node_id from Products where ProductId=1))
Go

-- Windows com Azure --
Insert Into Microsoft ($from_id ,$to_id )
Values ((Select $node_id from Products where ProductId=3),
               (Select $node_id from Products where ProductId=2))
Go

-- Consultando os dados inseridos na Edge Table Microsoft --
Select * from Microsoft
Go

-- Identificando as conexões entre os dados através da função Match() --
Select Concat(Products.ProductName,' --> ', ProductsDetails.ProductName) As Connections
From Products, Microsoft, Products ProductsDetails 
Where Match(Products-(Microsoft)->ProductsDetails)
And Products.ProductName = 'Azure'
Go

Select Concat(Products.ProductName,' --> ', ProductsDetails.ProductName) As Connections
From Products, Microsoft, Products ProductsDetails 
Where Match(Products-(Microsoft)->ProductsDetails)
And Products.ProductName = 'Windows'
Go