-- Declarando o elemento chave @MinhaVariavle e atribu�ndo o valor Ol� Mundo'
EXEC sp_set_session_context '@MinhaVariavel', 'Ol� Mundo'
Go

-- Capturando e apresentando o valor armazenando para o elemento chave @MinhaVariavel --
SELECT SESSION_CONTEXT(N'@MinhaVariavel');
Go

-- Fun��o Context_Info --
DECLARE @BinVar varbinary(128);  
SET @BinVar = Convert(varbinary(128),'Ol� Mundo');  
SET CONTEXT_INFO @BinVar;  

SELECT CONTEXT_INFO() AS MyContextInfo,
       CONVERT(Varchar(128),@BinVar)  
GO  

-- Identificando os contadores globais de mem�ria alocados para a sess�o --
SELECT * FROM sys.dm_os_memory_cache_counters 
WHERE type = 'CACHESTORE_SESSION_CONTEXT'; 