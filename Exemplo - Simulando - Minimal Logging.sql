-- Criando o Banco de Dados --
Create Database MinimalLogging
Go

-- Acessando o Banco de Dados --
Use MinimalLogging
Go

-- Alterando o Modelo de Recuperação do Banco de Dados --
Alter Database MinimalLogging
Set Recovery Bulk_Logged;
Go

-- Verificando a existência das Tabelas --
If Object_ID('TableWithPrimaryKey') IS NOT NULL 
 Drop Table TableWithPrimaryKey;

If Object_ID('TableWithHeap') IS NOT NULL 
 Drop Table TableWithHeap;

If Object_ID('TableAuxWithHeap') IS NOT NULL 
 Drop Table TableAuxWithHeap;
Go

-- Criando as Tabelas --
Create Table TableWithHeap( Coluna1 INT, Coluna2 Char(6000), Coluna3 Char(2000) ) ;

Create Table TableAuxWithHeap (Coluna1 INT, Coluna2 Char(6000), Coluna3 Char(2000) ) ; 

Create Table TableWithPrimaryKey (Coluna1 INT Primary Key, Coluna2 Char(6000), Coluna3 Char(2000) ); 
Go

-- Inserindo a Massa de Dados --
Declare @Contador Int

Set @Contador =1 

While @Contador <=15000
Begin
 Insert Into TableAuxWithHeap(Coluna1) Values (@Contador)

 Set @Contador +=  1
End
Go

With GerarNumeracao (Numero)
AS 
(
 Select 1 Numero
 Union All 
 Select Numero + 1 From GerarNumeracao
 Where Numero +1 <= 15000
)

Insert Into TableAuxWithHeap(Coluna1) 
 Select Numero From GerarNumeracao 
 OPTION (MAXRECURSION 15000)

--Insert rows to Target Table With (TABLOCK) Minimally logged
Insert Into TableWithHeap With(TABLOCK)
 Select * From TableAuxWithHeap 

-- Check Log Entries
Select Top 10 operation As 'Operation',
             Context  As 'Contexto',
			[log record fixed length] As 'Tamanho Fixo do Registro',
			[log record length] As 'Tamanho do Registro de Log',
			AllocUnitId As 'Unidade de Alocação',
			AllocUnitName As 'Nome da Unidade de Alocação'
 From fn_dblog(null, null)
 Where allocunitname='dbo.TableWithHeap'
 Order By [Log Record Length] DESC;

--Note That Log Record length is small 

--Insert rows to Target Table Without (TABLOCK) fully logged
Insert Into TableWithHeap 
 Select * From TableAuxWithHeap With(NOLOCK);

-- Check Log Entries
Select Top 10 operation As 'Operation',
             Context  As 'Contexto',
			[log record fixed length] As 'Tamanho Fixo do Registro',
			[log record length] As 'Tamanho do Registro de Log',
			AllocUnitId As 'Unidade de Alocação',
			AllocUnitName As 'Nome da Unidade de Alocação'
 From fn_dblog(null, null)
 Where allocunitname='dbo.TableWithHeap'
 Order By [Log Record Length] DESC;

--Note That Log Record length is big 

--Insert rows to Target Table With clustered index and trace flag off - fully logged
Insert Into TableWithPrimaryKey 
 Select * From TableAuxWithHeap With(NOLOCK);

Select Top 10 operation As 'Operation',
             Context  As 'Contexto',
			[log record fixed length] As 'Tamanho Fixo do Registro',
			[log record length] As 'Tamanho do Registro de Log',
			AllocUnitId As 'Unidade de Alocação',
			AllocUnitName As 'Nome da Unidade de Alocação'
 From fn_dblog(null, null)
 Where allocunitname LIKE '%TableWithPrimaryKey%'
 Order By [Log Record Length] DESC;

--Note That Log Record length is big 

CHECKPOINT;
GO

DBCC TRACEON(610);
Truncate Table TableWithPrimaryKey;
GO

--Insert rows to Target Table With clustered index empty Table and trace flag ON - Minimally logged
Insert Into TableWithPrimaryKey With(TABLOCK)
 Select * From TableAuxWithHeap With(NOLOCK); 

Select Top 10 operation [MINIMALLY LOGGED OPERATION - EMPTY Table With CLUST INDEX 610 FLAG ON],
                                                  context, 
                                                  [log record fixed length], 
                                                  [log record length], 
                                                  AllocUnitId, 
                                                  AllocUnitName
 From fn_dblog(null, null)
 Where allocunitname LIKE '%TableWithPrimaryKey%'
 Order By [Log Record Length] DESC;

--Note That Log Record length is small
GO

-- Turn off trace flag
DBCC TRACEOFF(610);

-- Set recovery model back to full
ALTER Database MinimalLogging
 SET RECOVERY FULL; 