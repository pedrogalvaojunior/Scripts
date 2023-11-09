-- Criando a Tabela --
Create Table Percentiles
(Grupo TinyInt,
 Numeros TinyInt)
Go

-- Inserindo os valores
Insert Into Percentiles (Grupo, Numeros)
Select 1, n From (Values(15),(20),(35),(40),(50)) As Grupo1(N)
Union ALL 
Select 2, n From (Values(3),(6),(7),(8),(8),(10),(13),(15),(16), (20)) As Grupo2(N)
Union ALL 
Select 3, n From (Values(3),(6),(7),(8),(8),(9),(10),(13),(15),(16), (20)) As Grupo3(N)
Go

-- Declarando a CTE_Percentile_Cont --
;With CTE_Percentile_Cont(Grupo, "25th","50th","75th","100th")
As
(
 Select Grupo,
            Percentile_CONT(0.25) WITHIN GROUP (ORDER BY Numeros) OVER (PARTITION BY Grupo) As '25th',
            Percentile_CONT(0.50) WITHIN GROUP (ORDER BY Numeros) OVER (PARTITION BY Grupo) As '50th',
            Percentile_CONT(0.75) WITHIN GROUP (ORDER BY Numeros) OVER (PARTITION BY Grupo) As '75th',
            Percentile_CONT(1.00) WITHIN GROUP (ORDER BY Numeros)  OVER (PARTITION BY Grupo) As '100th'
 From Percentiles
)
-- Apresentando os dados --
Select Grupo, Max([25th]) As '25th', Max([50th]) As '50th', Max([75th]) '75th', Max([100th]) As '100th'
From CTE_Percentile_Cont
Group By Grupo

-- Declarando a CTE_Percentile_Disc --
;With CTE_Percentile_Disc(Grupo, "25th","50th","75th","100th")
As
(
 Select Grupo,
            Percentile_Disc(0.25) WITHIN GROUP (ORDER BY Numeros) OVER (PARTITION BY Grupo) As '25th',
            Percentile_Disc(0.50) WITHIN GROUP (ORDER BY Numeros) OVER (PARTITION BY Grupo) As '50th',
            Percentile_Disc(0.75) WITHIN GROUP (ORDER BY Numeros) OVER (PARTITION BY Grupo) As '75th',
            Percentile_Disc(1.00) WITHIN GROUP (ORDER BY Numeros)  OVER (PARTITION BY Grupo) As '100th'
 From Percentiles
)

-- Apresentando os dados --
Select Grupo, Max([25th]) As '25th', Max([50th]) As '50th', Max([75th]) '75th', Max([100th]) As '100th'
From CTE_Percentile_Disc
Group By Grupo

-- Realizar o comparativo --