-- Realizando o Backup --
Backup Database SIGP_Ipeas
 To Disk = 'E:\sigp_ipeas.bak'
 With Init,
 Stats=10
Go

-- Realizando e Restore Sobreescrevendo e Movendo os Arquivos --
Restore Database SIGP_Test
From Disk = 'E:\sigp_ipeas.bak'
With Replace, Recovery,
Stats=10,
Move 'SIGP_IPEAS' TO 'E:\MSSQL2005\Data\SIGP_TEST.mdf',
Move 'SIGP_IPEAS_log' To 'E:\MSSQL2005\Log\SIGP_TEST_log.ldf'
Go

-- Acessando o Banco de Dados --
USE SIGP_TEST
Go

-- Excluíndo o Usuário --
Drop User Sigp
go


-- Criando o Usuário com base no Login --
Create User Sigp From Login SIGP
Go


-- Adicionando o Usuário a RoleMember DB_Owner --
sp_addrolemember 'db_owner','dbo'

-- Definindo o Banco de Dados padrão do Usuário --
Alter Login SIGP
 With Default_database = SIGP_IPEAS
Go

-- Mudando o Contexto para teste de Conexão e Permissões --
Exec As User = 'SIGP'
Go

-- Confirmando a Mudança de Contexto --
Select User_Name()
Go


-- Criando a Tabela para teste de Permissão --
Create Table T1
(Codigo Int)
Go

-- Excluíndo a Tabela T1 para teste de Permissão --
Drop Table T1
Go

-- Fechando a Conexão do Banco --
Use Master
Go