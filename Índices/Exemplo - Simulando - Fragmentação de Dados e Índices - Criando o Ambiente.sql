-- Criando o Banco de Dados FATEC --
Create Database FATEC
Go

-- Acessando o Banco de Dados FATEC --
Use FATEC
Go

-- Exclu�ndo a Tabela Alunos, caso ela j� exista --
If (OBJECT_ID('Alunos') Is Not Null)
 Drop Table Alunos
 
-- Criando a Tabela Alunos --
Create Table Alunos
 (Codigo Int,
  Nome VarChar(20),
  DataNascimento Date
  Constraint [PK_Alunos_RA] Primary Key (Codigo))
Go 


-- Inserindo a Massa de Dados na Tabela Alunos --
Declare @Contador Int

Set @Contador=1

While @Contador <=10000
 Begin
 
  Insert Into Alunos(Codigo, Nome, DataNascimento)
              Values(@Contador,'Pedro',DATEADD(DAY,@Contador,GETDATE()))
              
  Set @Contador=@Contador+1
 End
 

-- Consultando o dados inseridos --
Select Codigo, Nome, DataNascimento from Alunos
