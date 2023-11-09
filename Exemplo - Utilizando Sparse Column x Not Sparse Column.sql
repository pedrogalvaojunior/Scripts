Use TempDB
Go

-- Parte 1: Criando as tabelas -- 
Create Table ColunaSparse
 (Codigo Int Primary Key Identity(1,1),
   Descricao Varchar(100) Sparse Null,
   Data Date Sparse Null,
   Valor Int Not Null)
Go

Create Table SemColunaSparse
 (Codigo Int Primary Key Identity(1,1),
   Descricao Varchar(100) Null,
   Data Date Null,
   Valor Int Not Null)
Go  

-- Parte 2: Criando os Índices nas Tabelas ColunaSparse e SemColunaSparse --
Create NonClustered Index [Ind_Descricao] On ColunaSparse (Descricao Asc)
Go

Create NonClustered Index [Ind_DescricaoSemColunaSparse] On SemColunaSparse (Descricao Asc)
Go

Truncate Table ColunaSparse 
Truncate Table SemColunaSparse

-- Parte 3: Inserindo Dados nas Tabelas ColunaSparse e SemColunaSparse --
Declare @Contador Int

Set @Contador=0

While (@Contador <=1000)
 Begin
	Insert Into ColunaSparse(Descricao,Data,Valor)
	Values ('Produto '+Convert(VarChar(5),@@IDENTITY),GETDATE(), 100)

	Insert Into ColunaSparse(Descricao,Data,Valor)
	Values ('Produto '+Convert(VarChar(5),@@IDENTITY),GETDATE(), 100+@@IDENTITY)
			 
	Insert Into ColunaSparse(Valor)
	Values	 (100+@@IDENTITY)
			 
	Insert Into ColunaSparse(Descricao,Data,Valor)
	Values ('Produto '+Convert(VarChar(5),@@IDENTITY),GETDATE(), 100+@@IDENTITY)
		
	Insert Into ColunaSparse(Descricao,Data,Valor)
	Values ('Produto '+Convert(VarChar(5),@@IDENTITY),GETDATE(), 100+@@IDENTITY)

	Insert Into ColunaSparse(Descricao,Valor)
	Values ('Produto '+Convert(VarChar(5),@@IDENTITY), 100+@@IDENTITY)

	Insert Into ColunaSparse(Data,Valor)
	Values (GETDATE(), 100+@@IDENTITY)

	Insert Into ColunaSparse(Valor)
	Values (100+@@IDENTITY)
	
	Set @Contador +=1
End

Set @Contador=0

While (@Contador <=1000)
 Begin
	Insert Into SemColunaSparse(Descricao,Data,Valor)
	Values ('Produto '+Convert(VarChar(5),@@IDENTITY),GETDATE(), 100)

	Insert Into SemColunaSparse(Descricao,Data,Valor)
	Values ('Produto '+Convert(VarChar(5),@@IDENTITY),GETDATE(), 100+@@IDENTITY)
			 
	Insert Into SemColunaSparse(Valor)
	Values	 (100+@@IDENTITY)
			 
	Insert Into SemColunaSparse(Descricao,Data,Valor)
	Values ('Produto '+Convert(VarChar(5),@@IDENTITY),GETDATE(), 100+@@IDENTITY)
		
	Insert Into SemColunaSparse(Descricao,Data,Valor)
	Values ('Produto '+Convert(VarChar(5),@@IDENTITY),GETDATE(), 100+@@IDENTITY)

	Insert Into SemColunaSparse(Descricao,Valor)
	Values ('Produto '+Convert(VarChar(5),@@IDENTITY), 100+@@IDENTITY)

	Insert Into SemColunaSparse(Data,Valor)
	Values (GETDATE(), 100+@@IDENTITY)

	Insert Into SemColunaSparse(Valor)
	Values (100+@@IDENTITY)

    Set @Contador +=1
End
Go

-- Parte 4: Consultando os Dados Inseridos nas Tabelas ColunaSparse e SemColunaSparse --
Select COUNT(CS.Codigo) AS 'Quantidade - Linhas - Coluna Sparse',
            COUNT(SCS.Codigo) AS 'Quantidade - Linhas - Sem Coluna Sparse'
from ColunaSparse CS, SemColunaSparse SCS
Go

-- Parte 5: Iniciando a análise de Alocação de Espaços, Utilizando SP_SpaceUsed --
SP_SpaceUsed 'ColunaSparse'
Go

SP_SpaceUsed 'SemColunaSparse'
Go

-- Parte 6: Atualizando a Alocação de Espaços, Utilizando DBCC UpdateUsage --
DBCC UPDATEUSAGE (TempDB,"ColunaSparse")
DBCC UPDATEUSAGE (TempDB,"SemColunaSparse")
Go

-- Parte 7: Atualizando a Alocação de Espaços, com base nos resultados DBCC ShowContig --
DBCC ShowContig ('ColunaSparse')
DBCC ShowContig ('SemColunaSparse')
Go