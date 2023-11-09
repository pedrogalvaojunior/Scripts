-- Desabilitando a contagem de linhas --
Set NoCount On;

-- Verificando se a Tabela OrdemProducao já esta cadastrada --
If OBJECT_ID('dbo.OrdemProducao','U') Is Not Null
 Drop Table dbo.OrdemProducao
Go

-- Criando a Tabela OrdemProducao --
Create Table OrdemProducao
 (NumProducao Int Not Null,
  Data Date Not Null,
  CodFuncionario Int Not Null,
  Setor Varchar(2) Not Null, 
  Quantidade Int Not Null         
 ) 
Go

-- Adicionando Chave Primária na Tabela OrdemProducao --
Alter Table OrdemProducao
 Add Constraint [PK_OrdemProducao_NumProducao] Primary Key Clustered (NumProducao)
Go 
-- Inserindo dados na Tabela OrdemProducao --
Insert Into OrdemProducao (NumProducao, Data, CodFuncionario, Setor, Quantidade)
Values 
(1000, '20091001',1,'A',20),
(1001, '20091002',2,'B',30),
(1002, '20091003',3,'D',15),
(1003, '20091005',2,'D',12),
(2000, '20100210',4,'C',40),
(2001, '20100211',4,'C',35),
(2002, '20100312',2,'A',22),
(2004, '20100414',2,'B',12),			  
(3005, '20110601',1,'C',50),
(3006, '20110602',3,'B',60)

Insert Into OrdemProducao (NumProducao, Data, CodFuncionario, Setor, Quantidade)
Values 
(10000, '20091001',1,'A',20),
(10001, '20091002',2,'B',30),
(10002, '20091003',3,'D',15),
(10003, '20091005',2,'D',12),
(20000, '20100210',4,'C',40),
(20001, '20100211',4,'C',35),
(20002, '20100312',2,'A',22),
(20004, '20100414',2,'B',12),			  
(30005, '20110601',1,'C',50),
(30006, '20110602',3,'B',60)

-- Aplicando o Grouping Sets (Setor, CodFuncionario e AnoProducao) na Tabela OrdemProducao --
Select Setor, CodFuncionario, YEAR(Data) As 'Ano de Produção', SUM(Quantidade) As Soma
from dbo.OrdemProducao
Group By GROUPING Sets
(
 (Setor, CodFuncionario, YEAR(DATA)) 
)
Go

-- Aplicando o Grouping Sets (Setor, CodFuncionario e AnoProducao + AnoProd) na Tabela OrdemProducao --
Select Setor, CodFuncionario, YEAR(Data) As 'Ano de Produção', SUM(Quantidade) As Soma
from dbo.OrdemProducao
Group By GROUPING Sets
(
 (Setor, CodFuncionario, YEAR(DATA)),
 (YEAR(Data))
)
Go

-- Simultando o Grouping Sets utilizando Union All --
Select Setor, CodFuncionario, YEAR(Data) As 'Ano de Produção', SUM(Quantidade) As Soma
from dbo.OrdemProducao
Group By Setor, CodFuncionario, YEAR(Data)

Union All

Select Null As Setor, Null As CodFuncionario, YEAR(Data) As 'Ano de Produção', SUM(Quantidade) As Soma
from dbo.OrdemProducao
Group By YEAR(Data)