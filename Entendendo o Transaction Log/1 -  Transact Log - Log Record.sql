-- Altera o Recovery Model para SIMPLE
ALTER DATABASE AdventureWorks2016 SET RECOVERY SIMPLE

-- Trunca o TLog
CHECKPOINT

-- BACKUP DATABASE AdventureWorks2016 TO DISK = 'D:\BkpFull.bak' WITH COMPRESSION

-- Conteúdo do log - todas as colunas
USE AdventureWorks2016
select * from ::fn_dblog(null, null)
Go

--update
USE AdventureWorks2016
Begin Transaction
UPDATE dbo.Pessoa SET nome = 'XUXA' where ID=3
Rollback


--conteudo do log
select [Current LSN], Operation, Context, [Transaction ID], [Log Record Length], [Previous LSN], AllocUnitName, [Page ID], [Slot ID], [Checkpoint Begin], [Checkpoint End], [Minimum LSN], SPID, [Begin Time], [Transaction Name], [Parent Transaction ID], [Lock Information], Description, [RowLog Contents 0], [RowLog Contents 1], [Log Record] from ::fn_dblog(null, null)
Go

-- LSN					identifica cada registro e garante qual aconteceu primeiro
-- tipo					begin, commit, checkpoint, update, delete, insert, modify, alloc, format, etc
-- contexto				objeto que sofreu a ação
-- ID					primeira transação?
-- Tamanho				tamanho do registro
-- Previus LSN			LSN do registro anterior
-- RowLog Contents 0	armazena o before image (undo info)
-- RowLog Contents 1	armazena o after image (redo info)
-- Log Record			representação numerica do registro


--DBCC SQLPERF
DBCC SQLPERF(LOGSPACE)