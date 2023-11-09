CREATE DATABASE JUNCAO
GO

USE JUNCAO
GO

CREATE TABLE FORNECEDORES
 (CODIGO INT IDENTITY(1,1) PRIMARY KEY,
   RAZAOSOCIAL VARCHAR(20)) 
GO

CREATE TABLE PRODUTOS
(CODIGO INT PRIMARY KEY,
  DESCRICAO VARCHAR(10),
  CODFORNECEDOR INT NOT NULL )
GO  

Insert Into FORNECEDORES
 Values ('S�o Roque'),
		      ('Mairinque'), 
		      ('Carrefour'),
		      ('Extra')  

Insert Into PRODUTOS (CODIGO, DESCRICAO, CODFORNECEDOR)
 Values (1,'Chocolate', 1),
               (2,'Bolacha', 1), 
               (3,'Bala', 1),
               (4,'Refri', 2),
               (5,'Cerveja', 2),
               (6,'Vinho', 2),
               (7,'Licor', 2),
               (8,'Arroz', 3),
               (9,'Feij�o A', 4),
               (10,'Feij�o', 4)

-- Jun��o de Tabelas utilizando o Operador Inner Join --
Select P.Codigo As 'C�digo Produto',
           P.Descricao As 'Descri��o do Produto',
           P.CodFornecedor As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor'
From PRODUTOS P Inner Join FORNECEDORES F
                                  On P.CODFORNECEDOR = F.CODIGO
Order By P.DESCRICAO 

-- Jun��o de Tabelas utilizando o Operador Left Join --
Insert Into PRODUTOS Values(11,'Sorvete',5)

Select P.Codigo As 'C�digo Produto',
           P.Descricao As 'Descri��o do Produto',
           P.CodFornecedor As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor'
From PRODUTOS P Left Join FORNECEDORES F
                                  On P.CODFORNECEDOR = F.CODIGO
Order By P.DESCRICAO 

-- Jun��o de Tabelas utilizando o Operador Right Join --
Select P.Codigo As 'C�digo Produto',
           P.Descricao As 'Descri��o do Produto',
           P.CodFornecedor As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor'
From PRODUTOS P Right Join FORNECEDORES F
                                  On P.CODFORNECEDOR = F.CODIGO
Order By P.DESCRICAO 

Insert Into FORNECEDORES Values ('Mercado A'),
														   ('Mercado B'),
														   ('Mercado C')
														 
Select P.Codigo As 'C�digo Produto',
           P.Descricao As 'Descri��o do Produto',
           P.CodFornecedor As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor'
From PRODUTOS P Right Join FORNECEDORES F
                                  On P.CODFORNECEDOR = F.CODIGO
Order By P.CODFORNECEDOR

-- Jun��o de Tabelas utilizando o Operador Full Join --
Select P.Codigo As 'C�digo Produto',
           P.Descricao As 'Descri��o do Produto',
           P.CodFornecedor As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor'
From PRODUTOS P Full Join FORNECEDORES F
                                  On P.CODFORNECEDOR = F.CODIGO                                                                   
Order By P.CODIGO

-- Jun��o de Tabelas utilizando o Operador Cross Join --
Select P.Codigo As 'C�digo Produto',
           P.Descricao As 'Descri��o do Produto',
           P.CodFornecedor As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor'
From PRODUTOS P Cross Join FORNECEDORES F                                 
Where P.CODIGO >=2
Order By P.CODIGO

-- Utilizando Subquerys ou SubConsultas --
Select F.Codigo As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor',
           TotalProdutos=(Select COUNT(CODFORNECEDOR) 
                                      From PRODUTOS
                                      Where CODFORNECEDOR =  F.Codigo)
From FORNECEDORES F

-- Utilizando Subquerys ou SubConsultas na cla�sula Where --
Select F.Codigo As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor'           
From FORNECEDORES F
Where (Select COUNT(CODFORNECEDOR) 
                                      From PRODUTOS
                                      Where CODFORNECEDOR =  F.Codigo) >= 2

-- Utilizando Subquerys ou SubConsultas com operador Exists -- 
Select F.Codigo As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor'           
From FORNECEDORES F
Where Exists (Select CODIGO From PRODUTOS
                        Where F.CODIGO = PRODUTOS.CODFORNECEDOR)
Order By F.RAZAOSOCIAL  

-- Utilizando Subquerys ou SubConsultas com operador Not Exists -- 
Select F.Codigo As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor'           
From FORNECEDORES F
Where Not Exists (Select CODIGO From PRODUTOS
                        Where F.CODIGO = PRODUTOS.CODFORNECEDOR)
Order By F.RAZAOSOCIAL  


-- Criando uma nova View(Vis�o) --
Create View V_FornecedoresExistentes
As 
Select F.Codigo As 'C�digo do Fornecedor',
           F.RazaoSocial As 'Raz�o Social Fornecedor'           
From FORNECEDORES F
Where Exists (Select CODIGO From PRODUTOS
                        Where F.CODIGO = PRODUTOS.CODFORNECEDOR)

-- Executando a Views --
Select * from V_FornecedoresExistentes

-- Exibir a estrutura e c�digo fonte da vis�o --
SP_HELPTEXT 'V_FORNECEDORESEXISTENTES'
