-- Passo 1 - Criando Banco de Dados e Alterando Recovery Model --
USE [master];
Go

CREATE DATABASE LendoArquivoLog
On Primary
(Name = 'LendoArquivoLog',
 FileName = 'C:\Bancos\LendoArquivoLog_Data',
 Size=1024MB,
 MaxSize=2048MB,
 FILEGROWTH = 1024KB)
Log On
(Name = 'LendoArquivoLog_Log',
 FileName = 'C:\Bancos\LendoArquivoLog_Log',
 Size=1024MB,
 MaxSize=2048MB,
 FILEGROWTH = 1024KB)  
Go

-- Passo 1.1 - Alterando o Recovery Model --
Alter Database LendoArquivoLog
Set Recovery Full
Go

-- Acessando o Banco de Dados --
USE LendoArquivoLog;
Go


-- Passo 1.2 - Criando a Tabela Localizacao --
CREATE TABLE Localizacao 
(ID INT IDENTITY,
 Date DATETIME DEFAULT GETDATE (),
 City CHAR (25) DEFAULT 'São Roque');
Go

-- Passo 2 - Inserindo dados na Tabela Localizacao --
INSERT INTO Localizacao DEFAULT VALUES
Go 100

-- Passo 2.1 - Realizando Backup Full e Log--
Backup Database LendoArquivoLog
To Disk = 'C:\Bancos\Backup-Full-LendoArquivoLog.bak'
With Init, NoFormat
Go

Backup Log LendoArquivoLog
To Disk = 'C:\Bancos\Backup-Log-LendoArquivoLog.trn'
With Init, NoFormat
Go

-- Passo 3 - Excluíndo dados na Tabela Localizacao --
DELETE Localizacao 
WHERE ID < 10
Go

Select * from Localizacao

/* Passo 4 - Procurando informações sobre os dados excluídos no Arquivo de Logo, através da Função fn_dblog e 
operador 'LOP_DELETE_ROWS'*/

SELECT [Current LSN],    
       [Transaction ID],
       Operation,
       Context,
       AllocUnitName 
FROM fn_dblog(NULL, NULL) 
WHERE Operation = 'LOP_DELETE_ROWS'
Go

/* Passo 5 - Utilizando Transaction_ID encontrado acima e operador LOP_BEGIN_XACT para identificar a 
Current LSN, Transaction Name e Transaciont SID -- Armazenar Current LSN */

SELECT [Current LSN],    
       Operation,
       [Transaction ID],
       [Begin Time],
       [Transaction Name],
       [Transaction SID]
FROM fn_dblog(NULL, NULL)
WHERE [Transaction ID] = '0000:00000355'
AND [Operation] = 'LOP_BEGIN_XACT'
Go

-- Passo 6 - Restaurando o Banco de Dados LendoArquivoLog, sem liberação de uso --
Use Master
Go

RESTORE DATABASE LendoArquivoLogCOPY
 FROM DISK = 'C:\Bancos\Backup-Full-LendoArquivoLog.bak'
 WITH REPLACE, NORECOVERY,
 MOVE 'LendoArquivoLog' TO 'C:\Bancos\LendoArquivoLogCopy.mdf',
 MOVE 'LendoArquivoLog_Log' TO 'C:\Bancos\LendoArquivoLogCopy_log.ldf';
Go

/* Passo 7 -  Restaurando o Banco de Dados LendoArquivoLog utilizando a opção STOPBEFOREMARK operation,
convertendo o Current LSN 0000001f:000001ff:0001 para Decimal, dividido em três partes:

A - 0000001f = 31
B - 000001ff = 511
C - 0001 = 1

Agora fazer a junção onde a parte A é mantida, mas a parte B será concatenada com mais 7 zeros e a parte C
será concatenada com mais 4 zeros.

A - 31
B - 511 = 00000000511
C - 1 = 00001

O valor em decimal será:  31000000051100001*/

RESTORE LOG LendoArquivoLogCOPY
FROM DISK = N'C:\Bancos\Backup-Log-LendoArquivoLog.trn'
WITH STOPBEFOREMARK = 'lsn:31000000051100001'
Go

Restore Database LendoArquivoLogCOPY With Recovery
Go

-- Passo 8 - Validando o restauração do Backup Database e Log --
USE LendoArquivoLogCOPY
Go
SELECT * from Localizacao

-- Passo 9 - Migrando os dados para o Banco LendoArquivoLog --
Use LendoArquivoLog
Go

-- Passo 9.1 -- Desativando o Identity --
Set Identity_Insert Localizacao On
Go

-- Passo 9.2 - Inserindo os Dados --
Insert Into Localizacao (Id, Date, City)
Select Id, Date, City  from LendoArquivoLogCopy.dbo.Localizacao
Where Id < 10
Order By ID
Go

-- Passo 9.3 - Validando a recuperação dos Registros --
SELECT * from Localizacao

-- Passo 9.4 - Reativando o Identity --
Set Identity_Insert Localizacao Off
Go