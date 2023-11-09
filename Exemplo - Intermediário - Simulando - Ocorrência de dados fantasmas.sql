-- Criando o Banco de Dados - GhostDB --
Create Database GhostDB
Go

-- Acessando o Banco de Dados --
Use GhostDB
Go

-- Criando a Tabela GhostTable --
Create Table GhostTable
 (GhostRecord Int)
Go
  
-- Criando um �ndice clusterizado --
Create Clustered Index Ind_GhostTable_GhostRecord On GhostTable(GhostRecord)
Go
	 
-- Inserindo Dados na Tabela GhostTable --
Insert Into GhostTable
Select 100
Go

-- Obtendo informa��es sobre as estat�sticas de aloca��o de dados --
Select object_id, 
           index_id, 
           index_depth,
		   index_level 
From sys.dm_db_index_physical_stats(db_id(),
                                                               object_id('GhostTable'),
															   object_id('Ind_GhostTable_GhostRecord'),
															   null,
															   null)
Go

-- Obtendo informa��es sobre o �ndice IND_GhostTable_GhostRecord --
Select id,
           name,
		   root,
		   first 
		   from 
sys.sysindexes 
where id=565577053 -- Aqui voc� vai colocar o ID identificado do �ndice apresentado na sua m�quina
Go

-- Identificando a p�gina de dados que contem os dados inseridos na GhostTable --
SELECT first_page,
            (convert(varchar(2), (convert(int, substring(first_page, 6, 1)) * power(2, 8)) +
            (convert(int, substring(first_page, 5, 1)))) + ':' + convert(varchar(11),
            (convert(int, substring(first_page, 4, 1)) * power(2, 24)) +
            (convert(int, substring(first_page, 3, 1)) * power(2, 16)) +
            (convert(int, substring(first_page, 2, 1)) * power(2, 8)) +
            (convert(int, substring(first_page, 1, 1))))) As Page
FROM SYS.SYSTEM_INTERNALS_ALLOCATION_UNITS
Where first_page = 0x180100000100 -- Valor obtido no bloco de c�digo anterior atrav�s da coluna root --
Go

-- Habilitando a Trace Flag 3604 para apresentar informa��es sobre as p�ginas de dados --
DBCC TRACEON (3604)
GO

-- Consultando informa��es sobre as p�ginas de dados relacionadas o �ndice Ind_GhostTable_GhostRecord --
DBCC PAGE(GhostDB,1,280,1)
Go

Ao obter o resultado do DBCC Page procure pela coluna m_ghostRecCnt, neste momento ela deve esta apresentando o valor
m_ghostRecCnt = 0

-- Exclu�ndo os registros em GhostTable --
Delete from GhostTable 
Where GhostRecord=100
Go

-- Consultando informa��es sobre as p�ginas de dados relacionadas o �ndice Ind_GhostTable_GhostRecord --
DBCC PAGE(GhostDB,1,280,3)
Go

Agora verifique novamente a coluna m_ghostRecCnt que neste momento dever� apresentar o valor igual � m_ghostRecCnt = 1,
este � o indicador da ocorr�ncia de um dado fantasma em nossa tabela, pois o Microsoft SQL Server ainda n�o confirmou o 
procedimento de delete realizado anteriormente.

-- Confirmando a exist�ncia de um registro fantasmas --
SELECT db_name(database_id), 
                object_name(object_id),
                ghost_record_count,
                version_ghost_record_count
FROM sys.dm_db_index_physical_stats(DB_ID(N'GhostDB'), OBJECT_ID(N'GhostTable'), NULL, NULL , 'DETAILED')
GO

-- Eliminando registros fantasmas --
Alter Table GhostTable Rebuild
Go

-- Confirmando a exist�ncia de um registros fantasmas --
SELECT db_name(database_id), 
                object_name(object_id),
                ghost_record_count,
                version_ghost_record_count
FROM sys.dm_db_index_physical_stats(DB_ID(N'GhostDB'), OBJECT_ID(N'GhostTable'), NULL, NULL , 'DETAILED')
GO

-- Liberando espa�o alocado anteriormente em disco pelos registros fantasmas --
Exec sp_clean_db_free_space @dbname=N'GhostDB'
Go