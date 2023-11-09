Create Database TableHints
Go

Use TableHints
Go

-- Criando as Tabelas - PagLockTable --
Create Table PagLockTable 
(Codigo Int Identity(1,1) Not Null Primary Key Clustered,
  Valores Varchar(20))
Go

-- Inserindo uma pequena porção de dados --
Insert Into  PagLockTable
Values ('Pedro'), ('Antonio'), ('Galvão'), ('Junior'), 
            ('MVP'), ('MCC'), ('MSTC'), ('MIE'), ('SQL Server'),
			('Banco de Dados'),('Table Hint PagLock')
Go

-- Consultando os dados --
Select Codigo, Valores From PagLockTable
Order By Valores Desc

-- Utilizando PagLock --
Begin Transaction TPL

Update PagLockTable With (PagLock)
Set Valores = 'Novos Valores ' + Valores

-- Forçando um Delay de 10 segundos para gerar bloqueio no nível de páginas -- 
WaitFor Delay  '00:00:10'

Commit Transaction TPL

-- Abrir nova query e executar o Select abaixo, após 10 segundos os dados serão apresentados --
Select * From PagLockTable
Go

-- Identificando o bloqueios realizados no nível de página --
SELECT OBJECT_SCHEMA_NAME(ios.object_id) + '.' + OBJECT_NAME(ios.object_id) as table_name,
             i.name as index_name,
			 page_lock_count,
			 page_lock_wait_count,
			 CAST(100. * page_lock_wait_count / NULLIF(page_lock_count,0) AS decimal(6,2)) AS page_block_pct,
			 page_lock_wait_in_ms, 
			 CAST(1. * page_lock_wait_in_ms / NULLIF(page_lock_wait_count,0) AS decimal(12,2)) AS page_avg_lock_wait_ms
FROM sys.dm_db_index_operational_stats (DB_ID(), NULL, NULL, NULL) ios  INNER JOIN sys.indexes i 
                                                                              ON i.object_id = ios.object_id AND i.index_id = ios.index_id
WHERE OBJECTPROPERTY(ios.object_id,'IsUserTable') = 1
ORDER BY row_lock_wait_count + page_lock_wait_count DESC, row_lock_count + page_lock_count DESC
Go

-- Identificando o bloqueios realizados no nível de linha --
SELECT OBJECT_SCHEMA_NAME(ios.object_id) + '.' + OBJECT_NAME(ios.object_id) as table_name,
             i.name as index_name,
			 row_lock_count,
			 row_lock_wait_count,
			 CAST(1. * row_lock_wait_in_ms / NULLIF(row_lock_wait_count,0) AS decimal(12,2)) AS row_avg_lock_wait_ms
FROM sys.dm_db_index_operational_stats (DB_ID(), NULL, NULL, NULL) ios  INNER JOIN sys.indexes i 
                                                                              ON i.object_id = ios.object_id AND i.index_id = ios.index_id
WHERE OBJECTPROPERTY(ios.object_id,'IsUserTable') = 1
ORDER BY row_lock_wait_count + row_lock_wait_count DESC, row_lock_count + row_lock_count DESC
Go

-- Gerando o bloqueio no nível de linha --
Begin Transaction TPLII

Update PagLockTable 
Set Valores = CONCAT(Codigo,' - ',Valores)
Where Codigo = 1

-- Forçando um Delay de 10 segundos para gerar bloqueio no nível de páginas -- 
WaitFor Delay  '00:00:10'

Commit Transaction TPLII

-- Abrir nova query e executar o Select abaixo, após 10 segundos os dados serão apresentados --
Select * From PagLockTable
Where Codigo = 1
Go