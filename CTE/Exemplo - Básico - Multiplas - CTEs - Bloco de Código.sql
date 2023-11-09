Create Table Tabela1
(Codigo Int, 
 Descricao Char(10))
Go

Create Table Tabela2
(Valor1 Int, 
 Valor2 Char(10))
Go

-- Multiplas CTES --
;With CTE1 (Codigo, Descricao)
As
(Select Codigo, Descricao from Tabela1),

CTE2 (Valor1, Valor2)
As
(Select Valor1, Valor2 From Tabela2)

Select T1.*, T2.* From Tabela1 T1, Tabela2 T2