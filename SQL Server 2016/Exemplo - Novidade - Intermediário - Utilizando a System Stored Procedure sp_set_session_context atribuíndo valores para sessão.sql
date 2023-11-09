-- Declarando o elemento chave @MinhaVariavle e atribuíndo o valor Olá Mundo'
EXEC sp_set_session_context '@MinhaVariavel', 'Olá Mundo'
Go

-- Capturando e apresentando o valor armazenando para o elemento chave @MinhaVariavel --
SELECT SESSION_CONTEXT(N'@MinhaVariavel');
Go

-- Função Context_Info --
DECLARE @BinVar varbinary(128);  
SET @BinVar = Convert(varbinary(128),'Olá Mundo');  
SET CONTEXT_INFO @BinVar;  

SELECT CONTEXT_INFO() AS MyContextInfo,
       CONVERT(Varchar(128),@BinVar)  
GO  

-- Identificando os contadores globais de memória alocados para a sessão --
SELECT * FROM sys.dm_os_memory_cache_counters 
WHERE type = 'CACHESTORE_SESSION_CONTEXT'; 