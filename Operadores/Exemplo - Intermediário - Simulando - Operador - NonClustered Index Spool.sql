-- Criando o Banco de Dados DBMonitor --
Create Database DBMonitor
Go

-- Acessando o Banco de Dados DBMonitor --
Use DBMonitor
Go

-- Criando a Tabela de Pedidos --
CREATE TABLE Pedidos 
(ID Int IDENTITY(1,1) PRIMARY KEY,
 Cliente Int NOT NULL,
 Vendedor VarChar(30) NOT NULL,
 Quantidade SmallInt NOT NULL, 
 Valor Numeric(18,2) NOT NULL,
 Data  DateTime NOT NULL)
Go

-- Inserindo a massa de dados na Tabela Pedidos --
DECLARE @Contador TinyInt

SET @Contador = 1

WHILE @Contador <= 50
BEGIN

  INSERT INTO Pedidos(Cliente, Vendedor, Quantidade, Valor, Data)
  SELECT ABS(CheckSUM(NEWID()) / 100000000), 
         'NonClustered Index Spool',
         ABS(CheckSUM(NEWID()) / 10000000),
         ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 1000000.5))),
         GetDate() - (CheckSUM(NEWID()) / 1000000)
 
  INSERT INTO Pedidos(Cliente, Vendedor, Quantidade, Valor, Data)
  SELECT ABS(CheckSUM(NEWID()) / 100000000),
              'Execution Plan',
             ABS(CheckSUM(NEWID()) / 10000000),
			 ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 1000000.5))),
			 GetDate() - (CheckSUM(NEWID()) / 1000000)

  INSERT INTO Pedidos(Cliente, Vendedor, Quantidade, Valor, Data)
  SELECT ABS(CheckSUM(NEWID()) / 100000000),
               'SQL Server 2012',
		      ABS(CheckSUM(NEWID()) / 10000000),
			  ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 1000000.5))),
			  GetDate() - (CheckSUM(NEWID()) / 1000000)

  SET @Contador = @Contador + 1  
END

-- Inserindo a segunda massa de dados na Tabela Pedidos --
INSERT INTO Pedidos(Cliente, Vendedor, Quantidade, Valor, Data)
SELECT Cliente, Vendedor, Quantidade, Valor, Data 
FROM Pedidos
Go 5

-- Consultando os dados da Tabela Pedidos --
Select * from Pedidos
Go

-- Simulando o uso do Operador Lazy Spool --
SELECT P.*
FROM Pedidos P
WHERE P.Valor > (SELECT AVG(Valor) 
                             FROM Pedidos 
							 Where Data < P.Data)
Go