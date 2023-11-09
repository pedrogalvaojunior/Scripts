--Verificando o Status do banco
Select * from sys.sysdatabases
Where Name='Estoque'

--Mudando o estado do banco para Emergency
Alter Database Estoque
 Set Emergency

--Verificando o Status do banco
Select * from sys.sysdatabases
Where Name='Estoque'

Use Estoque
go

--Permitindo acesso somente para um usu�rio
sp_dboption 'Estoque', 'dbo use only', false
go
sp_dboption 'Estoque','single_user', true
go

--Verificando a integridade f�sica e l�gica do banco, reconstru�ndo os dados perdidos
dbcc checkdb ('SeuBanco',repair_allow_data_loss)
go

--Voltando o acesso ao banco para multi usu�rio.
sp_dboption 'Estoque', 'dbo use only', false
go
sp_dboption 'Estoque','single_user', false
go

--Verificando o Status do banco
Select * from sys.sysdatabases
Where Name='Estoque'

