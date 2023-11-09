-- Criando o Banco de Dados --
Create Database Comparacao
Go

-- Acessando --
Use Comparacao
Go

-- Criando a TabelaDadosPersistentes --
Create Table TabelaDadosPersistentes
 (Codigo Int Primary Key Identity(1,1) Not Null,
  Descricao Varchar(30) Null,
  Valor SmallInt Not Null,
  Valor2 As (Valor/2) persisted,
  Valor3 As (Valor/3) persisted,
  Valor4 As (Valor/4) persisted,
  Valor5 As (Valor/5) persisted)
Go

-- Criando a TabelaDadosNaoPersistentes --
Create Table TabelaDadosNaoPersistentes
 (Codigo Int Primary Key Identity(1,1) Not Null,
  Descricao Varchar(30) Null,
  Valor SmallInt Not Null,
  Valor2 As (Valor/2),
  Valor3 As (Valor/3),
  Valor4 As (Valor/4),
  Valor5 As (Valor/5))
Go

-- Inserindos valores fixos - TabelaDadosPersisentes --
Insert Into TabelaDadosPersistentes (Descricao, Valor)
Values ('Arroz', 10), ('Feij�o', 20), ('Ovo', 30), ('Tomate', 40), ('Carne', 50), ('Bolacha', 60), ('Leite', 70), ('Suco', 80)
Go

-- Inserindos valores fixos - TabelaDadosNaoPersisentes --
Insert Into TabelaDadosNaoPersistentes (Descricao, Valor)
Values ('Arroz', 10), ('Feij�o', 20), ('Ovo', 30), ('Tomate', 40), ('Carne', 50), ('Bolacha', 60), ('Leite', 70), ('Suco', 80)
Go

-- Consultando a estrutura f�sica e l�gica - TabelaDadosPersistentes --
SP_Help 'TabelaDadosPersistentes'
Go

-- Consultando a estrutura f�sica e l�gica - TabelaDadosNaoPersistentes --
SP_Help 'TabelaDadosNaoPersistentes'
Go

-- Consultando o espa�o ocupado em disco - TabelaDadosPersistentes --
SP_SpaceUsed 'TabelaDadosPersistentes'
Go

-- Consultando o espa�o ocupado em disco - TabelaDadosNaoPersistentes --
SP_SpaceUsed 'TabelaDadosNaoPersistentes'
Go

-- Inserindo os mesmos valores aleat�rios - TabelaDadosPersistentes e TabelaDadosNaoPersistentes --
Declare @Contador SmallInt, @NumeroSorteado Int, @DescricaoSorteada Varchar(30), @ValorSorteado Int 

Set @Contador = 1
Set @NumeroSorteado = Rand()*10000 -- Sorteando a quantidade aleat�ria de registros at� o n�mero 10000 --

While @Contador <= @NumeroSorteado
Begin
 
 Set @DescricaoSorteada = (Concat(Char(Rand()*96), Char(Rand()*96), Char(Rand()*96), Char(Rand()*96), Char(Rand()*96))) -- Concatenado caracteres para formar a descricao aleat�ria --
 Set @ValorSorteado = Rand()*100 -- Sorteando o n�mero para a coluna valor --

 -- Inserindo os valores aleat�rios --
 Insert Into TabelaDadosPersistentes (Descricao, Valor)
 Values (@DescricaoSorteada, @ValorSorteado)

 Insert Into TabelaDadosNaoPersistentes (Descricao, Valor)
 Values (@DescricaoSorteada, @ValorSorteado)

 Set @Contador = @Contador + 1 -- Incrementando o contador --

End
Go

-- Consultando --
Select * From TabelaDadosPersistentes
Go

Select * From TabelaDadosNaoPersistentes
Go

-- Comparando as diferen�as de espa�o ocupado e armazenamento --
Select s.Name As 'Schema',
           t.Name As 'Nome da Tabela',
           p.rows As 'Quantidade de Registros',
           Cast(Round((Sum(a.used_pages) / 128.00), 2) As Numeric(36, 2)) AS 'Espa�o Ocupado Mbs',
           Cast(Round((Sum(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) As Numeric(36, 2)) AS 'Espa�o N�o Ocupado Mbs',
           Cast(Round((Sum(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) As 'Total de �rea de Armazenamento reservada'
From sys.tables t Inner Join sys.indexes i 
                             On t.object_id = i.object_id
		   				    Inner Join sys.partitions p 
							 On i.object_id = p.object_id 
							 And i.index_id = p.index_id
							Inner Join sys.allocation_units a 
							 On p.partition_id = a.container_id
                            Inner Join sys.schemas s 
							 On t.schema_id = s.schema_id
Group By t.Name, s.Name, p.Rows
Order By s.Name, t.Name
Go

-- Comparar Plano de Execu��o --