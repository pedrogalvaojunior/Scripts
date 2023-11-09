-- Exemplo 1 - Simulando a ocorrência de Merge Join Concatenation --
Declare @Tabela1 As Table
 (Coluna1 Int,
  Coluna2 Int,
  Coluna3 Int)

Declare @Tabela2 As Table
 (Coluna1 Int,
  Coluna2 Int,
  Coluna3 Int)
 
-- Ativar Plano de Execução - CTRL + M --
-- Declarando a Query Hint Merge Union --
Select * From @Tabela1 As T1 
Union All
Select * From @Tabela2 As T2
Option (Merge Union)
Go

-- Exemplo 2 - Simulando a ocorrência de Concatenation --
Declare @Tabela1 As Table
 (Coluna1 Int,
  Coluna2 Int,
  Coluna3 Int)

Declare @Tabela2 As Table
 (Coluna1 Int,
  Coluna2 Int,
  Coluna3 Int)
 
-- Declarando a Query Hint Merge Join --
Select * From @Tabela1 As T1 
Union All
Select * From @Tabela2 As T2
Option (Merge Join)
Go

-- Exemplo 3 - Simulando Merge Join com base na ordenação das colunas declaradas no Select --
Declare @Tabela1 As Table
 (Coluna1 Int,
  Coluna2 Int,
  Coluna3 Int)

Declare @Tabela2 As Table
 (Coluna1 Int,
  Coluna2 Int,
  Coluna3 Int)
 
-- Declarando a Query Hint Merge Union --
Select Coluna3, Coluna2, Coluna1 From @Tabela1 As T1 
Union All
Select Coluna3, Coluna2, Coluna1 From @Tabela2 As T2
Option (Merge Union)
Go

-- Exemplo 4 - Simulando Merge Join com um conflito de ordenação entre as colunas declaradas no Select com base na colunas no comando Order By --
Declare @Tabela1 As Table
 (Coluna1 Int,
  Coluna2 Int,
  Coluna3 Int)

Declare @Tabela2 As Table
 (Coluna1 Int,
  Coluna2 Int,
  Coluna3 Int)
 
-- Declarando a Query Hint Merge Union --
Select Coluna3, Coluna2, Coluna1 From @Tabela1 As T1 
Union All
Select Coluna3, Coluna2, Coluna1 From @Tabela2 As T2
Order By Coluna1, Coluna2, Coluna3
Option (Merge Union)
Go

-- Exemplo 5 - Simulando Concatenation + Sort para contornar o conflito de ordenação de colunas declaradas no Select com base no Order By --
Declare @Tabela1 As Table
 (Coluna1 Int,
  Coluna2 Int,
  Coluna3 Int)

Declare @Tabela2 As Table
 (Coluna1 Int,
  Coluna2 Int,
  Coluna3 Int)
 
-- Declarando a Query Hint Merge Join --
Select Coluna3, Coluna2, Coluna1 From @Tabela1 As T1 
Union All
Select Coluna3, Coluna2, Coluna1 From @Tabela2 As T2
Order By Coluna1, Coluna2, Coluna3
Option (Merge Join)
Go