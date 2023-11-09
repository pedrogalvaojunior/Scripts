CREATE DATABASE STOPAT_Test;
GO

USE STOPAT_Test;
GO

ALTER DATABASE STOPAT_Test SET Recovery FULL
GO

CREATE TABLE MyData
(
ID			INT IDENTITY(1,1),
DataValue	VARCHAR(50) NOT NULL
);
GO

INSERT INTO MyData(DataValue) VALUES ('The First Entry');

BACKUP DATABASE [STOPAT_Test] TO DISK = N'C:\backup\STOPAT_Test_Full.bak' WITH CHECKSUM, INIT, STATS=10

BEGIN TRAN MyTran1 WITH MARK 'Tran1'
INSERT INTO MyData(DataValue) VALUES ('The Second Entry');
COMMIT TRAN MyTran1

BACKUP LOG [STOPAT_Test] TO DISK = N'C:\backup\STOPAT_Test_Log_1.trn' WITH CHECKSUM, INIT, STATS=10

INSERT INTO MyData(DataValue) VALUES ('The Third Entry');

BEGIN TRAN MyTran2 WITH MARK 'Tran2'
INSERT INTO MyData(DataValue) VALUES ('The Fourth Entry');
COMMIT TRAN MyTran2

BACKUP LOG [STOPAT_Test] TO DISK = N'C:\backup\STOPAT_Test_Log_2.trn' WITH CHECKSUM, INIT, STATS=10

INSERT INTO MyData(DataValue) VALUES ('The Fifth Entry');

BACKUP LOG [STOPAT_Test] TO DISK = N'C:\backup\STOPAT_Test_Log_3.trn' WITH CHECKSUM, INIT, NO_TRUNCATE, STATS=10


/* check data */
SELECT * FROM dbo.MyData

/* start restore process */
ALTER DATABASE [STOPAT_Test] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE master
GO

RESTORE DATABASE [STOPAT_Test] FROM DISK = N'C:\backup\STOPAT_Test_Full.bak' WITH REPLACE, NORECOVERY, STATS=10

RESTORE LOG [STOPAT_Test] FROM DISK = N'C:\backup\STOPAT_Test_Log_1.trn' WITH STOPBEFOREMARK = 'MyTran1', STANDBY = N'C:\backup\stndby.sbf', STATS=10

USE STOPAT_Test
GO

/* only data from before the transaction is there STOPBEFOREMARK */
SELECT * FROM dbo.MyData


USE MASTER
GO

RESTORE LOG [STOPAT_Test] FROM DISK = N'C:\backup\STOPAT_Test_Log_1.trn' WITH STOPATMARK = 'MyTran1', STANDBY = N'C:\backup\stndby.sbf', STATS=10

USE STOPAT_Test
GO
/* we stopped AT the mark now, so we have the data */
SELECT * FROM dbo.MyData

USE MASTER
GO

/* finish any transaction from the end of Log_1.trn and stop BEFORE MyTran2 */
RESTORE LOG [STOPAT_Test] FROM DISK = N'C:\backup\STOPAT_Test_Log_1.trn' WITH STANDBY = N'C:\backup\stndby.sbf', STATS=10
RESTORE LOG [STOPAT_Test] FROM DISK = N'C:\backup\STOPAT_Test_Log_2.trn' WITH STOPBEFOREMARK = 'MyTran2', RECOVERY, STATS=10
GO

USE STOPAT_Test
GO

/* everything before MyTran 2 */
SELECT * FROM dbo.MyData

ALTER DATABASE STOPAT_Test SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO


USE master
GO
DROP DATABASE [STOPAT_Test]