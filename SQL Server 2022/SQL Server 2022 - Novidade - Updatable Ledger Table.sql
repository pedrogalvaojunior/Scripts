-- Criando a Schema Fiscal --
Create Schema Fiscal
Go

-- Exemplo 1 --
-- Criando a Tabela Balanco atrelada ao schema Fiscal --
Create Table Fiscal.Balanco
(CustomerID Int Not Null PRIMARY KEY CLUSTERED,
 LAstName VarChar(50) Not Null,
 FirstName VarChar(50) Not Null,
 Balance Decimal(10,2) Not Null
)
With (System_Versioning = On (History_Table = Fiscal.BalancoHistorico), Ledger = On)
Go

-- Identificando através da visões de sistema a Updatable Ledger Table + Tabela Histórico + View Ledger --
Select ts.name + '.' + t.name As ledger_table_name, hs.name + '.' + h.name As history_table_name,
       vs.name + '.' + v.name As ledger_view_name
From sys.tables As t Inner Join sys.tables As h 
                      On (h.object_id = t.history_table_id)
                     Inner Join sys.views v 
					  On (v.object_id = t.ledger_view_id)
                     Inner Join sys.schemAs ts 
					  On (ts.schema_id = t.schema_id)
                     Inner Join sys.schemAs hs 
					  On (hs.schema_id = h.schema_id)
                     Inner Join sys.schemAs vs 
					  On (vs.schema_id = v.schema_id)
Where t.name = 'Balanco'
Go

-- Realizando o Insert na tabela Balanco --
Insert Into Fiscal.Balanco Values (1, 'Pedro', 'Galvão', 50),
                                  (2, 'Fernanda', 'Galvão', 500),
                                  (3, 'Eduardo', 'Galvão', 30),
                                  (4, 'João', 'Galvão', 200)
Go

Insert Into Fiscal.Balanco Values (5, 'Maria', 'Galvão', 50),
                                  (6, 'Millie', 'Galvão', 500),
                                  (7, 'Tatou', 'Galvão', 30),
                                  (8, 'Briana', 'Galvão', 200)
Go

-- Obtendo os metadados gerados pelo Ledger com base nas manipulações de dados --
Select CustomerID, LastName, FirstName, Balance, 
       ledger_start_transaction_id,
       ledger_end_transaction_id,
       ledger_start_sequence_number,
       ledger_end_sequence_number
From Fiscal.Balanco
Go

-- Atualizando os Dados na Tabela Fiscal.Balanco --
Update Fiscal.Balanco
Set Balance = 520
Where CustomerID = 8
Go

-- Utilizando a Ledger View (Fiscal.Balanco_Ledger) para identificar o histórico de alterações --
Select t.commit_time As CommitTime, t.principal_name As UserName,
       FB.CustomerID,
       FB.LastName,
       FB.FirstName,
       FB.Balance,
       FB.ledger_operation_type_desc As Operation
From Fiscal.Balanco_Ledger FB Inner Join sys.database_ledger_transactions t
                       On t.transaction_id = FB.ledger_transaction_id
Order By t.commit_time Desc
Go

-- Exemplo 2 --
-- Criando a Tabela Departamento atrelada ao schema Fiscal, utilizando Generated para manter o Histórico de Tempo --
Create Table Fiscal.Departamento
(DepartmentNumber Char(10) Not Null PRIMARY KEY CLUSTERED,
 DepartmentName VarChar(50) Not Null,
 ManagerID Int Null,
 ParentDepartmentNumber Char(10) Null,
 ValidFrom DateTime2 Generated Always As Row Start Not Null,
 ValidTo DateTime2 Generated Always As Row End Not Null,
 Period For System_Time (ValidFrom, ValidTo)
)
With (System_Versioning = On (History_Table = Fiscal.DepartamentoHistorico), Ledger = On)
Go

-- Identificando através da visões de sistema a Updatable Ledger Table + Tabela Histórico + View Ledger --
Select ts.name + '.' + t.name As ledger_table_name, hs.name + '.' + h.name As history_table_name,
       vs.name + '.' + v.name As ledger_view_name
From sys.tables As t Inner Join sys.tables As h 
                      On (h.object_id = t.history_table_id)
                     Inner Join sys.views v 
					  On (v.object_id = t.ledger_view_id)
                     Inner Join sys.schemAs ts 
					  On (ts.schema_id = t.schema_id)
                     Inner Join sys.schemAs hs 
					  On (hs.schema_id = h.schema_id)
                     Inner Join sys.schemAs vs 
					  On (vs.schema_id = v.schema_id)
Where t.name = 'Departamento'
Go

-- Realizando o Insert na tabela Departamento --
Insert Into Fiscal.Departamento (DepartmentNumber, DepartmentName, ManagerID, ParentDepartmentNumber)
Values ('001', 'TI', 1, 'Tecno'),
       ('002', 'Compras', 2, 'Dinheiro'),
       ('003', 'Estoque', 1, 'Produto'),
       ('004', 'Vendas', 3, 'Marketing')
Go

-- Obtendo os metadados gerados pelo Ledger com base nas manipulações de dados --
Select DepartmentNumber, DepartmentName, ManagerID, ParentDepartmentNumber,
       ledger_start_transaction_id,
       ledger_end_transaction_id,
       ledger_start_sequence_number,
       ledger_end_sequence_number,
	   ValidFrom,
	   ValidTo
From Fiscal.Departamento
Go

-- Atualizando os Dados na Tabela Fiscal.Departamento --
Update Fiscal.Departamento
Set DepartmentName = 'Tecnologia da Informação'
Where DepartmentNumber = 1
Go

-- Excluíndo os Dados da Tabela Fiscal.Departamento --
Delete From Fiscal.Departamento
Where DepartmentNumber=4
Go

-- Utilizando a Ledger View (Fiscal.Balanco_Ledger) para identificar o histórico de alterações --
Select t.commit_time As CommitTime, t.principal_name As UserName,
       FD.DepartmentNumber, 
	   FD.DepartmentName, 
	   FD.ManagerID, 
	   FD.ParentDepartmentNumber,
       FD.ledger_operation_type_desc As Operation,
	   FD.ValidFrom,
	   FD.ValidTo
From Fiscal.Departamento_Ledger FD Inner Join sys.database_ledger_transactions t
                       On t.transaction_id = FD.ledger_transaction_id
Order By t.commit_time Desc
Go