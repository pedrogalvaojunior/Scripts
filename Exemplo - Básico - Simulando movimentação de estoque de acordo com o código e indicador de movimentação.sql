-- Criando a Tabela --
Create Table Estoque
(CodProduto Int,
 CodOper Int,
 QTD Float,
 IDN_Estoque Char(1))
Go

-- Inserindo os valores --
Insert Into Estoque Values (290, 901, 15, '+'),(290, 902, 4, '-'),
                           (291, 901, 10, '+'),(291, 902, 2, '-'),
                           (292, 901, 8, '+'),(292, 902, 5, '-'),
                           (290, 901, 2, '+'),(290, 902, 4, '-')                           
Go

-- Consultando --
Select * From Estoque
Go

-- Usando CTE --
;With SomaEntradas (CodProduto, QTDEntrada)
As
(Select CodProduto, Sum(QTD) From Estoque 
 Where CodOper = 901
 Group By CodProduto)
,
SomaSaidas (CodProduto, QTDSaida)
As
(Select CodProduto, Sum(QTD) From Estoque 
 Where CodOper = 902
 Group By CodProduto)
Select SE.CodProduto, (SE.QTDEntrada-SS.QTDSaida) As Quantidade
From SomaEntradas SE Inner Join SomaSaidas SS
                      On SE.CodProduto = SS.CodProduto
Go

-- Utilizando Views --
Create View V_SomaEntrada
As
(Select CodProduto, Sum(QTD) As SomaEntrada From Estoque 
 Where CodOper = 901
 Group By CodProduto)
Go

Create View V_SomaSaida
As
(Select CodProduto, Sum(QTD) As SomaSaida From Estoque 
 Where CodOper = 902
 Group By CodProduto)
Go

Select SE.CodProduto, (SE.SomaEntrada-SS.SomaSaida) As Quantidade
From V_SomaEntrada SE Inner Join V_SomaSaida SS
                      On SE.CodProduto = SS.CodProduto
Go

-- Utilizando Select Derivado --
Select Entrada.CodProduto, (Entrada.QTD - Saida.QTD) As Quantidade
 FROM
 (Select CodProduto, SUM(QTD) As QTD From Estoque Where CodOper=901 Group By CodProduto) AS Entrada Inner Join
 (Select CodProduto, SUM(QTD) As QTD From Estoque Where CodOper=902 Group By CodProduto) AS Saida
 On Entrada.CodProduto = Saida.CodProduto
Go




