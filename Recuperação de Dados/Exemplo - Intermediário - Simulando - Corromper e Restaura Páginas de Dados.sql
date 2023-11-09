-- Criando o Banco de Dados --
Create Database RestoreDatabasePage
Go

-- Acessando --
Use RestoreDatabasePage
Go

-- Criando a TabelaIntegra --
Create Table TabelaIntegra
(Codigo Int Identity(0,2), 
 ValorGUID UniqueIdentifier, 
 ValorRandomico BigInt, 
 ColunaGrande Char(100) Default 'TI')
Go

-- Criando o Índice Clusterizado na TabelaIntegra --
Create Clustered Index Ind_TabelaIntegra_Codigo On TabelaIntegra(Codigo)
Go

-- Criando a TabelaCorrompida --
Create Table TabelaCorrompida
(Codigo Int Identity(0,2), 
 ValorGUID UniqueIdentifier, 
 ValorRandomico BigInt, 
 ColunaGrande Char(100) Default 'TC')
Go

-- Criando o Índice Clusterizado na TabelaCorrompida --
Create Clustered Index Ind_TabelaCorrompida_Codigo On TabelaCorrompida(Codigo)
Go

-- Desabilitando a contagem de linhas processadas --
Set NoCount On
Go

-- Inserindo a massa de dados aleatórios --

-- Declarando a variável de controle @Contador --
Declare @Contador Int = 0

-- Abrindo bloco de transação Trans1 --
Begin Transaction Trans1

  While @Contador <= 132768
   Begin
      Insert Into TabelaIntegra (ValorGUID, ValorRandomico) 
      Values (NewId(), ABS(CHECKSUM(Rand()* 200000000)))

      Insert Into TabelaCorrompida(ValorGUID, ValorRandomico) 
      Values (NewId(), ABS(CHECKSUM(Rand()* 200000000)))

      Set @Contador += 2
   End

-- Confirmando e encerrando o bloco de transação Trans1 --
Commit Transaction Trans1
Go

-- Verificando a integridade física e lógico do banco de dados --
Dbcc CheckDB('RestoreDatabasePage') WITH NO_INFOMSGS
Go

-- Realizando o Backup do Banco de Dados --
Backup Database RestoreDatabasePage
To Disk = 'S:\MSSQL-2017\Backup\RestoreDatabasePage-Backup-Full.bak'  
 With Compression,
 NoFormat,
 Init,
 Stats=10
Go

-- Obtendo as 100 primeiras páginas de dados e seus respectivos números de slots --
Select TOP 100 sys.fn_PhysLocFormatter(%%physloc%%) PageId, * FROM TabelaCorrompida
Go

/* Escolher duas páginas e valores 
(1:256:10) - 20 - 6460AAB3-AD12-47BB-B179-8C1930B1A287
(1:258:1) - 120 - AEF17F9D-D838-4FEF-B723-CA3658D03319
*/

-- Preparando-se para corromper a estrutura de páginas --
Use Master
Go

-- Limitando a conexão do Banco de Dados para Single_User --
Alter Database RestoreDatabasePage 
Set Single_User 
With Rollback Immediate
Go

-- Obtendo informações sobre os slots de alocação de dados --
Dbcc TraceOn (3604)
Go

-- Procurar valor 6460AAB3-AD12-47BB-B179-8C1930B1A287 e guardar slots --
Dbcc Page ('RestoreDatabasePage', 1, 256, 3);
Go

/*Slot 10 Column 0 Offset 0x0 Length 4 Length (physical) 0

UNIQUIFIER = 0                      

Slot 10 Column 1 Offset 0x4 Length 4 Length (physical) 4

Codigo = 20                         

Slot 10 Column 2 Offset 0x8 Length 16 Length (physical) 16

ValorGUID = 6460aab3-ad12-47bb-b179-8c1930b1a287                         

Slot 10 Column 3 Offset 0x18 Length 8 Length (physical) 8

ValorRandomico = 1523653229         

Slot 10 Column 4 Offset 0x20 Length 100 Length (physical) 100

ColunaGrande = TC*/                                                                                            

-- Corrompendo página 256 --
--DBCC WRITEPAGE (databasename, fileid, pageid, offset, length, data, directORbypassbufferpool)--
Dbcc WritePage ('RestoreDatabasePage', 1, 256, 8, 16, 0x00000000000000000000000000000001, 1)
Go

-- Procurar valor AEF17F9D-D838-4FEF-B723-CA3658D03319 e guardar slots --
Dbcc Page ('RestoreDatabasePage', 1, 258, 3);
Go

/*Slot 1 Column 0 Offset 0x0 Length 4 Length (physical) 0

UNIQUIFIER = 0                      

Slot 1 Column 1 Offset 0x4 Length 4 Length (physical) 4

Codigo = 120                        

Slot 1 Column 2 Offset 0x8 Length 16 Length (physical) 16

ValorGUID = aef17f9d-d838-4fef-b723-ca3658d03319                         

Slot 1 Column 3 Offset 0x18 Length 8 Length (physical) 8

ValorRandomico = 1089833615         

Slot 1 Column 4 Offset 0x20 Length 100 Length (physical) 100

ColunaGrande = TC*/

-- Corrompendo página 258 --
Dbcc WritePage ('RestoreDatabasePage', 1, 258, 8, 16, 0x00000000000000000000000000000001, 1)
Go

-- Alterando o acesso ao Banco de Dados para Multi_User --
Alter Database RestoreDatabasePage
Set Multi_User
Go

-- Realizar testes de integridade consultando dados na TabelaCorrompida --
Use RestoreDatabasePage
Go

Select Count(Codigo) From TabelaCorrompida
Go

-- Realizar testes de integridade consultando dados na TabelaIntegra --
Select Count(Codigo) From TabelaIntegra
Go

-- Realizando a Restauração das Páginas de Dados --
Use Master
Go

-- Restore Database Page --
Restore Database RestoreDatabasePage 
PAGE='1:256, 1:258' -- Informando os números de páginas 
 From Disk = N'S:\MSSQL-2017\Backup\RestoreDatabasePage-Backup-Full.bak' 
 With File = 1, -- Especificando o arquivo de dados 
 NoRecovery,  -- Não liberando o banco para acesso
 Stats = 10
Go

-- Realizar novo teste de integridade consultando dados na TabelaCorrompida --
Use RestoreDatabasePage
Go

Select Count(Codigo) From TabelaCorrompida
Where Codigo Not Between 20 And 120
Go

-- Backupear o Log e Restaura para Liberar páginas marcadas como pendentes --
Use Master
Go

Backup Log RestoreDatabasePage
To Disk = 'S:\MSSQL-2017\Backup\RestoreDatabasePage-Backup-Log.bak' 
 With NoFormat, 
 Init, 
 Name = N'RestoreDatabasePage-Backup-Log', 
 Stats=10
Go
				
-- Restaurar Log --
Restore Log RestoreDatabasePage 
 From Disk = 'S:\MSSQL-2017\Backup\RestoreDatabasePage-Backup-Log.bak'  
 With Recovery, 
 Replace, 
 Stats = 10
Go	

-- Realizar último teste de integridade consultando dados na TabelaCorrompida --
Use RestoreDatabasePage
Go

Select Parcial=(Select Count(Codigo) From TabelaCorrompida Where Codigo Not In (20,120)),
           Geral=(Select Count(Codigo) From TabelaCorrompida)
Go
