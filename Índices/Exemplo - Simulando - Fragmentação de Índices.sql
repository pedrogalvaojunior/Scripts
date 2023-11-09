If Exists(Select OBJECT_ID('Alunos'))
 Drop Table Alunos
Go

Create Table Alunos
 (Codigo Int,
  Nome VarChar(20),
  DataNascimento Date
  Constraint [PK_Alunos_RA] Primary Key (Codigo))
Go 

Declare @Contador Int

Set @Contador=1

While @Contador <=1000
 Begin
 
  Insert Into Alunos(Codigo, Nome, DataNascimento)
              Values(@Contador,'Pedro',DATEADD(DAY,@Contador,GETDATE()))
              
  Set @Contador=@Contador+1
 End
 
Select * from Alunos

SELECT * FROM sys.dm_db_index_physical_stats
    (DB_ID(N'EXEMPLOS'), OBJECT_ID(N'Alunos'), NULL, NULL , null);

Delete from Alunos
Where Codigo Between 750 And 980

SELECT * FROM sys.dm_db_index_physical_stats
    (DB_ID(N'EXEMPLOS'), OBJECT_ID(N'Alunos'), NULL, NULL , null);

Declare @Contador Int

Set @Contador=1001

While @Contador <=3000
 Begin
 
  Insert Into Alunos(Codigo, Nome, DataNascimento)
              Values(@Contador,'Pedro',DATEADD(DAY,@Contador,GETDATE()))
              
  Set @Contador=@Contador+1
 End
 
SELECT * FROM sys.dm_db_index_physical_stats
    (DB_ID(N'EXEMPLOS'), OBJECT_ID(N'Alunos'), NULL, NULL , null);
     
Delete from Alunos
Where Codigo Between 1750 And 2980

SELECT * FROM sys.dm_db_index_physical_stats
    (DB_ID(N'EXEMPLOS'), OBJECT_ID(N'Alunos'), NULL, NULL , null);
     
Update Alunos
Set Nome = 'Eduardo'
Where Codigo Between 1200 And 4530

SELECT * FROM sys.dm_db_index_physical_stats
    (DB_ID(N'EXEMPLOS'), OBJECT_ID(N'Alunos'), NULL, NULL , null);

DBCC ShowContig('Alunos');

DBCC INDEXDEFRAG (EXEMPLOS, "ALUNOS");

ALTER INDEX PK_Alunos_RA ON ALUNOS REORGANIZE;

