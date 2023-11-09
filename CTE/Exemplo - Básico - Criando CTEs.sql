-- Exemplo 1 - Criando uma simples CTE --
;With Exemplo1(Valor, Nome)
As
(
 Select 1, 'Pedro Galvão' As Nome
)
Select * from Exemplo1
Go

-- Exemplo 2 - Criando uma CTE com Union de Selects --
;With Exemplo2(Valor)
As
(
 Select 10
 Union
 Select 50
 Union
 Select 8
 Union
 Select 10 + 2
)
Select Valor = (Select Max(valor) From Exemplo2)+
               (Select Sum(Valor) From Exemplo2)
Go