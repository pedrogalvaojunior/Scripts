-- Acessando o Banco de Dados Northwind --
Use NORTHWIND
Go

-- Limpar o Cache do SQL Server --
DBCC Freeproccache
Go

-- Realizando o Select sem Schema --
Select * from Customers
Go

-- Consultando informações do Cache do Plan de Execução --
with qry as 
(
  Select refcounts, 
              usecounts, 
			  size_in_bytes,
              cacheobjtype,
			  objtype,
             attribute,
			 value, -- Observar o valor retornado para a coluna Value onde -1 cache será utilizado somente pelo usuário da sessão, -2 por qualquer usuário
			 plan_handle
  From sys.dm_exec_cached_plans ecp
  Outer apply sys.dm_exec_plan_attributes(ecp.plan_handle) epa
  Where epa.attribute='user_id')

Select refcounts,
            usecounts,
			size_in_bytes,
			cacheobjtype,
            objtype,
			attribute,
			value,
            objectid,
			[text],
			[dbid] 
From qry  Cross Apply sys.dm_exec_sql_text(qry.plan_handle)
Where dbid=db_id('Northwind')
Go

-- Realizando o Select com Schema --
Select * from dbo.Customers
Go

-- Consultando informações do Cache do Plan de Execução --
with qry as 
(
  Select refcounts, 
              usecounts, 
			  size_in_bytes,
              cacheobjtype,
			  objtype,
             attribute,
			 value, -- Observar o valor retornado para a coluna Value onde -1 cache será utilizado somente pelo usuário da sessão, -2 por qualquer usuário
			 plan_handle
  From sys.dm_exec_cached_plans ecp
  Outer apply sys.dm_exec_plan_attributes(ecp.plan_handle) epa
  Where epa.attribute='user_id')

Select refcounts,
            usecounts,
			size_in_bytes,
			cacheobjtype,
            objtype,
			attribute,
			value,
            objectid,
			[text],
			[dbid] 
From qry  Cross Apply sys.dm_exec_sql_text(qry.plan_handle)
Where dbid=db_id('Northwind')
Go