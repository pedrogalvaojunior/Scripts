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

Create Table TabelaLog
 (Codigo Int Identity(1,1),
   Valor Int)
Go
   
Declare @Contador Int
Set @Contador=1

While @Contador <=100000
 Begin
 
  Insert Into TabelaLog Values (@Contador)

  Set @Contador=@Contador+1  
 End 
Go  

sp_spaceused 'TabelaLog'

sp_spaceused

-- Backup Simples --
Backup Database Criptografia
 To Disk = 'C:\Backup\Backup-Simples-Criptografia.bak'
  With Init, 
  Description = 'Backup Simples - Banco Criptografia',
  Stats = 5     

-- Backup Full --
Alter Database Criptografia
Set Recovery Full
Go

Backup Database Criptografia
 To Disk = 'C:\Backup\Backup-Full-Criptografia.bak'
  With Init, 
  Description = 'Backup Full - Banco Criptografia',
  Stats = 5      

--Retorna Informações sobre as mídias de backup --
Restore LabelOnly from Disk = 'C:\Backup\Backup-Simples-Criptografia.bak'

--Retorna Informações sobre os backups --
Restore HeaderOnly from Disk = 'C:\Backup\Backup-Simples-Criptografia.bak'

/* O comando RESTORE VERIFYONLY realiza uma checagem na integridade dos backups de um 
dispositivo, verificando se o mesmo é legível, este comando não verifica a estrutura de 
dados existente dentro do backup. Se o backup for válido, o SQL Server retorna uma mensagem 
de sucesso.*/
Restore VerifyOnly from Disk = 'C:\Backup\Backup-Simples-Criptografia.bak'

-- Retorna informações sobre os arquivos de dados e log (*.mdf, *.ndf e *.ldf) armazenados em um dispositivo --
Restore FileListOnly from Disk = 'C:\Backup\Backup-Simples-Criptografia.bak'

-- Criando a Tabela Eventos --
Create Table Eventos
(CodEvento TinyInt Identity(1,2) Primary Key,
  Nome VarChar(100) Not Null,
  Local VarChar(50) Default 'Festa de Sorocaba',
  Cidade VarChar(50) Default 'Sorocaba',
  Data Date Not Null)
On [Primary]


Insert Into Eventos (Nome, Local, Cidade, Data)
 Values ('Festa Junina','Praça da Matriz','Sorocaba','02/06/2011'),
             ('Festa da Uva','Parque de Festa','Jundiaí','03/06/2011'), 
             ('Festa do Vinho','Recanto da Cascata','São Roque','08/10/2011')
            
Select * from Eventos 

-- Backup Full --
Backup Database Criptografia
 To Disk = 'C:\Backup\Backup-Full-Criptografia.bak'
  With Init, 
  Description = 'Backup Full - Banco Criptografia',
  Stats = 5      
  
-- Excluíndo a Tabela Eventos --
Drop Table Eventos  

-- Restaurando o Banco Criptografia --
Use master
Go

Restore Database Criptografia
From Disk = 'C:\Backup\Backup-Full-Criptografia.bak'
With Recovery, Replace,
Stats = 10

-- Realizando o Backup de Log --
Backup Log Criptografia
To Disk = 'C:\Backup\Backup-Log-Criptografia.bak'
With Init, 
Description = 'Backup de Log - Banco Criptografia',
ExpireDate = '04/06/2011',
RetainDays = 2,
Stats=10

Create Table Eventos2
(CodEvento TinyInt Identity(1,2) Primary Key,
  Nome VarChar(100) Not Null,
  Local VarChar(50) Default 'Festa de Sorocaba',
  Cidade VarChar(50) Default 'Sorocaba',
  Data Date Not Null)
On [Primary]

Backup Log Criptografia
To Disk = 'C:\Backup\Backup-Log2-Criptografia.bak'
With Init, 
Description = 'Backup de Log - Banco Criptografia',
ExpireDate = '04/06/2011',
RetainDays = 2,
Stats=10


Drop Table Eventos

-- Restaurando o Log de Dados - Banco Criptografia --
Use master
Go

Restore Database Criptografia
From Disk = 'C:\Backup\Backup-Full-Criptografia.bak'
With NoRecovery, Replace,
Stats = 10

Restore Log Criptografia
From Disk = 'C:\Backup\Backup-Log-Criptografia.bak'
With NoRecovery, Replace,
Stats = 10

Restore Log Criptografia
From Disk = 'C:\Backup\Backup-Log2-Criptografia.bak'
With Recovery, Replace,
Stats = 10