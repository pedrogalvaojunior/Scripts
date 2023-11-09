Create table #Exemplo (codigo int, nome varchar(10), idUsuario int)

 

insert into #Exemplo (codigo, nome, idUsuario) Values (1,'jose', 12)

insert into #Exemplo (codigo, nome, idUsuario) Values (2,'mario', 7)

insert into #Exemplo (codigo, nome, idUsuario) Values (1,'jose', 14)

insert into #Exemplo (codigo, nome, idUsuario) Values (2,'mario', 12)

insert into #Exemplo (codigo, nome, idUsuario) Values (3,'celso', 7)

insert into #Exemplo (codigo, nome, idUsuario) Values (4,'andre', 14)



Select [jose],[mario],[celso],[andre] from #exemplo 

Pivot (count(codigo) for nome in ([jose],[mario],[celso],[andre])) p

-- CTE com Pivot --
with consulta as (select codigo, nome from #Exemplo) 

Select [jose],[mario],[celso],[andre] from Consulta 

Pivot (count(codigo) for nome in ([jose],[mario],[celso],[andre])) p


-- Trabalhando com funções de agregação no Pivot
CREATE TABLE Sales (EmpId INT, Yr INT, Sales MONEY)

INSERT Sales VALUES(1, 2005, 12000)

INSERT Sales VALUES(1, 2006, 18000)

INSERT Sales VALUES(1, 2007, 25000)

INSERT Sales VALUES(2, 2005, 15000)

INSERT Sales VALUES(2, 2006, 6000)

INSERT Sales VALUES(3, 2006, 20000)

INSERT Sales VALUES(3, 2007, 24000)

 

SELECT [2005], [2006], [2007]

FROM (SELECT Yr, Sales FROM Sales) AS s

PIVOT (SUM(Sales) FOR Yr IN ([2005], [2006], [2007])) AS p


SELECT [2005], [2006], [2007], [2005] + [2006] + [2007] As Total

FROM (SELECT Yr, Sales FROM Sales) AS s

PIVOT (SUM(Sales) FOR Yr IN ([2005], [2006], [2007])) AS p


