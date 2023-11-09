--Criando o Banco de Dados Exemplos--
Create Database Exemplos
Go

--Acessando o Banco de Dados Exemplos--
Use Exemplos
Go

--Criando a Table Tabela1--
Create Table Tabela1
 (Codigo SmallInt Identity Primary Key Clustered,
  Valor Int,
  DataCriacao Date,
  DataManipulacao Date) On [Primary]
  
--Inserindo Dados na Tabela1 e Retornando os valores para claúsula Output--
Insert Into Tabela1(Valor, DataCriacao, DataManipulacao) 
Output inserted.Codigo, inserted.Valor, inserted.DataCriacao, inserted.DataManipulacao
 Values(10, GETDATE(), GETDATE()+1),
       (20, GETDATE(), GETDATE()+2),
       (30, GETDATE(), GETDATE()+3),
       (40, GETDATE(), GETDATE()+4)
 
--Atualizando dados na Tabela1 e Retornando os valores para claúsula Output--
Update Tabela1
Set DataManipulacao=GETDATE()+ 1
Output Inserted.DataManipulacao As 'Data de Manipulação Atualizada',
       Deleted.DataManipulacao As 'Data de Manipulação Antiga'
Where Codigo=1
Go

--Excluíndo dados na Tabela1 e Retornando os valores para claúsula Output--
Delete From Tabela1
Output deleted.*
Where Codigo In (2,4)
Go

--Criando a Tabela Temporária #TempOutput--
Create Table #TempOutput
 (Codigo SmallInt Primary Key Clustered,
  Valor Int,
  DataCriacao Date,
  DataManipulacao Date) On [Primary]
Go

--Inserindo novos dados na Tabela1 e Armazenando o Retorno na Table Temporária--
Insert Into Tabela1(Valor, DataCriacao, DataManipulacao) 
Output Inserted.Codigo, Inserted.Valor, Inserted.DataCriacao, Inserted.DataManipulacao
Into #TempOutput(Codigo,Valor, DataCriacao, DataManipulacao)
 Values(50, GETDATE(), GETDATE()+1),
       (60, GETDATE(), GETDATE()+2),
       (70, GETDATE(), GETDATE()+3),
       (80, GETDATE(), GETDATE()+4)
Go

--Consultando os dados de Retorno armazenadas na Table Temporária--
Select * from #TempOutput
Go

--Criando a Visão para retorno dos dados armazenados na Table Temporária--
Create View V_ConsultarDados
As
 Select * From Tabela1
Go

--Realizando o Update sobre a Visão com Output Into para Table Temporária--
Update V_ConsultarDados
Set Valor=100
 Output Inserted.Codigo+10, Inserted.Valor, Inserted.DataCriacao, Inserted.DataManipulacao
 Into #TempOutPut(Codigo, Valor, DataCriacao, DataManipulacao)
Where Codigo In (6,8) 
Go

--Consultando os dados--
Select * from Tabela1
Select * from V_ConsultarDados
Select * from #TempOutput
Go

--Declarando variável do Tipo Table
Declare @VariavelOutput Table
 (Codigo SmallInt,
  Valor Int,
  DataCriacao Date,
  DataManipulacao Date)

--Inserindo novos dados na Tabela1 e Armazenando o Retorno na variável Table--
Insert Into Tabela1(Valor, DataCriacao, DataManipulacao) 
Output Inserted.Codigo, Inserted.Valor, Inserted.DataCriacao, Inserted.DataManipulacao
Into @VariavelOutput(Codigo,Valor, DataCriacao, DataManipulacao)
 Values(110, GETDATE()+5, GETDATE()+10),
       (120, GETDATE()+6, GETDATE()+20),
       (130, GETDATE()+8, GETDATE()+30),
       (140, GETDATE()+9, GETDATE()+40)

--Consultando os dados--
Select * from @VariavelOutput
Go