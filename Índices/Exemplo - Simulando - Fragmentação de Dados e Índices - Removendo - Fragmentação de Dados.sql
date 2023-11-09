-- Acessando o Banco de Dados FATEC --
Use FATEC
Go


-- Consultando informa��es de fragmenta��o de Dados e �ndices na Tabela Alunos--
DBCC ShowContig('Alunos');


-- Parte 1 --
-- Desfragmentando o �ndice na Tabela Alunos --
DBCC INDEXDEFRAG (EXEMPLOS, "ALUNOS");

-- Consultando informa��es de fragmenta��o de Dados e �ndices na Tabela Alunos--
DBCC ShowContig('Alunos');


-- Parte 2 --
-- Reorganizando a estrutura l�gica do �ndice na Tabela Alunos --
ALTER INDEX PK_Alunos_RA ON ALUNOS REORGANIZE;

-- Consultando informa��es de fragmenta��o de Dados e �ndices na Tabela Alunos--
DBCC ShowContig('Alunos');


-- Parte 3 --
-- Reconstru�ndo a estrutura f�sica e l�gica do �ndice na Tabela Alunos --
ALTER INDEX PK_Alunos_RA ON ALUNOS Rebuild;

-- Consultando informa��es de fragmenta��o de Dados e �ndices na Tabela Alunos--
DBCC ShowContig('Alunos');


-- Encerrando --
-- Consultando informa��es sobre fragmenta��o de Dados e �ndices --
SELECT a.index_id, 
       name, 
       avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'Alunos'),NULL, NULL, NULL) AS a
      JOIN sys.indexes AS b 
	   ON a.object_id = b.object_id 
	   AND a.index_id = b.index_id;
Go