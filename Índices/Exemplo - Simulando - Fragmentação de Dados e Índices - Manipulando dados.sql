-- Acessando o Banco de Dados FATEC --
Use FATEC
Go

-- Consultando informações sobre fragmentação de Dados e Índices --
SELECT a.index_id, 
       name, 
       avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'Alunos'),NULL, NULL, NULL) AS a
      JOIN sys.indexes AS b 
	   ON a.object_id = b.object_id 
	   AND a.index_id = b.index_id;

-- Iniciando a Fragmentação de Dados --

-- 1 - Excluíndo algumas linhas de registro na Tabela Alunos --     
Delete from Alunos
Where Codigo Between 750 And 980

-- Consultando informações sobre fragmentação de Dados e Índices --
SELECT a.index_id, 
       name, 
       avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'Alunos'),NULL, NULL, NULL) AS a
      JOIN sys.indexes AS b 
	   ON a.object_id = b.object_id 
	   AND a.index_id = b.index_id;
Go

-- 2 - Inserindo nova Massa de Dados na Tabela Alunos --
Declare @Contador Int

Set @Contador=1001

While @Contador <=3000
 Begin
 
  Insert Into Alunos(Codigo, Nome, DataNascimento)
              Values(@Contador,'Pedro',DATEADD(DAY,@Contador,GETDATE()))
              
  Set @Contador=@Contador+1
 End
 
-- Consultando informações sobre fragmentação de Dados e Índices --
SELECT a.index_id, 
       name, 
       avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'Alunos'),NULL, NULL, NULL) AS a
      JOIN sys.indexes AS b 
	   ON a.object_id = b.object_id 
	   AND a.index_id = b.index_id;
Go


-- 3 - Excluíndo algumas linhas de registro na Tabela Alunos --     
Delete from Alunos
Where Codigo Between 1750 And 2980

-- Consultando informações sobre fragmentação de Dados e Índices --
SELECT a.index_id, 
       name, 
       avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'Alunos'),NULL, NULL, NULL) AS a
      JOIN sys.indexes AS b 
	   ON a.object_id = b.object_id 
	   AND a.index_id = b.index_id;
Go

-- 4 - Atualizando dados na Tabela Alunos --     
Update Alunos
Set Nome = 'Eduardo'
Where Codigo Between 1200 And 4530

-- Consultando informações sobre fragmentação de Dados e Índices --
SELECT a.index_id, 
       name, 
       avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(N'Alunos'),NULL, NULL, NULL) AS a
      JOIN sys.indexes AS b 
	   ON a.object_id = b.object_id 
	   AND a.index_id = b.index_id;
Go
