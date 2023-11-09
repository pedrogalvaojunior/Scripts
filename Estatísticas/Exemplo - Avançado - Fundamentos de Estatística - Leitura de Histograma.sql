Use AdventureWorks2014
Go

-- Consultando informações sobre as opções de estatísticas --
Select is_auto_create_stats_on, 
           is_auto_update_stats_on, 
		   name
From sys.databases
Where database_id = DB_ID('AdventureWorks2014')
Go

-- Contando a quantidade de linhas da Tabela Production.TransactionHistory --
Select Count(*) From Production.TransactionHistory
Go  

-- Descobrindo o tamanho da Tabela Production.TransactionHistory --
Exec sp_spaceused 'Production.TransactionHistory'
Go

-- Executando uma simples query --
Select * From Production.TransactionHistory 
Where TransactionDate = '20070906' and Quantity > 10
Go

-- Consultando os Metadados das Estatísticas --
Select OBJECT_NAME(a.object_id) AS Objeto, 
             a.name, a.auto_created
From sys.stats a
Where OBJECT_NAME(a.object_id) = 'TransactionHistory'
Go


-- Apresentando o Histograma --
DBCC SHOW_STATISTICS("Production.TransactionHistory", _WA_Sys_00000005_22401542)
Go

-- Obtendo a quantidade de linhas, com base, na coluna EQ_Rows do Histograma --
Select * From Production.TransactionHistory 
Where TransactionDate = '2013-08-03'
Go

-- Consultando um valor fora da faixa de valores, com base, na coluna RANGE_HI_KEY --
Select * From Production.TransactionHistory 
Where TransactionDate = '2013-08-04'
Go

/* Como o valor utilizado como parâmetro, não aparece no RANGE_HI_KEY, o SQL Server utilizou o valor que está de 
maneira “oculta” na linha de número 4 (olhar a explicação contida sobre RANGE_ROWS discutido anteriormente).
Basicamente o SQL Server pegou o valor da coluna RANGE_ROWS do HISTOGRAMA e dividiu pelo valor 
DISTINCT_RANGE_ROWS, sendo 466/2. Algo similar á:

Select RANGE_Rows / DISTINCT_RANGE_ROWS ou 466 / 2/*

