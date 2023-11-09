declare @nome_db varchar(30)
declare @str_1 Nvarchar(3000) 
declare @str_2 Nvarchar(3000) 

use MASTER
select @nome_db= [name] from sysdatabases where [name] like 'tempdb%' 

SET @str_1 = 'CREATE VIEW [dbo].test as SELECT * FROM sysobjects'

set @str_2 = 'exec ' + @nome_db + '.dbo.sp_executeSQL N' + Quotename(@str_1,'''')

print @str_2
exec (@str_2);

select * from tempdb.dbo.test



Declare @Comando1 Varchar(100), 
        @Banco VarChar(30)

Select @Banco = name from master.sys.sysdatabases Where dbid=5

Set @Comando1='Use ' + @Banco

--Utilizando o Comando Exec
Exec(@Comando1 + ' Select * from sys.sysobjects')

--Utilizando o Comando Execute
Execute(@Comando1 + ' Select * from sys.sysobjects')