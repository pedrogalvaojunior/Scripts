/*
  Sr.Nimbus - OnDemand
  http://www.srnimbus.com.br
*/

-----------------------------------------
----- Date correlation optimization -----
-----------------------------------------

USE Northwind
GO

-- Preparando o ambiente
SET NOCOUNT ON;
GO
ALTER DATABASE NorthWind SET DATE_CORRELATION_OPTIMIZATION OFF;
GO
IF OBJECT_ID('vw_Test', 'V') IS NOT NULL
  DROP VIEW [dbo].vw_Test
GO
IF OBJECT_ID('Item_Pedidos') IS NOT NULL
  DROP TABLE Item_Pedidos
GO
IF OBJECT_ID('Pedidos') IS NOT NULL
  DROP TABLE Pedidos
GO
CREATE TABLE Pedidos(PedidoID   Integer Identity(1,1),
                     DataPedido DateTime NOT NULL, -- AS COLUNAS DE DATA N�O PODEM ACEITAR NULL
                     Valor      Numeric(18,2),
                     CONSTRAINT xpk_Pedido PRIMARY KEY NONCLUSTERED(PedidoID))
GO
CREATE TABLE Item_Pedidos(PedidoID    Integer,
                          ProdutoID   Integer,
                          DataEntrega DateTime NOT NULL, -- AS COLUNAS DE DATA N�O PODEM ACEITAR NULL
                          Quantidade  Integer,
                          CONSTRAINT  xpk_Item_Pedidos PRIMARY KEY (PedidoID, ProdutoID))
GO

-- Pelo menos uma das colunas de data, tem que pertencerem a um indice cluster
CREATE CLUSTERED INDEX ix_DataPedido ON Pedidos(DataPedido)
GO
CREATE NONCLUSTERED INDEX ix_DataEntrega ON Item_Pedidos(DataEntrega)
GO
-- � Obrigat�rio existir uma foreign key entre as tabelas que cont�m as datas correlatas
ALTER TABLE Item_Pedidos ADD CONSTRAINT fk_Pedidos_Item_Pedidos FOREIGN KEY(PedidoID) REFERENCES Pedidos (PedidoID)
GO

BEGIN TRAN
GO
DECLARE @i Integer 
SET @i = 0 
WHILE @i < 100000
BEGIN 
  INSERT INTO Pedidos(DataPedido,Valor) 
  VALUES(CONVERT(VarChar(10),GetDate() - ABS(CheckSum(NEWID()) / 10000000),112), ABS(CheckSum(NEWID()) / 1000000)) 
  SET @i = @i + 1 
END 
GO
COMMIT
GO
INSERT INTO Item_Pedidos(PedidoID, ProdutoID, DataEntrega, Quantidade) 
SELECT PedidoID, ABS(CheckSum(NEWID()) / PedidoID), CONVERT(VarChar(10),DataPedido + ABS(CheckSum(NEWID()) / 100000000),112), ABS(CheckSum(NEWID()) / 10000000) 
FROM Pedidos
GO
INSERT INTO Item_Pedidos(PedidoID, ProdutoID, DataEntrega, Quantidade) 
SELECT PedidoID, ABS(CheckSum(NEWID()) / -999), CONVERT(VarChar(10),DataPedido + ABS(CheckSum(NEWID()) / 100000000),112), ABS(CheckSum(NEWID()) / 10000000) 
FROM Pedidos 
GO
INSERT INTO Item_Pedidos(PedidoID, ProdutoID, DataEntrega, Quantidade) 
SELECT PedidoID, ABS(CheckSum(NEWID()) / 10), CONVERT(VarChar(10),DataPedido + ABS(CheckSum(NEWID()) / 100000000),112), ABS(CheckSum(NEWID()) / 10000000) 
FROM Pedidos 
GO
INSERT INTO Item_Pedidos(PedidoID, ProdutoID, DataEntrega, Quantidade) 
SELECT PedidoID, ABS(CheckSum(NEWID()) / 1), CONVERT(VarChar(10),DataPedido + ABS(CheckSum(NEWID()) / 100000000),112), ABS(CheckSum(NEWID()) / 10000000) 
FROM Pedidos 
GO
INSERT INTO Item_Pedidos(PedidoID, ProdutoID, DataEntrega, Quantidade) 
SELECT PedidoID, CheckSum(NEWID()) / -10, CONVERT(VarChar(10),DataPedido + ABS(CheckSum(NEWID()) / 100000000),112), ABS(CheckSum(NEWID()) / 10000000) 
FROM Pedidos 
GO


-- Visualizando os dados das tabelas
SELECT * 
  FROM Pedidos
 WHERE PedidoID = 1

SELECT * 
  FROM Item_Pedidos
 WHERE PedidoID = 1

/*
  Utilizar a data do pedido visualizado na consulta acima 
  Consulta de teste, verificar o plano de excu��o
*/
SET STATISTICS IO ON
SELECT Pedidos.PedidoID, 
       Pedidos.DataPedido, 
       Item_Pedidos.DataEntrega, 
       Pedidos.Valor
  FROM Pedidos
 INNER JOIN Item_Pedidos
    ON Item_Pedidos.PedidoID = Pedidos.PedidoID
 WHERE Pedidos.DataPedido BETWEEN '20121014' AND '20121015'
OPTION (RECOMPILE)
SET STATISTICS IO OFF
GO

-- Vamos habilitar o DATE_CORRELATION_OPTIMIZATION
ALTER DATABASE NorthWind SET DATE_CORRELATION_OPTIMIZATION ON;
GO

-- Rodar a consulta novamente, verificar que foi aplicado um filtro na tabela Pedidos
SET STATISTICS IO ON
SELECT Pedidos.PedidoID,
       Pedidos.DataPedido,
       Item_Pedidos.DataEntrega,
       Pedidos.Valor
  FROM Pedidos
 INNER JOIN Item_Pedidos
    ON Item_Pedidos.PedidoID = Pedidos.PedidoID
 WHERE Pedidos.DataPedido BETWEEN '20121014' AND '20121015'
OPTION (RECOMPILE)
SET STATISTICS IO OFF
GO


-- Entendendo a m�gica
-- Internamente o SQL Server cria uma view indexada com informa��es sobre as colunas

-- Vamos verificar o ContactName da view
SELECT * FROM sys.views
 WHERE is_date_correlation_view = 1
GO

-- Tentar ver os dados da view...
SELECT * FROM [_MPStats_Sys_17E28260_{B32382C9-685B-49F0-9F3B-394FD0B41E1A}_fk_Pedidos_Item_Pedidos]
GO

-- Vamos criar outra view para poder efetuar o select nela...
-- Exibe o c�digo
sp_helptext [_MPStats_Sys_17E28260_{B32382C9-685B-49F0-9F3B-394FD0B41E1A}_fk_Pedidos_Item_Pedidos]

-- Vamos criar outra view com o mesmo c�digo para poder efetuar o select nela
IF OBJECT_ID('vw_Test', 'V') IS NOT NULL
  DROP VIEW [dbo].vw_Test
GO
CREATE VIEW [dbo].vw_Test
WITH SCHEMABINDING 
AS 
SELECT DATEDIFF(day, convert(datetime2, '1900-01-01', 121), LEFT_T.[DataPedido])/30 as ParentPID, 
       DATEDIFF(day, convert(datetime2, '1900-01-01', 121), RIGHT_T.[DataEntrega])/30 as ChildPID, 
       COUNT_BIG(*) AS C   
  FROM [dbo].[Pedidos] AS LEFT_T 
  JOIN [dbo].[Item_Pedidos] AS RIGHT_T
    ON LEFT_T.[PedidoID] = RIGHT_T.[PedidoID] 
 GROUP BY DATEDIFF(day, convert(datetime2, '1900-01-01', 121), LEFT_T.[DataPedido])/30, 
          DATEDIFF(day, convert(datetime2, '1900-01-01', 121), RIGHT_T.[DataEntrega])/30
GO

-- Visualizando os dados da view
SELECT * FROM vw_test
GO

-- Suponha a seguinte consulta
SELECT * 
  FROM Pedidos
 INNER JOIN Item_Pedidos
    ON Item_Pedidos.PedidoID = Pedidos.PedidoID 
 WHERE Pedidos.DataPedido = '20121015'
/* 
  O filtro da clausula where foi aplicado na coluna DataPedido, 
  O SQL precisa identificar quais os valores ele deve informar como 
  predicate na tabela Pedidos.DataEntrega. 
  Vamos passo a passo: 
*/

-- Vamos na view para ver qual � o maior e menor valor para fazer o calculo reverso
-- O Profiler mostra este c�digo quando executamos a consulta
SELECT datediff(day,CONVERT(datetime,'1900-01-01 00:00:00.000',121),
                    CONVERT(datetime,'2012-10-15 00:00:00.000',121)) / (30)

SELECT *
  FROM vw_Test
 WHERE ParentPID = 1373
GO

-- Com os valores de 1373 e 1374 em m�os o SQL aplica a regra inversa 
-- para poder obter os valores do filtro por DataEntrega.
SELECT CONVERT(DateTime, '19000101') + (1373 * 30)
SELECT CONVERT(DateTime, '19000101') + ((1374  + 1) * 30)

-- Traduzindo, a partir de 1900-01-01 some (1345 * 30), 
-- neste caso teremos o valor de 2012-10-10 como valor m�nimo

-- Feito, com estes dados ele pode incluir o filtro na coluna DataEntrega.
SELECT * 
  FROM Pedidos
 INNER JOIN Item_Pedidos
    ON Item_Pedidos.PedidoID = Pedidos.PedidoID 
 WHERE Pedidos.DataPedido = '20121015'