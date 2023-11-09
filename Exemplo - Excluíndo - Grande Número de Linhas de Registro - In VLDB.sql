-- Construíndo o Ambiente - Parte 1 --
Use Master
GO

-- Criando o Banco de Dados DeleteRows --
CREATE DATABASE DeleteRows
ON PRIMARY 
(NAME = N'DeleteRows', 
 FILENAME = N'C:\Bancos\DeletedRows\DeleteRowsData.mdf', 
 SIZE = 1065984KB, 
 MAXSIZE = UNLIMITED, 
 FILEGROWTH = 1024KB)
LOG ON 
(NAME = N'DeleteRows_log', 
 FILENAME = N'C:\Bancos\DeletedRows\DeleteRowsLog.ldf',
 SIZE = 894336KB, 
 MAXSIZE = 2048GB,
 FILEGROWTH = 25%) 
GO

-- Criando a Tabela DeleteRowsTbl --
CREATE TABLE DeleteRowsTbl
(UnixDate BIGINT IDENTITY(315532800,1) Primary Key Clustered (UnixDate Asc),
 SomeName VARCHAR (100) NULL)
ON [PRIMARY]
GO

-- Criando a Massa de Dados para Teste --
INSERT INTO DeleteRowsTbl
SELECT msc.name + CONVERT(VARCHAR(10),ROUND(RAND()*1000,0))
FROM msdb.sys.objects mso (NOLOCK) CROSS JOIN msdb.sys.columns msc (NOLOCK)
GO 40 

-- Verificando o Tabela do Banco de Dados DeleteRows
USE [DeleteRows]
GO

-- Confirmando a quantidade de Registros Inseridos na Table DeleteRowsTbl
SELECT COUNT(*) FROM DeleteRowsTbl

-- Verificando o Tamanho do Banco de Dados DeleteRows --
SELECT DB_NAME(database_id) AS 'Database Name',
             Name AS 'Logical File Name',
             Physical_Name AS 'Physical File Name', 
             (size*8)/1024 AS 'Datbase Size (In MB)'
FROM sys.master_files 
WHERE DB_NAME(database_id) = DB_NAME()
GO


-- Criando a Estratégia de Espurgo dos Dados --

-- Criando a Table MyDeleteLookup --
CREATE TABLE MyDeleteLookup (UnixDateToDelete BIGINT)
GO

-- Abrindo o Bloco de Transação --
BEGIN TRANSACTION
GO

-- Criando o Índice NonClustered - Ind_MyDeleteLookup para Table MyDeleteLookup --
CREATE NONCLUSTERED INDEX Ind_MyDeleteLookup ON dbo.MyDeleteLookup (UnixDateToDelete) 
WITH (STATISTICS_NORECOMPUTE = OFF, 
            IGNORE_DUP_KEY = OFF, 
            ALLOW_ROW_LOCKS = ON, 
            ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
GO

-- Alterando o Lock_Escalation na Table MyDeleteLookup --
ALTER TABLE dbo.MyDeleteLookup 
SET (LOCK_ESCALATION = TABLE)
GO

-- Confirmando os dados dentro do Bloco de Transação --
COMMIT

-- Populando a Table MyDeleteLookup --
INSERT INTO MyDeleteLookup
SELECT UnixDate 
FROM DeleteRowsTbl 
WHERE UnixDate LIKE '%10%'

-- Verificar a quantidade de registros que serão excluídos --
SELECT COUNT(*) FROM dbo.MyDeleteLookup

-- Realizando a Exclusão de Dados - Versão 1 --

-- Apresentando o Horário de Início da Exclusão dos Dados --
SELECT GETDATE() AS 'Start DateTime'

-- Excluíndo os Dados --
DELETE Mytbl 
FROM DeleteRowsTbl Mytbl INNER JOIN MyDeleteLookup Mylkp 
                                                   ON Mytbl.UnixDate = Mylkp.UnixDateToDelete

-- Apresentando o Horário de Encerramento da Exclusão dos Dados --
SELECT GETDATE() AS 'End DateTime'

-- Confirmando a quantidade de Registros Inseridos na Table DeleteRowsTbl
SELECT COUNT(*) FROM DeleteRowsTbl

-- Verificando o Tamanho do Banco de Dados DeleteRows --
SELECT DB_NAME(database_id) AS 'Database Name',
             Name AS 'Logical File Name',
             Physical_Name AS 'Physical File Name', 
             (size*8)/1024 AS 'Datbase Size (In MB)'
FROM sys.master_files 
WHERE DB_NAME(database_id) = DB_NAME()
GO

-- Realizando a Exclusão de Dados - Versão 2 --

-- Apresentando o Horário de Início da Exclusão dos Dados - Utilizando o Comando Top
PRINT N'Starting Delete at: ' + CONVERT(NVARCHAR(25),GETDATE())
GO

-- Declarando Variáveis para Recebimento de Valores --
DECLARE @MinRangeValue BIGINT,
				@MaxRangeValue BIGINT,
				@tIterationLimit INT,
				@tRowCount INT,
				@tBatchCounter INT,
				@stmnt NVARCHAR(200),
				@params NVARCHAR(200)

-- Atribuíndo Valores para Variáveis --
SET @stmnt = N'DELETE TOP (@tIterationLimit) FROM DeleteRowsTbl WHERE UnixDate BETWEEN @tMinValue AND @tMaxValue'
SET @params = N'@tIterationLimit INT, @tMinValue BIGINT, @tMaxValue BIGINT'
 
SET @MinRangeValue = 320000000 --Some start value (valid)
SET @MaxRangeValue = 323874752 --Some end value (valid)
SET @tIterationLimit = 1000000 --Remove only 1000000 at a time

SET @tRowCount = 9999999
SET @tBatchCounter = 0

WHILE (@tRowCount > 0)
BEGIN

-- Criando o Bloco Transacional - TransactionDeleteRecords --
 BEGIN TRANSACTION DeleteRecords
 
EXEC sp_executesql @stmnt, 
                                   @params, 
                                   @IterationLimit = @tIterationLimit, 
                                   @tMinValue = @MinRangeValue, 
                                   @tMaxValue = @MaxRangeValue;
     
 -- Definindo Manipulador Padrão de Erros --
SET @tRowCount = @@ROWCOUNT
SET @tBatchCounter += 1

-- Confirmando o Bloco Transacional - TransactionDeleteRecords --
COMMIT TRANSACTION DeleteRecords     

  --You may introduce a little wait here so that the heap is free for other operations. In this example, we won't because nothing's waiting for this heap
  --WAITFOR DELAY '00:05'
END
GO

-- Apresentando o Horário de Encerramento da Exclusão dos Dados --
PRINT N'Ending Delete at: ' + CONVERT(NVARCHAR(25),GETDATE())
GO

-- Confirmando a quantidade de Registros Inseridos na Table DeleteRowsTbl
SELECT COUNT(*) FROM DeleteRowsTbl

-- Verificando o Tamanho do Banco de Dados DeleteRows --
SELECT DB_NAME(database_id) AS 'Database Name',
             Name AS 'Logical File Name',
             Physical_Name AS 'Physical File Name', 
             (size*8)/1024 AS 'Datbase Size (In MB)'
FROM sys.master_files 
WHERE DB_NAME(database_id) = DB_NAME()
GO

--The most imporant of all, cleanup the environment
USE master
GO

ALTER DATABASE DeleteRows 
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

DROP DATABASE DeleteRows;
GO          