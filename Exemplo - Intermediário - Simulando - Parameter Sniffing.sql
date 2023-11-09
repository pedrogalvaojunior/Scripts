-- Criando o Banco de Dados 
Create Database ParameterSniffing
Go

-- Criando a TabelaDados --
Create Table TabelaDados
(Id Int Identity Primary Key,
 Descricao Char(100),
 Localal Char(6),
 DataCriacao DateTime Default Getdate(),
 Status char(2) default 'AC')
Go

-- Criando Índice na coluna Local para TabelaDados --
Create Index IND_Local on TabelaDados(Local)
Go

-- Inserindo massa de dados --
Insert Into TabelaDados (Name,Local) VALUES ('Test1','LocalA')
GO 100000

Insert Into TabelaDados (Name,Local) VALUES ('Test1','LocalB')
GO 10

-- Selecionando dados na TabelaDados com Local = 'LocalA' --
Select * From TabelaDados
Where Local = 'LocalA'
Go

-- Selecionando dados na TabelaDados com Local = 'LocalA' --
Select * From TabelaDados
Where Local = 'LocalB'
Go

-- Criando a Stored Procedure 
Create Procedure ObterDadosPorLocal (@Local Char(6))
As
Begin

 Set NoCount ON

 Select * From TabelaDados
 Where Local = @Local
End


-- Executando a Stored Procedure ObterDadosPorLocal = LocalA --
ObterDadosPorLocal 'LocalA'
Go

-- Executando a Stored Procedure ObterDadosPorLocal = LocalB --
ObterDadosPorLocal 'LocalB'
Go

-- Obtendo informações sobre Plano de Execução de Stored Procedures --
Select OBJECT_NAME(s.object_id) SP_Name,
       eqp.query_plan
From sys.dm_exec_procedure_stats s CROSS APPLY sys.dm_exec_query_plan (s.plan_handle) eqp
Where DB_NAME(database_id) = 'ParameterSniffing'

-- Recompilando a Stored Procedure --
SP_Recompile 'ObterDadosPorLocal'
Go

-- Alterando a Stored Procedure ObterDadosPorLocal adicionando a opção Recompile --
Alter Procedure ObterDadosPorLocal (@Local as Char(6)) With Recompile
As
Begin

 Set NoCount On

 Select * From TabelaDados
 Where Local = @Local
End

-- Executando novamente a Stored Procedure ObterDadosPorLocal, descartando o Cache do Plano de Execução --
Exec ObterDadosPorLocal @Local= N'LocalA' 
Exec ObterDadosPorLocal @Local= N'LocalB' 
Go

-- Executando novamente a Stored Procedure ObterDadosPorLocal, recompilando e utilizando o do Plano de Execução, sem fazer o armazenamento --
Exec [dbo].[ObterDadosPorLocal] @Local = N'LocalA' WITH RECOMPILE
Go

-- Alterando a Stored Procedure ObterDadosPorLocal removendo a opção Recompile e adicionando a Query Hint Optimize --
Alter Procedure ObterDadosPorLocal (@Local CHAR(6))
As
Begin

 Set NoCount On

 Select * From TabelaDados
 Where Local = @Local
 OPTION (OPTIMIZE FOR (@Local = 'LocalA'))

End

-- Executando a Stored Procedure ObterDadosPorLocal = LocalA --
ObterDadosPorLocal 'LocalA'
Go

-- Executando a Stored Procedure ObterDadosPorLocal = LocalB --
ObterDadosPorLocal 'LocalB'
Go
