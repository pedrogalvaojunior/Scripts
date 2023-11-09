-- Criando o Banco de Dados --
Create Database SQLServer2019Database
On Primary
(Name='SQLServer2019Database_Data',
 FileName='S:\MSSQL-2019\Data\SQLServer2019Database_Data.mdf')
Log On
(Name='SQLServer2019Database_Log',
 FileName='S:\MSSQL-2019\Log\SQLServer2019Database_Log.Ldf')
Go


-- Acessando --
Use SQLServer2019Database
Go

-- Consultando os arquivos --
Select file_id, type_desc, name, physical_name, state_desc From sys.database_files
Go

-- Iniciando o processo de renomeação dos arquivos --
Use Master
Go

-- Alterando a forma de acesso  --
Alter Database SQLServer2019Database
Set Single_User With Rollback Immediate
Go

-- Alterando o estado do banco de dados para OffLine --
Alter Database SQLServer2019Database
Set Offline
Go

-- Validando o estado do banco de dados --
Select name, database_id, state, state_desc From sys.databases
Go

-- Alterando o mapeando interno entre o rótulo do arquivo e seu caminho físico --
Alter Database SQLServer2019Database
 Modify File (Name='SQLServer2019Database_log', 
                    FileName='S:\MSSQL-2019\Log\SQLServer2019-Database-Log.LDF')
Go

-- Retornando o acesso ao banco --
Alter Database SQLServer2019Database
Set Multi_User With Rollback Immediate
Go

-- Alternando o estado do banco de dados para OnLine --
Alter Database SQLServer2019Database
Set OnLine
Go