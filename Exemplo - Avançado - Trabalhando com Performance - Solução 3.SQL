USE TempDB
GO

-- Consulta atual --
SELECT a.CustomerID,
       a.CountCol,
       CASE a.CountCol
         WHEN 'Count' THEN COUNT(1)
         WHEN 'CountDistinct' THEN COUNT(DISTINCT a.OrderDate)
         WHEN 'CountDistinct_1' THEN COUNT(DISTINCT 1)
         ELSE NULL
       END AS Cnt,
       CASE (SELECT AVG(b.Value)
               FROM OrdersBig b
              WHERE b.CustomerID = a.CustomerID)
            WHEN 1000 THEN 'Média = 1 mil'
            WHEN 2000 THEN 'Média = 2 mil'
            WHEN 3000 THEN 'Média = 3 mil'
            WHEN 4000 THEN 'Média = 4 mil'
            WHEN 5000 THEN 'Média = 5 mil'
            ELSE 'Não é número exato'
       END AS Sts
FROM OrdersBig AS a
GROUP BY a.CustomerID, a.CountCol
ORDER BY a.CustomerID
OPTION (MAXDOP 1)

-- Solução 3 - Utilizando Estatísticas Filtradas e Índices + Índice de Cobertura --
USE TempDB
GO

-- Criando uma Tabela Auxiliar --
CREATE TABLE dbo.Tmp_OrdersBig
       (
       [OrderID] [int] IDENTITY(1,1) PRIMARY KEY NONCLUSTERED NOT NULL,
       [CustomerID] [int] NULL,
       [OrderDate] [date] NULL,
       [Value] [numeric](18, 2) NOT NULL,
       [CountCol] [varchar](20) NULL,
       )  ON [PRIMARY]
GO

-- Alterando a Tabela, mudando o nível de Bloqueio --
ALTER TABLE dbo.Tmp_OrdersBig SET (LOCK_ESCALATION = TABLE)
GO

-- Ativando o Identity para o Bloco de Insert --
SET IDENTITY_INSERT TMP_ORDERSBIG ON 
Go

-- Executando o comando Insert em uma Sessão Temporária --
EXEC('INSERT INTO dbo.Tmp_OrdersBig (OrderID, CustomerID, OrderDate, Value, CountCol)
SELECT OrderID, CustomerID, OrderDate, Value, CONVERT(char(15), CountCol) 
FROM dbo.OrdersBig 
WITH (HOLDLOCK TABLOCKX)')
GO

-- Desativando o Identity Insert -- 
SET IDENTITY_INSERT TMP_ORDERSBIG OFF
GO

-- Excluíndo a Tabela OrdersBig --
DROP TABLE dbo.OrdersBig
GO

-- Renomeando a Tabela Auxilar para OrdersBig --
EXECUTE sp_rename N’dbo.Tmp_OrdersBig’, N’OrdersBig’, ‘OBJECT’
GO

-- Criando novo Índice Clustered --
CREATE CLUSTERED INDEX IND_OrdersBigClustered ON OrdersBig (CustomerID) 
ON [PRIMARY]
GO

-- Criando novo Índice NonClustered com Filtro para Coluna CountCol --
CREATE NONCLUSTERED INDEX IND_orders_big_CountCol_CountCol_customerid_CountDistinct ON OrdersBig
(CountCol ASC,
 CustomerID ASC,
 OrderDate ASC)
WHERE (CountCol='CountDistinct')
ON [PRIMARY]
GO

-- Criando novo Índice NonClustered  com Compressão no nível de Página de Dados --
CREATE NONCLUSTERED INDEX [IX_orders_big_Countcol_Customerid_Value] ON [dbo].[OrdersBig]
(CountCol ASC,
 CustomerID ASC,
 Value ASC)
WITH (DATA_COMPRESSION=PAGE)
ON [PRIMARY]
GO

-- Criando novo Índice NonClustered com Filtro para Coluna CountCol --
CREATE NONCLUSTERED INDEX [IX_orders_big_CountCol_Customerid_Count] ON [dbo].[OrdersBig]
(CountCol ASC,
 CustomerID ASC
)
WHERE (CountCol='Count')
ON [PRIMARY]
GO

-- Executando novamente a Consulta --
SELECT a.CustomerID,
       a.CountCol,
       CASE a.CountCol
         WHEN 'Count' THEN COUNT(1)
         WHEN 'CountDistinct' THEN COUNT(DISTINCT a.OrderDate)
         WHEN 'CountDistinct_1' THEN COUNT(DISTINCT 1)
         ELSE NULL
       END AS Cnt,
       CASE (SELECT AVG(b.Value)
               FROM OrdersBig b
              WHERE b.CustomerID = a.CustomerID)
            WHEN 1000 THEN 'Média = 1 mil'
            WHEN 2000 THEN 'Média = 2 mil'
            WHEN 3000 THEN 'Média = 3 mil'
            WHEN 4000 THEN 'Média = 4 mil'
            WHEN 5000 THEN 'Média = 5 mil'
            ELSE 'Não é número exato'
       END AS Sts
FROM OrdersBig AS a
GROUP BY a.CustomerID, a.CountCol
ORDER BY a.CustomerID
OPTION (MAXDOP 1)