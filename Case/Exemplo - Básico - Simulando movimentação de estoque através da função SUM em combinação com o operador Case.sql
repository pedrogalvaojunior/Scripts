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

-- Utilizando a função SUM() em combinação com o operador Case --
Select CodProduto,
       Sum(Case When CodOper = 901 Then + QTD Else - QTD End) As Quantidade
From Estoque
Group By CodProduto
Go