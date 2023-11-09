USE tempdb
GO
IF OBJECT_ID(‘OrdersBig’) IS NOT NULL
 DROP TABLE OrdersBig
GO

CREATE TABLE OrdersBig 
(OrderID int NOT NULL IDENTITY(1, 1),
 CustomerID int NULL,
 OrderDate date NULL,
 Value numeric (18, 2) NOT NULL)
GO

-- Alterando a Tabela Adicionando Primary Key --
ALTER TABLE OrdersBig 
 ADD CONSTRAINT PK_OrdersBig PRIMARY KEY CLUSTERED  (OrderID)
GO

-- Inserindo 5 Milhões de Linhas de Registro --
Insert Into OrdersBig(CustomerID, OrderDate, Value)
SELECT Top 5000000
       ABS(CONVERT(Int, (CheckSUM(NEWID()) / 10000000))) As CustomerID,
       CONVERT(Date, GetDate() - ABS(CONVERT(Int, (CheckSUM(NEWID()) / 10000000)))) As OrderDate,
       ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 1000000.5))) As Value
  FROM sysobjects a, sysobjects b, sysobjects c, sysobjects d
GO

-- Alterando a Tabela Adicionando uma Nova Coluna --
ALTER TABLE OrdersBig 
 ADD CountCol VarChar(20)
GO

-- Realizando o Update de Dados com base no Top(50) Percent --
UPDATE TOP (50) PERCENT OrdersBig 
SET CountCol = 'Count'
WHERE CountCol IS NULL
GO

UPDATE TOP (50) PERCENT OrdersBig 
SET CountCol = 'CountDistinct'
WHERE CountCol IS NULL
GO

UPDATE OrdersBig 
SET CountCol = 'CountDistinct_1'
WHERE CountCol IS NULL
GO
CHECKPOINT
GO