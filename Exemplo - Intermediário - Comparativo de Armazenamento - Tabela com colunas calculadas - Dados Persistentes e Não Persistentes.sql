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
Values ('Arroz', 10), ('Feijão', 20), ('Ovo', 30), ('Tomate', 40), ('Carne', 50), ('Bolacha', 60), ('Leite', 70), ('Suco', 80)
Go

-- Inserindos valores fixos - TabelaDadosNaoPersisentes --
Insert Into TabelaDadosNaoPersistentes (Descricao, Valor)
Values ('Arroz', 10), ('Feijão', 20), ('Ovo', 30), ('Tomate', 40), ('Carne', 50), ('Bolacha', 60), ('Leite', 70), ('Suco', 80)
Go

-- Consultando a estrutura física e lógica - TabelaDadosPersistentes --
SP_Help 'TabelaDadosPersistentes'
Go

-- Consultando a estrutura física e lógica - TabelaDadosNaoPersistentes --
SP_Help 'TabelaDadosNaoPersistentes'
Go

-- Consultando o espaço ocupado em disco - TabelaDadosPersistentes --
SP_SpaceUsed 'TabelaDadosPersistentes'
Go

-- Consultando o espaço ocupado em disco - TabelaDadosNaoPersistentes --
SP_SpaceUsed 'TabelaDadosNaoPersistentes'
Go

-- Inserindo os mesmos valores aleatórios - TabelaDadosPersistentes e TabelaDadosNaoPersistentes --
Declare @Contador SmallInt, @NumeroSorteado Int, @DescricaoSorteada Varchar(30), @ValorSorteado Int 

Set @Contador = 1
Set @NumeroSorteado = Rand()*10000 -- Sorteando a quantidade aleatória de registros até o número 10000 --

While @Contador <= @NumeroSorteado
Begin
 
 Set @DescricaoSorteada = (Concat(Char(Rand()*96), Char(Rand()*96), Char(Rand()*96), Char(Rand()*96), Char(Rand()*96))) -- Concatenado caracteres para formar a descricao aleatória --
 Set @ValorSorteado = Rand()*100 -- Sorteando o número para a coluna valor --

 -- Inserindo os valores aleatórios --
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

-- Comparando as diferenças de espaço ocupado e armazenamento --
Select s.Name As 'Schema',
           t.Name As 'Nome da Tabela',
           p.rows As 'Quantidade de Registros',
           Cast(Round((Sum(a.used_pages) / 128.00), 2) As Numeric(36, 2)) AS 'Espaço Ocupado Mbs',
           Cast(Round((Sum(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) As Numeric(36, 2)) AS 'Espaço Não Ocupado Mbs',
           Cast(Round((Sum(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) As 'Total de Área de Armazenamento reservada'
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

-- Comparar Plano de Execução --