-- Para saber a collation do servidor
Select SERVERPROPERTY ( 'collation' )

exec sp_helpsort

-- Para saber a collation do banco

select databasepropertyex('MRP','collation')

-- Para saber a collation das colunas de uma tabela

exec sp_help 'Produtos'

select * from sys.databases

 
Para Colunas:

Select * from Sys.columns

Select * from Sys.syscolumns

select * from information_schema.columns

 
