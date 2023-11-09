
-- Garantindo o recovery FULL
ALTER DATABASE AdventureWorks2016 SET RECOVERY FULL
GO
BACKUP DATABASE AdventureWorks2016 TO DISK = 'd:\backup.bak' WITH COMPRESSION
GO
------------------------------------------------------
-- Encolhendo o TLog
DBCC LOGINFO(AdventureWorks2016)

BACKUP LOG AdventureWorks2016 TO DISK = 'bkplog.trn'
USE AdventureWorks2016
GO

DBCC SHRINKFILE (AdventureWorks2016_Log,1)
GO
DBCC LOGINFO(AdventureWorks2016)


------------------------------------------------------
-- Ajustando o tamanho do TLog
USE AdventureWorks2016
GO
ALTER DATABASE AdventureWorks2016 MODIFY FILE
(NAME = AdventureWorks2016_Log, SIZE = 2MB)
DBCC LOGINFO(AdventureWorks2016)

-- em outra sessão
USE AdventureWorks2016
GO
BEGIN TRAN
INSERT INTO dbo.pessoa
VALUES ('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'), 
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb'),
('bbbbbbbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb')
COMMIT
GO 2000

--------------------------------------------------------
-- Acompanhar até o VLF mais recente ficar no final do arquivo
DBCC LOGINFO(AdventureWorks2016)


-- Quando o VLF mais recente chegar ao final do arquivo
BACKUP LOG AdventureWorks2016 TO DISK = 'bkplog.trn'
DBCC LOGINFO(AdventureWorks2016)




-- DBCC SHRINKFILE vai liberar espaço em disco?
USE AdventureWorks2016
GO
DBCC SHRINKFILE (AdventureWorks2016_Log,1)
GO
DBCC LOGINFO(AdventureWorks2016)


-- exemplo do Shrink LOP_SHRINK_NOOP
select [Current LSN], Operation, Context, [Transaction ID], [Log Record Length], [Previous LSN], AllocUnitName, [Page ID], [Slot ID], [Checkpoint Begin], [Checkpoint End], [Minimum LSN], SPID, [Begin Time], [Transaction Name], [Parent Transaction ID], [Lock Information], Description, [RowLog Contents 0], [RowLog Contents 1], [Log Record] from ::fn_dblog(null, null)
Go


-------------------------------------------------------------

BACKUP LOG AdventureWorks2016 TO DISK = 'bkplog.trn'
DBCC LOGINFO(AdventureWorks2016)

-- again --> DBCC SHRINKFILE vai liberar espaço em disco?
USE AdventureWorks2016
GO
DBCC SHRINKFILE (AdventureWorks2016_Log,1)
GO
DBCC LOGINFO(AdventureWorks2016)