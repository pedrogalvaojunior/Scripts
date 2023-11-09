-- Alterando o Nível de Compatibilidade do Banco de Dados --
ALTER DATABASE CRIPTOGRAFIA
 SET compatibility_level = 100

-- Obtendo Informações sobre o Banco de Dados --
sp_helpdb 'criptografia'

-- Alterando o Modelo de Recuperação do Banco de Dados --
Alter Database Criptografia
 Set Recovery Simple
 
-- Alterando o Status do Banco de Dados --
Use master
Go

Alter Database Criptografia
Set Offline

Alter Database Criptografia
Set Emergency

Select * from CRIPTOGRAFIA.dbo.TabelaCriptografada

Alter Database Criptografia
Set OnLine

-- Alterando a forma de restrição do banco de dados --
Select compatibility_level,  
            user_access_desc from sys.databases
Where name='Criptografia'

Alter Database Criptografia
Set Single_User

Alter Database Criptografia
Set Multi_User

Use master
Go

Alter Database Criptografia
Set Restricted_User

-- Obtendo informações do Banco de dados, através da função DATABASEPROPERTYEX() --
Select DATABASEPROPERTYEX('CRIPTOGRAFIA','Recovery') As 'Nível de Recuperação',
            DATABASEPROPERTYEX('CRIPTOGRAFIA','Status') As 'Status do Banco',
            DATABASEPROPERTYEX('CRIPTOGRAFIA','Updateability') As 'Usabilidade',
            DATABASEPROPERTYEX('CRIPTOGRAFIA','UserAccess') As 'Forma de Acesso',
            DATABASEPROPERTYEX('CRIPTOGRAFIA','Version') As Versão
Go