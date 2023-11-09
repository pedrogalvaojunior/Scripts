
-- Preparando a base - 1m10s se não preparada na demo 5
ALTER DATABASE AdventureWorks2016 SET RECOVERY FULL
GO
BACKUP DATABASE AdventureWorks2016 TO DISK = 'd:\backup.bak' WITH COMPRESSION
GO

-- encolhendo o TLog
BACKUP LOG AdventureWorks2016 TO DISK = 'bkplog.trn'
DBCC LOGINFO(AdventureWorks2016)

USE AdventureWorks2016
GO
DBCC SHRINKFILE (AdventureWorks2016_Log,1)
GO
DBCC LOGINFO(AdventureWorks2016)


-- Ajustando o tamanho do TLog
USE AdventureWorks2016
GO
DBCC SHRINKFILE (AdventureWorks2016_Log,1)
GO
DBCC LOGINFO(AdventureWorks2016)

ALTER DATABASE AdventureWorks2016 MODIFY FILE
(NAME = AdventureWorks2016_Log, SIZE = 4MB)
DBCC LOGINFO(AdventureWorks2016)



--...em outra sessão:
BACKUP DATABASE AdventureWorks2016 TO DISK = 'd:\backup.bak'

-- ...em mais outra sessão
USE AdventureWorks2016
GO
WHILE 1=1
BEGIN
INSERT INTO dbo.pessoa
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
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb')
END


-- se fizer backup do TLog acontece o truncate?
BACKUP LOG AdventureWorks2016 TO DISK = 'bkplog.trn'
DBCC LOGINFO(AdventureWorks2016)
CHECKPOINT
SELECT name, log_reuse_wait_desc FROM sys.databases WHERE name = 'AdventureWorks2016'

-- Ajustando o tamanho do TLog
USE AdventureWorks2016
GO
DBCC SHRINKFILE (AdventureWorks2016_Log,1)
GO
DBCC LOGINFO(AdventureWorks2016)

