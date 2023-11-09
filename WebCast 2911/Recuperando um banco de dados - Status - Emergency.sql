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

--Permitindo acesso somente para um usuário
sp_dboption 'Estoque', 'dbo use only', false
go
sp_dboption 'Estoque','single_user', true
go

--Verificando a integridade física e lógica do banco, reconstruíndo os dados perdidos
dbcc checkdb ('SeuBanco',repair_allow_data_loss)
go

--Voltando o acesso ao banco para multi usuário.
sp_dboption 'Estoque', 'dbo use only', false
go
sp_dboption 'Estoque','single_user', false
go

--Verificando o Status do banco
Select * from sys.sysdatabases
Where Name='Estoque'

