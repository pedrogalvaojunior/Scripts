-- ****** SCRIPT PARA CRIAR BANCO DE 129GB (TESTE DE STRESS DE DISCO)
/*
use master
go
drop database dbteste

dbcc sqlperf (logspace)
go
sp_who 
select * from sysaltfiles

dbteste..sp_spaceused

*/
USE master
GO
IF EXISTS (SELECT name FROM sys.objects where name='tb_tempos')
	TRUNCATE TABLE tb_tempos
ELSE
	CREATE TABLE master..tb_tempos (Operacao varchar(100), tempo datetime)
GO

Declare @horaini datetime
Declare @duracao datetime
declare @patchdados varchar (200)
declare @patchlog varchar (200)
declare @string nvarchar (4000)

-- Define os discos\volumes de dados e log
SET @patchdados = 'H:\SQLP1-H-DADOS01\' --H:\SQLP1-H-DADOS01\
SET @patchlog = 'K:\SQLP1-K-LOG01\' --K:\SQLP1-K-LOG01\

-- Define disco\volume para backup\resrore
CREATE TABLE ##DiscoBackup (patchbackup varchar (200))
INSERT INTO  ##DiscoBackup VALUES ('H:\SQLP1-H-DADOS01\')

SET NOCOUNT ON
PRINT '====== Criando Banco de Dados com 129GB =========='
SET @horaini=getdate()

/*
CREATE DATABASE DBTESTE
ON 
(NAME = N'DBTESTE_Data', FILENAME = N'H:\SQLP1-H-DADOS01\DBTESTE_Data.mdf',SIZE = 28000, FILEGROWTH = 0) 
LOG ON (NAME = N'DBTESTE_LOG', FILENAME = N'H:\SQLP1-H-DADOS01\DBTESTE_Log.ldf',SIZE = 21000, FILEGROWTH = 0)

ALTER DATABASE [DBTESTE] ADD FILEGROUP [File1] 

ALTER DATABASE [DBTESTE] 
ADD FILE(NAME = N'DBTESTE_1_Data', 
FILENAME = N'H:\SQLP1-H-DADOS01\DBTESTE_Data1.NDF' , SIZE = 40000, FILEGROWTH = 0%) TO FILEGROUP [File1]

ALTER DATABASE [DBTESTE]
ADD FILE(NAME = N'DBTESTE_2_Data', 
FILENAME = N'H:\SQLP1-H-DADOS01\DBTESTE_2_Data2.ndf' , SIZE = 40000, FILEGROWTH = 0%) TO FILEGROUP [File1]
*/

SET @string='CREATE DATABASE DBTESTE ON 
(NAME = N''DBTESTE_Data'', FILENAME = N'''+ @patchdados +'DBTESTE_Data.mdf'',SIZE = 5000, FILEGROWTH = 0) 
LOG ON (NAME = N''DBTESTE_LOG'', FILENAME = N'''+@patchlog +'DBTESTE_Log.ldf'',SIZE = 3000, FILEGROWTH = 0)
ALTER DATABASE [DBTESTE] ADD FILEGROUP [File1] 
ALTER DATABASE [DBTESTE] ADD FILE(NAME = N''DBTESTE_1_Data'', FILENAME = N'''+ @patchdados + 'DBTESTE_Data1.NDF'' , SIZE = 1000, FILEGROWTH = 0%) TO FILEGROUP [File1]
ALTER DATABASE [DBTESTE] ADD FILE(NAME = N''DBTESTE_2_Data'', FILENAME = N'''+ @patchdados +'DBTESTE_2_Data2.ndf'' , SIZE = 1000, FILEGROWTH = 0%) TO FILEGROUP [File1]'

EXEC (@string)
 
ALTER DATABASE [DBTESTE] SET RECOVERY  SIMPLE

SET @duracao= getdate()- @horaini
INSERT INTO master..tb_tempos VALUES ('CREATE DATABASE', @duracao)
GO

-- ****** CRIAÇÃO DE DUAS TABELAS **********
USE DBTESTE
GO
PRINT ''
PRINT '====== Criando tabelas =========='
CREATE TABLE TESTE1(col1 int identity(1,1),col2 char(7000))ON File1
CREATE TABLE TESTE2(col1 int identity(1,1),col2 char(7000))

-- *********** INSERÇÃO DE REGISTROS NAS TABELAS *********
PRINT ''
PRINT '====== INSERINDO 500 mil registros na tabela TESTE1 ON FileGroup File1 =========='
set nocount on

Declare @horaini datetime
Declare @duracao datetime

SET @horaini = getdate()

declare @count int
SET @count =0
while @count < 5000
begin
INSERT INTO TESTE1 values ('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
Set @count = @count+1 
end

PRINT ''
PRINT '====== INSERINDO 500 mil registros na tabela TESTE2 ON PRIMARY =========='

SET @count =0
while @count < 5000
begin
INSERT INTO TESTE2 values ('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
Set @count = @count+1 
end

SET @duracao= getdate()- @horaini
INSERT INTO master..tb_tempos VALUES ('INSERT', @duracao)
GO

--backup log dbteste with truncate_only
GO

-- *********** CRIAÇÃO DE ÍNDICES /// Não é medido tempo /// *********
PRINT ''
PRINT '====== Criando ìndice Cluster em TESTE1 e TESTE2 =========='
GO
PRINT 'Criando índice em teste1'
CREATE clustered index idx_c_teste1 ON TESTE1 (Col1)
PRINT 'Criando índice em teste2'
CREATE clustered index idx_c_teste2 ON TESTE2 (Col1)

GO
--backup log dbteste with truncate_only
GO

-- *********** CHECKDB *********
PRINT ''
PRINT '=========== Executando CHECKDB ============='
Declare @horaini datetime
Declare @duracao datetime

SET @horaini = getdate()

DBCC CHECKDB(DBTESTE)

SET @duracao= getdate()- @horaini
INSERT INTO master..tb_tempos VALUES ('CHECKDB', @duracao)
GO

--backup log dbteste with no_log
GO


-- *********** INSERÇÃO DE REGISTROS NAS TABELAS *********
PRINT ''
PRINT '====== SELECT =========='
set nocount on

Declare @horaini datetime
Declare @duracao datetime
Declare @countrows int
SET @horaini = getdate()

declare @count int
SET @count =0
while @count < 100
begin

SELECT @countrows=COUNT (*) FROM TESTE1 INNER JOIN TESTE2
                                                                       ON TESTE1.col1 = TESTE2.col1 
ORDER BY NEWID() DESC
Set @count = @count+1 
end

SET @duracao= getdate()- @horaini
INSERT INTO master..tb_tempos VALUES ('SELECT 100000 vezes', @duracao)
GO

-- *********** DBREINDEX *********
PRINT ''
PRINT '=========== Executando DBREINDEX ============='
GO
Declare @horaini datetime
Declare @duracao datetime

SET @horaini = getdate()

EXEC master..sp_msforeachtable 'DBCC DBREINDEX (''?'')'

SET @duracao= getdate()- @horaini
INSERT INTO master..tb_tempos VALUES ('DBREINDEX', @duracao)
GO

--backup log dbteste with truncate_only
GO

-- *********** EXCLUSÃO DE ÍNDICES // Não é medido tempo /// *********
PRINT ''
PRINT 'excluindo índice em teste1'

DROP INDEX TESTE1.idx_c_teste1
--backup log dbteste with truncate_only

PRINT 'excluindo índice em teste2'
DROP INDEX TESTE2.idx_c_teste2
GO

--backup log dbteste with truncate_only
GO


-- *********** FAZ BACKUP\RESTORE DA BASE *********
PRINT ''
PRINT '====== Fazendo Backup da Base DBTESTE =========='
GO
USE MASTER
GO
Declare @horaini datetime
Declare @duracao datetime
Declare @patchbackup varchar(200)


SET @patchbackup= (SELECT patchbackup FROM ##DiscoBackup )
SET @horaini = getdate()

--BACKUP DATABASE DBTESTE TO DISK='H:\SQLP1-H-DADOS01\DBTESTE_BKP.BAK' WITH INIT
--EXEC ('BACKUP DATABASE DBTESTE TO DISK='''+@patchbackup+'DBTESTE_BKP.BAK'' WITH INIT')

SET @duracao= getdate()- @horaini
INSERT INTO master..tb_tempos VALUES ('BACKUP', @duracao)

GO
--backup log dbteste with truncate_only
GO

PRINT ''
PRINT '====== RESTAURANDO Backup da Base DBTESTE =========='
GO
USE MASTER
GO

Declare @horaini datetime
Declare @duracao datetime
Declare @patchbackup varchar(200)

SET @patchbackup= (SELECT patchbackup FROM ##DiscoBackup)
SET @horaini = getdate()

--RESTORE DATABASE DBTESTE FROM DISK='H:\SQLP1-H-DADOS01\DBTESTE_BKP.BAK' WITH REPLACE
--EXEC ('RESTORE DATABASE DBTESTE FROM DISK='''+@patchbackup+'DBTESTE_BKP.BAK'' WITH REPLACE')

SET @duracao= getdate()- @horaini
INSERT INTO master..tb_tempos VALUES ('RESTORE', @duracao)
GO

-- *********** Exclui Registros das Tabelas *********

USE DBTESTE
GO
PRINT ''
PRINT '====== Excluindo Registros das tabelas TESTE1 e TESTE2 =========='
GO
Declare @horaini datetime
Declare @duracao datetime

SET @horaini= getdate()

DELETE FROM TESTE1
--backup log dbteste with truncate_only
DELETE FROM TESTE2
--backup log dbteste with truncate_only

SET @duracao= getdate()- @horaini
INSERT INTO master..tb_tempos VALUES ('DELETE', @duracao)
GO

PRINT '====== Executando Shrink do Arqivo de Log =========='
Declare @horaini datetime
Declare @duracao datetime

SET @horaini= getdate()

DBCC SHRINKFILE (DBTESTE_LOG, 100)

SET @duracao= getdate()- @horaini
INSERT INTO master..tb_tempos VALUES ('SHRINKFILE', @duracao)
GO
SELECT * FROM master..tb_tempos 

-- Exclui tabela com tempos
DROP TABLE master..tb_tempos 
DROP TABLE ##DiscoBackup
GO
USE MASTER
GO
-- Excluir DB usado para teste
--IF db_id('DBTESTE') >0 DROP DATABASE [DBTESTE]

