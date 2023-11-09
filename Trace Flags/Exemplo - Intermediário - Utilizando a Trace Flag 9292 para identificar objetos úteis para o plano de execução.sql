-- Criando o Banco de Dados DBTrace9292 --
Create Database DBTrace9292
Go

-- Acessando --
Use DBTrace9292
Go

-- Criando a Tabela TBTrace9292 --
Create Table TBTrace9292
(Codigo Int Identity(1,1) Primary Key,
 Valores Int,
 Descricao Varchar(100))
Go

-- Criando o Índice NonClustered IND_TBTrace9292Valores --
Create NonClustered Index IND_TBTrace9292Valores on TBTrace9292(Valores)
Go

-- Inserindo uma linha de registro na Tabela TBTrace9292 -- 
Insert Into TBTrace9292 
Values(2000,'pedrogalvaojunior.wordpress.com')
Go

-- Inserindo 1.000 linhas de registros na Tabela TBTrace9292 -- 
Insert Into TBTrace9292 
Values(4000,'pedrogalvaojunior.wordpress.com')
Go 1000

-- Criando a Stored Procedure P_PesquisarValores --
Create Procedure P_PesquisarValores @Valor int
As
Begin
 Select Descricao from TBTrace9292 
 Where Valores = @Valor
 OPTION (RECOMPILE)
End
Go

-- Habilitando as TraceFlags 9292 e 3604 --
DBCC TraceOn(9292,3604,-1)
Go

-- Execuntando a Stored Procedure P_PesquisarValores --
Execute P_PesquisarValores 4000
Go

-- Retorno --
DBCC execution completed. If DBCC printed error messages, contact your system administrator.
Stats header loaded: Dbname: DBTrace9292, ObjName: TBTrace9292, IndexId: 2, ColumnName: Valores, EmptyTable: FALSE