
--abrir Perfmon com TLog infos
SELECT name, recovery_model_desc FROM sys.databases WHERE name = 'AdventureWorks2016'



USE AdventureWorks2016
ALTER DATABASE AdventureWorks2016 SET RECOVERY SIMPLE


--em outra sessão

USE AdventureWorks2016

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




-- voltar o Recovery Model
ALTER DATABASE AdventureWorks2016 SET RECOVERY FULL
GO
BACKUP DATABASE AdventureWorks2016 TO DISK = 'd:\backupcompress.bak' WITH COMPRESSION, DIFFERENTIAL
GO