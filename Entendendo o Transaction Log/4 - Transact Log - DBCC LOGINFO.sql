USE MASTER
GO

--limpa sujeira
USE MASTER
GO
IF EXISTS(SELECT * from sys.databases WHERE name='TestDB')
BEGIN
    ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE TestDB;
END
GO


--cria a base
CREATE DATABASE TestDB
ON PRIMARY
(NAME = 'TestDB_data', FILENAME = 'D:\MSSQL\TestDB_data.mdf')
LOG ON
(Name = 'TestDB_Log', FILENAME = 'D:\MSSQL\TestDB_log.ldf', SIZE = 10MB, FILEGROWTH = 10MB)
GO

DBCC LOGINFO(TestDB)

--RecoverUnitID   - apareceu no SQL 2012 mas ainda n�o � utilizado;
--FileID          - ID do arquivo, LDF geralmente � 2 mas poderia ter um 3� ou 4�;
--FileSize        - tamanho do VLF em bytes
--StartOffset     - inicia logo ap�s o header de 8KB
--FSeqNo          - o primeiro Sequence Number dos VLFs que vem da Model + 1;
--Status          - 0 = inativo  |  2 = ativo  |  1 = desconhecido
--Parity          - 0 = nunca foi usado  |  64/128 = muda a cada reutiliza��o do VLF
--CreateLSN       - 0 = criado junto com a base


--crescendo o TLog manualmente em 10MB
ALTER DATABASE TestDB MODIFY FILE
(NAME = 'TestDB_Log',
SIZE = 20MB);
GO

DBCC LOGINFO(TestDB)

--crescemos 20MB
--4 novos VLFs de 2,5MB  -  5242880/1024/1024 = 2,5MB
--�nico VLF ativo � o 32
--transa��o que aumentou a quantidade de VLFs come�a com 32






