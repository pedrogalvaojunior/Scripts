USE TempDB;

-- Criando a Tabela Funcionário --
CREATE TABLE Funcionario 
 (ID int primary key, 
  NomeFunc varchar(200), 
  DataNasc date, 
  DataADM date);
Go

-- Consulta 1 - Fazendo uso do Operador Clustered Index Scan --
SELECT * from Funcionario
Where DataADM between Convert(date, '1/1/2012', 103) and Convert(date, '31/1/2012', 103)
Go

-- Criando um novo índice chamado Ind_NC_Funcionario_DataADM --
CREATE Nonclustered Index Ind_NC_Funcionario_DataADM On Funcionario (DataADM);
Go

-- Consulta 2 - Fazendo uso do Operador Clustered Index Scan --
SELECT * from Funcionario
Where DataADM between Convert(date, '1/1/2012', 103) and Convert(date, '31/1/2012', 103)
Go

-- Consulta 3 - Forçando o uso do índice IND_NC_Funcionario_DataADM, gerando Index Seek, Key Lookup e Nested Loops --
SELECT * from Funcionario with (index=Ind_NC_Funcionario_DataADM)
Where DataADM between Convert(date, '1/1/2012', 103) and Convert(date, '31/1/2012', 103)
Go

-- Consulta 4 - Utilizando realmente o índice IND_NC_Funcionario_DataADM --
SELECT ID, DataADM
From Funcionario 
Where DataADM between Convert(date, '1/1/2012', 103) and Convert(date, '31/1/2012', 103)
Go
