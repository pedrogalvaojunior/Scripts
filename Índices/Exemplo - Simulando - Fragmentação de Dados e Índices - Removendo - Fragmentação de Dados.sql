-- Acessando o Banco de Dados FATEC --
Use FATEC
Go


-- Consultando informações de fragmentação de Dados e Índices na Tabela Alunos--
DBCC ShowContig('Alunos');


-- Parte 1 --
-- Desfragmentando o Índice na Tabela Alunos --
DBCC INDEXDEFRAG (EXEMPLOS, "ALUNOS");

-- Consultando informações de fragmentação de Dados e Índices na Tabela Alunos--
DBCC ShowContig('Alunos');


-- Parte 2 --
-- Reorganizando a estrutura lógica do Índice na Tabela Alunos --
ALTER INDEX PK_Alunos_RA ON ALUNOS REORGANIZE;

-- Consultando informações de fragmentação de Dados e Índices na Tabela Alunos--
DBCC ShowContig('Alunos');


-- Parte 3 --
-- Reconstruíndo a estrutura física e lógica do Índice na Tabela Alunos --
ALTER INDEX PK_Alunos_RA ON ALUNOS Rebuild;

-- Consultando informações de fragmentação de Dados e Índices na Tabela Alunos--
DBCC ShowContig('Alunos');


-- Encerrando --
-- Consultando informações sobre fragmentação de Dados e Índices --
SELECT a.index_id, 
       name, 
       avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'Alunos'),NULL, NULL, NULL) AS a
      JOIN sys.indexes AS b 
	   ON a.object_id = b.object_id 
	   AND a.index_id = b.index_id;
Go