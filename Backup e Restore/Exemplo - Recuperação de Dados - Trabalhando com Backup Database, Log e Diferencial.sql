-- Criando a Tabela de Clientes --
Create Table Clientes 
(Codigo Int Primary Key Identity(1,1),
 Nome Varchar(40) Not Null,
 Email Varchar(200) Null)
Go

-- Inserindo dados na Tabela Clientes -- 
INSERT Clientes VALUES ('Jose','jose@fatec.edu.br'),
                                        ('Maria','maria@fatec.edu.br'),
                                        ('Pedro','pedro@fatec.edu.br'),
                                        ('Fer','fer@fatec.edu.br')
Go

Select * from Clientes


-- Realizando Backup Database --
BACKUP DATABASE FATEC
 TO DISK = 'C:\Users\Junior Galvão\Desktop\Fatec\Backup-Database-FATEC.bak'
 With Init,
          Description =	'Backup Database Full - Fatec',
          Stats=10
 Go

-- Realizando Backup Transaction Log - Tentativa 1 --
BACKUP Log FATEC
 TO DISK = 'C:\Users\Junior Galvão\Desktop\Fatec\Backup-Log-FATEC.bak'
 With Init,
          Description =	'Backup Log - Fatec',
          Stats=10
 Go 

-- Alterando o Recovery Model para Full --
Alter Database FATEC
 Set Recovery Full 
Go 

-- Realizando Backup Transaction Log - Tentativa 2 --
BACKUP Log FATEC
 TO DISK = 'C:\Users\Junior Galvão\Desktop\Fatec\Backup-Log-FATEC.bak'
 With Init,
          Description =	'Backup Log - Fatec',
          Stats=10
 Go 

-- Realizando Backup Database Diferencial --
BACKUP Database FATEC
 TO DISK = 'C:\Users\Junior Galvão\Desktop\Fatec\Backup-Diferencial-FATEC.bak'
 With Init,
          Differential,  
          Description =	'Backup Log - Fatec',
          Stats=10
 Go