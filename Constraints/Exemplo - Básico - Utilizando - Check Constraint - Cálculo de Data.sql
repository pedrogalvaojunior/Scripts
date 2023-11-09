Create Table Alunos
 (Codigo Int)
Go

-- Adicionando a coluna e constraint --
Alter Table Alunos
 Add DataNascimento DateTime
  Constraint CK_Alunos_DataNascimento Check (DateDiff(Year,DataNascimento, GetDate()) >=18)
Go

-- Adicionando somente a constraint --
Alter Table Alunos
 Add Constraint CK_Alunos_DataNascimento
  Check (DateDiff(Year,DataNascimento, GetDate()) >=18)
 Go

 -- Default - Estado --
 Alter Table Alunos
  Add Constraint [DF_Estado] Default 'SP' for Estado
  Go