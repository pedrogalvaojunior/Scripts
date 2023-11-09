USE MASTER
GO

--limpa sujeira
USE MASTER
GO
IF EXISTS(SELECT * from sys.databases WHERE name='DemoCheckpoint')
BEGIN
    ALTER DATABASE DemoCheckpoint SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DemoCheckpoint;
END
GO


--cria a base
CREATE DATABASE DemoCheckpoint
ON PRIMARY
(NAME = 'DemoCheckpoint_data', FILENAME = 'D:\MSSQL\DemoCheckpoint_data.mdf')
LOG ON
(Name = 'DemoCheckpoint_Log', FILENAME = 'D:\MSSQL\DemoCheckpoint_log.ldf', SIZE = 100MB, FILEGROWTH = 10MB)
GO


ALTER DATABASE DemoCheckpoint SET RECOVERY SIMPLE

--cria tabela teste
USE DemoCheckpoint
GO
IF OBJECT_ID ( N'DemoCheckpoint.dbo.teste', N'U' ) IS NOT NULL 
BEGIN
    DROP TABLE dbo.teste;
END
GO

CREATE TABLE dbo.teste
(C1 varchar(50) NOT NULL,
C2 varchar(50) NOT NULL)
GO





USE DemoCheckpoint
GO
CHECKPOINT


-- iniciar a partir daqui
-- abra o Perfmon com os contadores

-- em outra sessão
USE DemoCheckpoint
GO
WHILE 1=1
BEGIN
INSERT INTO dbo.teste
VALUES ('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'), 
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb')
END


-- -----------------------------------------------------------------------------






USE MASTER
GO

--limpa sujeira
USE MASTER
GO
IF EXISTS(SELECT * from sys.databases WHERE name='DemoCheckpoint')
BEGIN
    ALTER DATABASE DemoCheckpoint SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DemoCheckpoint;
END
GO


--cria a base
CREATE DATABASE DemoCheckpoint
ON PRIMARY
(NAME = 'DemoCheckpoint_data', FILENAME = 'D:\MSSQLSERVER\DATA\DemoCheckpoint_data.mdf')
LOG ON
(Name = 'DemoCheckpoint_Log', FILENAME = 'D:\MSSQLSERVER\DATA\DemoCheckpoint_log.ldf', SIZE = 10MB, FILEGROWTH = 10MB)
GO
ALTER DATABASE DemoCheckpoint SET RECOVERY SIMPLE

--cria tabela teste
USE DemoCheckpoint
GO
IF OBJECT_ID ( N'DemoCheckpoint.dbo.teste', N'U' ) IS NOT NULL 
BEGIN
    DROP TABLE dbo.teste;
END
GO

CREATE TABLE dbo.teste
(C1 varchar(50) NOT NULL,
C2 varchar(50) NOT NULL)
GO
