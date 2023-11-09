-- Criando o Banco de Dados --
Create Database BancoDeDadosNiveldeIsolamento
Go

-- Acessando --
Use BancoDeDadosNiveldeIsolamento
Go

-- Exemplo de Isolamento e Consistência de Dados --
CREATE TABLE dbo.MyTestTable (
 ColA SMALLINT Unique)

INSERT INTO dbo.MyTestTable VALUES ('Hello')
INSERT INTO dbo.MyTestTable VALUES (3),(3),(3)

-- Definindo o nível de Isolamento para READ_COMMITTED_SNAPSHOT --
SET NOCOUNT OFF
Go

ALTER DATABASE IsolationLevelTest 
SET READ_COMMITTED_SNAPSHOT ON
Go

-- Criando a Tabela para testes --
Create Table Empregados
(CodigoEmpregado Int Identity(1,1),
 NomeEmpregado Varchar(100),
 SalarioEmpregado Money,
 CONSTRAINT PK_CodigoEmpregado PRIMARY KEY(CodigoEmpregado) )
Go

-- Inserindo os dados  --
Insert Into Empregados (NomeEmpregado, SalarioEmpregado)
Values  ('Pedro Galvão', 2100),
              ('Fernanda Galvão', 2200),
              ('Eduardo Galvão', 4000),
              ('João Pedro Galvão', 1950),
			  ('Maria Luíza Galvão', 6500)
Go

Select * From Empregados
Go

-- Identificando o nível de isolamento atual --
Select Case transaction_isolation_level 
              When 0 Then 'Unspecified' 
              When 1 Then 'Read Uncommitted' 
              When 2 Then 'Read Committed' 
              When 3 Then 'Repeatable'  
              When 4 Then 'Serializable' 
              When 5 Then 'Snapshot' 
          End As 'Nível de Isolamento'
FROM sys.dm_exec_sessions 
Where session_id = @@SPID
Go

-- Exemplo 1 - Read Uncommited --
Begin Transaction

Update Empregados 
Set SalarioEmpregado = 5000
Where   CodigoEmpregado = 5
Go

-- Abrir outra query --
Set Transaction Isolation Level Read Uncommitted
Set NoCount On
Go

Select CodigoEmpregado, NomeEmpregado, SalarioEmpregado
From Empregados
Where CodigoEmpregado = 5
Go

-- Consultar os bloqueios e típos de bloqueios --
SELECT es.login_name, 
             es.session_id,
             tl.resource_type, 
             tl.resource_associated_entity_id,
             tl.request_mode, 
             tl.request_status
FROM  sys.dm_tran_locks tl INNER JOIN  sys.dm_exec_sessions es 
                                               On tl.request_session_id = es.session_id 
WHERE es.login_name = SUSER_SNAME() 
AND tl.resource_associated_entity_id <> 0
Go

Rollback
Go

-- Exemplo 2 -- READ_COMMITTED_SNAPSHOT --
ALTER DATABASE IsolationLevelTest 
SET READ_COMMITTED_SNAPSHOT ON
Go

BEGIN TRAN
UPDATE  Empregados 
SET     SalarioEmpregado = 25000
WHERE   CodigoEmpregado = 2900
Go

-- Abrir nova query -- With (ReadCommittedLock)
SELECT  CodigoEmpregado, NomeEmpregado, SalarioEmpregado
FROM    Empregados WITH (READCOMMITTEDLOCK)
WHERE   CodigoEmpregado = 2900

-- Vai esperar --
Rollback
Go

-- Exemplo 3 - Read_Committed_Snapshot - Destacar About Row Versioning
ALTER DATABASE IsolationLevelTest
SET READ_COMMITTED_SNAPSHOT ON
GO

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT ON
GO

BEGIN TRAN
UPDATE  Empregados 
SET     SalarioEmpregado = 25000
WHERE   CodigoEmpregado = 2900

-- Abrir nova query  -- Sem ReadCommittedLock os dados vão aparecer
SELECT  CodigoEmpregado, NomeEmpregado, SalarioEmpregado
FROM    Empregados 
WHERE   CodigoEmpregado = 2900
Go

--Comportamento normal e correto, vai apresentar a última consistência de dados --

