-- Criando um simples Select --
Select 1 + 2 As MeuSelect
Go

-- Criando uma simples View --
Create View MinhaView
As 
Select 1 + 2 As MeuSelect
Go

-- Executando a View --
Select * from MinhaView
Go

-- Criando uma simples CTE --
;With MinhaCTE (Valor1, Valor2)
As
(
Select 1 As Valor1, 2 As Valor2
)

--Executando a CTE --
Select Valor1+Valor2 From MinhaCTE
Go