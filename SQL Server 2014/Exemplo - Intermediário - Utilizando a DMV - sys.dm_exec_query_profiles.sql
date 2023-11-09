-- Criando o Banco de Dados DBMonitor --
Create Database DBMonitor
Go

-- Acessando o Banco de Dados DBMonitor --
Use DBMonitor
Go

-- Criando a Tabela Países --
Create Table Paises
(Id Int Identity(1,1) Primary Key,
 Nome Varchar(80))
Go

-- Criando a Tabela Impostos --
Create Table Impostos
(ID Int Identity(1,1) Primary Key,
 IdPais Int Not Null, 
 TaxaBase Float,
 TaxaEquilibrio As (TaxaBase)*10)
Go

-- Adicionando o relacionamento --
Alter Table Impostos
 Add Constraint [FK_ImpostosxPaises] Foreign Key (IdPais)
  References Paises(Id)
Go

-- Inserindo a massa de dados de Países --
SET NOCOUNT ON
Go

Insert Into Paises Values('Brasil'),
                                        ('Jamaica'),
										('Kiribati'),
										('Papau Nova Guiné'),
										('São Tomé e Príncipe'),
										('Estônia')
Go


-- Inserindo a massa de dados de Impostos --
SET NoCount On
Go

Declare @Contador TinyInt

Set @Contador = 0

While @Contador < 255
Begin

 Insert Into Impostos (IdPais, TaxaBase) 
 Values(IIF(@contador <=50, 1,
			IIF(@Contador >=51 And @Contador <=100, 2,
            IIF(@Contador >=101 And @Contador <=150, 3,
            IIF(@Contador >=151 And @Contador <=200, 4,
            IIF(@Contador >=201 And @Contador <=220, 5, 6	))))),
			RAND()*4)

 Set @Contador = @Contador + 1
End

-- Consultando os dados --
Select P.Nome, 
           Sum(I.TaxaBase) As SomaTaxaBase,
		   Sum(I.TaxaEquilibrio) As SomaTaxaEquilibrio
From Impostos I Inner Join Paises P
						 On I.IdPais = P.Id
Group By P.Nome
Order By SomaTaxaEquilibrio Desc
Go

-- Atividando o monitoramento da nossa query --
SET STATISTICS PROFILE OFF;
Go 

-- Executando a query --
Select P.Nome, 
           Sum(I.TaxaBase) As SomaTaxaBase,
		   Sum(I.TaxaEquilibrio) As SomaTaxaEquilibrio
From Impostos I Inner Join Paises P
						 On I.IdPais = P.Id
Group By P.Nome
Order By SomaTaxaEquilibrio Desc
Go

-- Criando a Tabela BigTable --
CREATE TABLE BigTable 
(OrderID int NOT NULL IDENTITY(1, 1),
 CustomerID int NULL,
 OrderDate date NULL,
 Value numeric (18, 2) NOT NULL)
GO

-- Alterando a Tabela Adicionando Primary Key --
ALTER TABLE BigTable 
 ADD CONSTRAINT PK_BigTable PRIMARY KEY CLUSTERED  (OrderID)
GO

-- Inserindo 5 Milhões de Linhas de Registro --
Insert Into BigTable(CustomerID, OrderDate, Value)
SELECT Top 15000000
       ABS(CONVERT(Int, (CheckSUM(NEWID()) / 10000000))) As CustomerID,
       CONVERT(Date, GetDate() - ABS(CONVERT(Int, (CheckSUM(NEWID()) / 10000000)))) As OrderDate,
       ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 1000000.5))) As Value
  FROM sysobjects a, sysobjects b, sysobjects c, sysobjects d
GO

-- Abrir nova query e executar --
SET STATISTICS PROFILE ON
GO


SELECT  session_id ,
        node_id ,
        physical_operator_name ,
        SUM(row_count) row_count ,
        SUM(estimate_row_count) AS estimate_row_count ,
        IIF(COUNT(thread_id) = 0, 1, COUNT(thread_id)) [Threads] ,
        CAST(SUM(row_count) * 100. / SUM(estimate_row_count) AS DECIMAL(30, 2)) [% Complete] ,
        CONVERT(TIME, DATEADD(ms, MAX(elapsed_time_ms), 0)) [Operator time] ,
        DB_NAME(database_id) + '.' + OBJECT_SCHEMA_NAME(QP.object_id,
                                                        qp.database_id) + '.'
        + OBJECT_NAME(QP.object_id, qp.database_id) [Object Name]
FROM    sys.dm_exec_query_profiles QP
GROUP BY session_id ,
        node_id ,
        physical_operator_name ,
        qp.database_id ,
        QP.OBJECT_ID ,
        QP.index_id
ORDER BY session_id ,
        node_id
GO