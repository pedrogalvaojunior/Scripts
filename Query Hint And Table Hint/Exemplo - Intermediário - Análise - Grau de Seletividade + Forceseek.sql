-- Acessando --
Use Indices
Go

-- Criando a Tabela1 --
Create Table Tabela1 
(Coluna1 Int, 
 Coluna2 Int, 
 Coluna3 Int, 
 Coluna4 Int, 
 Coluna5 Char(200))
Go

-- Criando um novo �ndice Unique Clustered aplicado a Tabela1 vinculado com a Coluna1 --
Create Unique Clustered Index [IND_Unique_Clustered_Tabela1_Coluna1] On Tabela1(Coluna1)
Go

-- Criando um novo �ndice Non-Unique e NonClustered aplicado a Tabela1 vinculado a Coluna2 --
Create NonClustered Index [IND_NonClustered_Tabela1_Coluna2] On Tabela1(Coluna2)
Go

-- Desativando a contagem de linhas --
Set NoCount On
Go

-- Populando a Tabela1 com 100000 registros l�gicos --
Declare @Contador Int

Set @Contador = 0

While @Contador < 100000
Begin
 
 Insert Into Tabela1 Values (@Contador, @Contador, @Contador, @Contador, @Contador)
 
 Set @Contador = @Contador + 1

End
Go

--Ativar o Plano de Execu��o - CTRL + M -- Observar os tempos de processamento --

-- Verificando o grau de Seletividade --
-- Cen�rio 1 -- Baixo Seletivo --
Select Coluna1 From Tabela1
Where Coluna1 > 101 -- Index Scan realizado atrav�s do uso do IND_NonClustered_Tabela1_Coluna2 --
Go

-- Cen�rio 2 -- Alto Seletivo --
Select Coluna1 From Tabela1
Where Coluna1 > 89000 -- Clustered Index Seek realizado atrav�s do uso do IND_Unique_Clustered_Tabela1_Coluna1 --
Go

-- Cen�rio 3 - Baixo Seletivo --
Declare @Numero1 Int = 101

Select Coluna1 From Tabela1
Where Coluna1 > @Numero1 -- Index Scan realizado atrav�s do uso do IND_NonClustered_Tabela1_Coluna2 --
Go

-- Cen�rio 4 - Baixo Seletivo --
Declare @Numero2 Int = 89000

Select Coluna1 From Tabela1
Where Coluna1 > @Numero2  -- Index Scan realizado atrav�s do uso do IND_NonClustered_Tabela1_Coluna2 --
Go

-- For�ando o uso da Query Hint Forceseek para mudar o grau de seletividade na busca do dado -- Devemos analisar com cuidado --
-- Cen�rio 1 -- Mais Seletivo --
Select Coluna1 From Tabela1 With (Forceseek)
Where Coluna1 > 101 -- Clustered Index Seek realizado atrav�s do uso do IND_Unique_Clustered_Tabela1_Coluna1 --
Go

-- Cen�rio 1 -- Um pouco mais Seletivo --
Declare @Numero1 Int = 101

Select Coluna1 From Tabela1 With (Forceseek)
Where Coluna1 > @Numero1 -- Clustered Index Seek realizado atrav�s do uso do IND_Unique_Clustered_Tabela1_Coluna1 --
Go

-- Cen�rio 3 - Mais Seletivo --
Declare @Numero2 Int = 89000

Select Coluna1 From Tabela1 With (Forceseek)
Where Coluna1 > @Numero2  -- Clustered Index Seek realizado atrav�s do uso do IND_Unique_Clustered_Tabela1_Coluna1 --
Go
