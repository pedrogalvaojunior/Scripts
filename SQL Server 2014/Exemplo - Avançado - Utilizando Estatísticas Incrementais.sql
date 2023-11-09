-- Criando o Banco de Dados IncrementalStatistics--
Create Database IncrementalStatistics
Go

-- Adicionando os Filegroups --
Alter Database IncrementalStatistics Add Filegroup IncrementalStatisticsGrupo1
Go

Alter Database IncrementalStatistics Add Filegroup IncrementalStatisticsGrupo2
Go

Alter Database IncrementalStatistics Add Filegroup IncrementalStatisticsGrupo3
Go

Alter Database IncrementalStatistics Add Filegroup IncrementalStatisticsGrupo4
Go

-- Adicionando os Arquivos aos seus respectivos Filegroups --
Alter Database IncrementalStatistics 
Add File (Name = N'IncrementalStatisticsGrupo1', 
          FileName = N'S:\MSSQL-2016\Data\Arquivo-Grupo1-Data.ndf', 
		  Size = 4096KB, 
		  FileGrowth =1024KB) To Filegroup IncrementalStatisticsGrupo1
Go

Alter Database IncrementalStatistics 
Add File (Name = N'IncrementalStatisticsGrupo2', 
          FileName = N'S:\MSSQL-2016\Data\Arquivo-Grupo2-Data.ndf', 
		  Size = 4096KB, 
		  FileGrowth =1024KB) To Filegroup IncrementalStatisticsGrupo2
Go

Alter Database IncrementalStatistics 
Add File (Name = N'IncrementalStatisticsGrupo3', 
          FileName = N'S:\MSSQL-2016\Data\Arquivo-Grupo3-Data.ndf', 
		  Size = 4096KB, 
		  FileGrowth =1024KB) To Filegroup IncrementalStatisticsGrupo3
Go

Alter Database IncrementalStatistics 
Add File (Name = N'IncrementalStatisticsGrupo4', 
          FileName = N'S:\MSSQL-2016\Data\Arquivo-Grupo4-Data.ndf', 
		  Size = 4096KB, 
		  FileGrowth =1024KB) To Filegroup IncrementalStatisticsGrupo4
Go

-- Criando a Partition Function PartitionFunctionIncrementalStatistics --
USE IncrementalStatistics
GO

Create PARTITION FUNCTION PartitionFunctionIncrementalStatistics (Int) 
AS 
RANGE RIGHT FOR VALUES
  (20171, 20172,20173,20174)
Go

/*Onde
20171 - Primeiro Quartil
20172 - Segundo Quartil
20173 - Terceiro Quartil
20174 - Quarto Quartil */

-- Criando o Partition Scheme PartitionSchemeIncrementalStatistics --
Create PARTITION SCHEME PartitionSchemeIncrementalStatistics AS
PARTITION PartitionFunctionIncrementalStatistics 
TO
  (
   IncrementalStatisticsGrupo1,
   IncrementalStatisticsGrupo2,
   IncrementalStatisticsGrupo3,
   IncrementalStatisticsGrupo4,
   [PRIMARY])
Go

-- Criando a Tabela TableIncrementalStatistics --
Create Table TableIncrementalStatistics
(ID Int Null,
 Acao NVarchar(40) Default NewID(),
 Data DateTime Null,
 Quartil  AS (datepart(year,[Data])*(10)+datepart(quarter,[Data])) PERSISTED
) ON PartitionSchemeIncrementalStatistics (Quartil)
Go

-- Habilitando o uso de Incremental Statistics --
Alter Database IncrementalStatistics  
 Set Auto_Create_Statistics On (INCREMENTAL = On)
Go

/*Se as estatísticas incremental não está habilitada no nível do banco de dados, 
você precisa habilitá-lo ao definir o índice clusterizado da tabela girando sobre o 
STATISTICS_INCREMENTAL da seguinte forma: */
Create Clustered Index Ind_TableIncrementalStatistics_ID
On [TableIncrementalStatistics] (ID) With (Statistics_Incremental=On)
GO

-- Confirmando se as estatísticas incrementais esta habilita --
Select 
    OBJECT_NAME(object_id) TableName
   ,name 
   ,is_incremental
   ,stats_id
FROM sys.stats
WHERE name = 'Ind_TableIncrementalStatistics_ID'
Go

-- Inserindo os dados na TableIncrementalStatistics --
Insert Into TableIncrementalStatistics (ID, Data) 
Values (1, '2017-11-22')
Go 2000

Insert Into TableIncrementalStatistics (ID, Data) 
Values (2, '2017-06-05')
Go 2000

Insert Into TableIncrementalStatistics (ID, Data) 
Values (3, '2017-01-25')
Go 2000

Insert Into TableIncrementalStatistics (ID, Data)
Values (4, '2017-08-13')
Go 2000

-- Consultando a distribuição e particionamento dos dados --
Select partition_number, rows
From sys.partitions
Where OBJECT_NAME(OBJECT_ID)='TableIncrementalStatistics'
Go

-- Consultando dados na TableIncrementalStatistics --
Select Id, Acao, Data, Quartil From TableIncrementalStatistics
Where ID = 1
Go

Select Id, Acao, Data, Quartil From TableIncrementalStatistics
Where ID >= 2
Go

Select Id, Acao, Data, Quartil From TableIncrementalStatistics
Where ID <> 3
Go

-- Consultando as informações sobre as estatísticas da tabela TableIncrementalStatistics --
Select object_id, stats_id , last_updated , rows , rows_sampled , steps  
From sys.dm_db_stats_properties(OBJECT_ID('[TableIncrementalStatistics]'),1)
Go

-- Excluíndo 1.500 linhas --
Delete Top (1500) From TableIncrementalStatistics
Where ID = 2
Go

-- Consultando os dados --
Select Id, Acao, Data, Quartil From TableIncrementalStatistics
Where ID <> 4
Go

-- Consultando as informações sobre as estatísticas da tabela TableIncrementalStatistics --
Select object_id, stats_id , last_updated , rows , rows_sampled , steps  
From sys.dm_db_stats_properties(OBJECT_ID('[TableIncrementalStatistics]'),1)
Go

-- Consultando as informações sobre as estatísticas incrementais --
Select object_id, stats_id,
       partition_number, 
	   last_updated, 
	   rows, rows_sampled, 
       steps 
From sys.dm_db_incremental_stats_properties(OBJECT_ID('TableIncrementalStatistics'),1)
Go 