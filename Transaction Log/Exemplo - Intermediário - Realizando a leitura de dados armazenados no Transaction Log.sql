-- Criando o Banco de Dados BDLeituraLog --
Create Database BDLeituraLog
Go

-- Acessando o Banco de Dados BDLeituraLog --
Use BDLeituraLog
Go

-- Criando a Tabela Cidades --
Create Table Municipios
(CodigoMunicipio SmallInt Identity(1,1) Primary Key,
 NomeMunicipio Varchar(100) Not Null Default 'São Roque',
 DataFundacaoMunicipio Date Not Null Default GetDate())
Go

-- Obtendo a quantidade de linhas de dados iniciais armazenados do Transaction Log --
Select Count(*) From fn_dblog(Null, Null)
Go

-- Obtendo o detalhamento de dados iniciais armazenados no Transaction Log --
Select [Current LSN], 
           Operation, 
           [Transaction Name], 
		   [Transaction ID], 
		   [Transaction SID], 
		   SPID, 
		   [Begin Time],
		   [End Time]
from fn_dblog(null, null)
Go

-- Manipulando dados para forçar a escrita e armazenamento de dados no Transaction Log --
Insert Into Municipios Default Values
Go 100

Update Municipios
Set NomeMunicipio='Mairinque'
Where CodigoMunicipio < 5
Go

Delete Municipios
Where CodigoMunicipio > 90
Go

-- Obtendo o detalhamento de dados armazenados no Transaction Log após as transações de manipulação de dados - Abrindo o Bloco de Transações --
Select [Current LSN], 
           Operation, 
           [Transaction Name],
		   Context,
		   AllocUnitName,
		   [Page ID],
		   [Slot ID],
		   [Transaction ID], 
		   [Transaction SID], 
		   SPID, 
		   [Begin Time],
		   [End Time],
		   [Number of Locks],
		   [Lock Information]
from fn_dblog(null, null)
Where Operation In  ('LOP_BEGIN_XACT')
Go

-- Obtendo o detalhamento de dados armazenados no Transaction Log após as transações de Insert de dados --
Select [Current LSN], 
           Operation, 
           [Transaction Name],
		   Context,
		   AllocUnitName,
		   [Page ID],
		   [Slot ID],
		   [Transaction ID], 
		   [Transaction SID], 
		   SPID, 
		   [Begin Time],
		   [End Time],
		   [Number of Locks],
		   [Lock Information]
from fn_dblog(null, null)
Where Operation In  ('LOP_INSERT_ROWS')
Go

-- Obtendo o detalhamento de dados armazenados no Transaction Log após as transações de Update de dados --
Select [Current LSN], 
           Operation, 
           [Transaction Name],
		   Context,
		   AllocUnitName,
		   [Page ID],
		   [Slot ID],
		   [Transaction ID], 
		   [Transaction SID], 
		   SPID, 
		   [Begin Time],
		   [End Time],
		   [Number of Locks],
		   [Lock Information]
from fn_dblog(null, null)
Where Operation In  ('LOP_MODIFY_ROW')
Go

-- Obtendo o detalhamento de dados armazenados no Transaction Log após as transações de Delete de dados --
Select [Current LSN], 
           Operation, 
           [Transaction Name],
		   Context,
		   AllocUnitName,
		   [Page ID],
		   [Slot ID],
		   [Transaction ID], 
		   [Transaction SID], 
		   SPID, 
		   [Begin Time],
		   [End Time],
		   [Number of Locks],
		   [Lock Information]
from fn_dblog(null, null)
Where Operation In  ('LOP_DELETE_ROWS')
Go

-- Obtendo o detalhamento de dados armazenados no Transaction Log após as transações de manipulação de dados - Comitando o Bloco de Transações --
Select [Current LSN], 
           Operation, 
           [Transaction Name],
		   Context,
		   AllocUnitName,
		   [Page ID],
		   [Slot ID],
		   [Transaction ID], 
		   [Transaction SID], 
		   SPID, 
		   [Begin Time],
		   [End Time],
		   [Number of Locks],
		   [Lock Information]
from fn_dblog(null, null)
Where Operation In  ('LOP_COMMIT_XACT')
Go

-- Procurando operações internas processados pelo SQL Server armazenadas no Transaction Log --
Select [Current LSN], 
           Operation, 
           [Transaction Name],
		   Context,
		   AllocUnitName,
		   [Page ID],
		   [Slot ID],
		   [Transaction ID], 
		   [Transaction SID], 
		   SPID, 
		   [Begin Time],
		   [End Time],
		   [Number of Locks],
		   [Lock Information]
from fn_dblog(null, null)
Where [Transaction Name] = 'splitpage'
Go

-- Obtendo todos os passos executados pela Transaction Name = SplitPage armazenados no Transaction Log --
Select [Current LSN], 
           Operation, 
           [Transaction Name],
		   Context,
		   AllocUnitName,
		   [Page ID],
		   [Slot ID],
		   [Transaction ID], 
		   [Transaction SID], 
		   SPID, 
		   [Begin Time],
		   [End Time],
		   [Number of Locks],
		   [Lock Information]
from fn_dblog(null, null)
Where [Transaction ID]='0000:00000441'
Go