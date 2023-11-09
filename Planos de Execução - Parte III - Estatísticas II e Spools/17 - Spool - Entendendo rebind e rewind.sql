/*
  Sr.Nimbus - OnDemand
  http://www.srnimbus.com.br
*/

------------------------------------------
--- Spool - Entendendo rebind e rewind ---
------------------------------------------

/*
  Rebind e Rewind s�o utilizados em v�rios operadores, 
  dentre eles os de Spool.
  
  Vejamos seu comportamento no "Table Spool"
  
  Supondo que a tabela TabRebind_Rewind cont�nha 4 linhas
  na seguinte ordem "19831203", "19831203", "20100622" e "19831203"
  Uma representa��o do Rebind e Rewind seria o seguinte:
  
  * Value = "19831203". Ocorre um rebind, j� que � a primeira vez que o operador � chamado.
  * Value = "19831203". Ocorre um rewind, j� que o Value j� foi lido, e est� no spool cache.
  * Value = "20100622". O Value mudou, portanto o cache � apagado e um novo rebind ocorre,
                        j� que o Value "20100622" n�o est� no cache.
  * Value = "19831203". Um rebind ocorre novamente, j� que o Value do cache � o "20100226",
                        e o Value lido no passo 1 foi truncado no passo 3.                      
  
  N�meros finais: 3 Rebinds (passos 1,3 e 4) e apenas um rewind (passo 2).
  
  Com o script abaixo podemos tirar a prova:
*/

USE Northwind
GO

-- Preparando o ambiente
IF OBJECT_ID('TabRebind_Rewind') IS NOT NULL
  DROP TABLE TabRebind_Rewind
GO
CREATE TABLE TabRebind_Rewind (ID        Integer IDENTITY(1,1),
                               Customer  Integer NOT NULL,
                               Employee  VarChar(30) NOT NULL,
                               Quantity  SmallInt NOT NULL,
                               Value     Numeric(18,2) NOT NULL,
                               OrderDate DateTime NOT NULL)
GO
CREATE UNIQUE CLUSTERED INDEX ix_PK ON TabRebind_Rewind(ID)
GO

TRUNCATE TABLE TabRebind_Rewind
GO
SET IDENTITY_INSERT TabRebind_Rewind ON
INSERT INTO TabRebind_Rewind(ID, Customer, Employee, Quantity, Value, OrderDate)
VALUES(1,
       ABS(CheckSUM(NEWID()) / 100000000),
       'Fabiano',
       ABS(CheckSUM(NEWID()) / 10000000),
       ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 1000000.5))),
       '19831203'),
      (2,
       ABS(CheckSUM(NEWID()) / 100000000),
       'Fabiano',
       ABS(CheckSUM(NEWID()) / 10000000),
       ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 1000000.5))),
       '19831203'),
      (3,
       ABS(CheckSUM(NEWID()) / 100000000),
       'Fabiano',
       ABS(CheckSUM(NEWID()) / 10000000),
       ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 1000000.5))),
       '20100622'),
      (4,
       ABS(CheckSUM(NEWID()) / 100000000),
       'Fabiano',
       ABS(CheckSUM(NEWID()) / 10000000),
       ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 1000000.5))),
       '19831203')
SET IDENTITY_INSERT TabRebind_Rewind OFF
GO

-- Visualizando os dados
SELECT * FROM TabRebind_Rewind
GO

-- Atualizar estat�sticas para for�ar o table spool
UPDATE STATISTICS TabRebind_Rewind WITH ROWCOUNT = 300000, PAGECOUNT = 50000
GO
-- Consulta para selecionar todas as compras de um Vendas
-- onde o Valor de venda seja menor que a m�dia de at� a data da venda atual
-- Ou seja, com base na m�dia de valor de venda at� a data atual, retorne os
-- pedidos esta abaixo da m�dia
-- Analisar o Rebind Rewind do operador Table Spool
SELECT *
  FROM TabRebind_Rewind AS Ped1
 WHERE Ped1.Value > (SELECT AVG(Ped2.Value)
                       FROM TabRebind_Rewind AS Ped2
                      WHERE Ped2.OrderDate < Ped1.OrderDate)
OPTION (RECOMPILE, MAXDOP 1)
GO

/*
  Segundo nossas contas (texto acima) o valor esperado � o seguinte:
  Rebind = 3
  Rewind = 2
  
  Valores atuais do plano:
  Rebind = 2
  Rewind = 2
  
  Pergunta: Porque os valores n�o bateram?
  
  
  
  
  
  
  
  
  
  Dica: Reparou no Sort gerado no plano de execu��o?
  
  
  
  
  
  
  
  
  
  Resposta: O SQL reordenou os dados para aumentar as chances do Rewind :-)
  Ou seja, ele trocou a ordem das linhas de:
    * 19831203
    * 19831203
    * 20100622
    * 19831203 
  Para:
    * 19831203
    * 19831203
    * 19831203
    * 20100622
*/