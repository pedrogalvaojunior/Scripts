-- Criando o Banco de Dados Exemplos --
CREATE DATABASE EXEMPLOS
GO

-- Conectando-se ao Banco Exemplos --
Use EXEMPLOS
Go

-- Criando a Tabela Produtos, com a coluna Lote_Fabricacao do tipo SQL_Variant --
CREATE TABLE PRODUTOS
 (CODIGO INT IDENTITY(1,1) Primary Key,
   DESCRICAO VARCHAR(100),
   LOTE_FABRICACAO SQL_VARIANT)
ON [PRIMARY]  

    
-- Inserindo o primeiro conjunto de dados --
Insert Into PRODUTOS Values('Arroz','ABR-1009');
Insert Into PRODUTOS Values('Feijão','FEI-2010');
Go

Insert Into PRODUTOS Values('Bolacha 1',209310);
Insert Into PRODUTOS Values('Bolacha 2',93133);
Insert Into PRODUTOS Values('Bolacha 3',392873);
Insert Into PRODUTOS Values('Bolacha 5',209310);
Go

Insert Into PRODUTOS Values('Biscoito 1',5.25);
Insert Into PRODUTOS Values('Biscoito 2',2.00);
Insert Into PRODUTOS Values('Biscoito 3',3.250);
Insert Into PRODUTOS Values('Biscoito 4',1.553);
Go

-- Consultando os Dados --
Select * from PRODUTOS
Go

-- Inserindo o segundo conjunto de dados utilizando a função Converte para tratamento --
Insert Into PRODUTOS Values('Biscoito',Convert(Datetime,'2010-12-23'));
Insert Into PRODUTOS Values('Biscoito',Convert(Numeric(10,2),1000));
Go

-- Consultando os Dados --
Select * from PRODUTOS
Where CODIGO >=12
Go

Insert Into PRODUTOS Values('Biscoito',2011-02-24);
Insert Into PRODUTOS Values('Biscoito',2011-02-25);
Insert Into PRODUTOS Values('Biscoito',2011-02-26);
Insert Into PRODUTOS Values('Biscoito',2011-02-27);
Insert Into PRODUTOS Values('Biscoito',2011-02-28);
Go

Declare @Data DateTime

Set @Data=2011-02-24

Print Convert(Int, @Data)


Insert Into PRODUTOS Values('Biscoito',GETDATE());

Insert Into PRODUTOS Values('Biscoito',CONVERT(DateTime,'2011-02-05'));

