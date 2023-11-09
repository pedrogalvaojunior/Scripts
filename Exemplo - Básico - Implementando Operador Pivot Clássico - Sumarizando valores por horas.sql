-- Criando as Tabelas --
Create Table Funcionarios
(Codigo Int Primary Key,
 Nome Varchar(30))
Go

Create Table Operacao
(Codigo Int Primary Key Identity(1,1),
 Descricao Varchar(30))
Go

Create Table Producao
(CodigoProducao Int Primary Key Identity(1,1),
 CodigoFuncionario Int Not Null,
 CodigoOperacao Int Not Null,
 DataProducao Date Not Null,
 HoraProducao Time Not Null,
 Quantidade Int Not Null)
Go

-- Adicionando os relacionamentos --
Alter Table Producao
 Add Constraint [FK_Producao_Operacao] Foreign Key (CodigoOperacao)
  References Operacao (Codigo)
Go

Alter Table Producao
 Add Constraint [FK_Producao_Funcionario] Foreign Key (CodigoFuncionario)
  References Funcionarios (Codigo)
Go

-- Inserindo os dados --
Insert Into Operacao Values ('Travetar'),('Chuliar'),('Cortar'),('Enfestar')
Go

Insert Into Funcionarios Values (1020, 'Marcos'),(3025, 'José'),(2223, 'Maria'),(4025, 'Carlos'),(3262, 'João')
Go

Insert Into Producao (CodigoFuncionario, CodigoOperacao, DataProducao, HoraProducao, Quantidade)
Values (1020, 1, '2022-06-22','07:30:32',15),
            (3025, 2, '2022-06-22','07:11:10',12),
            (2223, 3, '2022-06-22','07:15:00',20),
            (1020, 1, '2022-06-22','08:23:52',32),			
            (3025, 2, '2022-06-22','08:55:01',16),
            (1020, 1, '2022-06-22','09:16:17',20),			
            (4025, 1, '2022-06-22','10:20:12',14),
			(3262, 2, '2022-06-22','07:02:30',8),
            (4025, 1, '2022-06-22','08:10:12',28),			
            (3262, 4, '2022-06-22','11:15:00',56),
			(2223, 3, '2022-06-22','09:40:23',33),
			(3025, 2, '2022-06-22','10:25:26',13)
Go

-- Consultando --
Select Distinct 
           P.DataProducao,
           P.CodigoFuncionario, F.Nome, 
		   O.Descricao,
		   IsNull((Select Sum(Quantidade) From Producao
		                Where CodigoFuncionario = F.Codigo
						And CodigoOperacao = O.Codigo
						And HoraProducao Between '07:00:00' And '07:59:59'
						Group By CodigoFuncionario, CodigoOperacao, DataProducao, HoraProducao),0) As '07:00 às 07:59',
		   IsNull((Select Sum(Quantidade) From Producao
		                Where CodigoFuncionario = F.Codigo
						And CodigoOperacao = O.Codigo
						And HoraProducao Between '08:00:00' And '08:59:59'
						Group By CodigoFuncionario, CodigoOperacao, DataProducao, HoraProducao),0) As '08:00 às 08:59',
		   IsNull((Select Sum(Quantidade) From Producao
		                Where CodigoFuncionario = F.Codigo
						And CodigoOperacao = O.Codigo
						And HoraProducao Between '09:00:00' And '09:59:59'
						Group By CodigoFuncionario, CodigoOperacao, DataProducao, HoraProducao),0) As '09:00 às 09:59',
		   IsNull((Select Sum(Quantidade) From Producao
		                Where CodigoFuncionario = F.Codigo
						And CodigoOperacao = O.Codigo
						And HoraProducao Between '10:00:00' And '10:59:59'
						Group By CodigoFuncionario, CodigoOperacao, DataProducao, HoraProducao),0) As '10:00 às 10:59',
		   IsNull((Select Sum(Quantidade) From Producao
		                Where CodigoFuncionario = F.Codigo
						And CodigoOperacao = O.Codigo
						And HoraProducao Between '11:00:00' And '11:59:59'
						Group By CodigoFuncionario, CodigoOperacao, DataProducao, HoraProducao),0) As '11:00 às 11:59'
From Producao P Inner Join Funcionarios F
  				             On P.CodigoFuncionario = F.Codigo
							Inner Join Operacao O
							 On P.CodigoOperacao = O.Codigo
Go