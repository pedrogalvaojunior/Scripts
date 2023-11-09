-- Declarando variáveis para recebimento de valores --
Declare @Valor1 SmallInt,
              @Valor2 SmallInt
             
-- Atribuição de valores para variáveis --
Set @Valor1 = 10
Set @Valor2 = 20

-- Operações Matemáticas --
Select @Valor1 + @Valor2 As 'Adição'
Select @Valor1 - @Valor2 As 'Subtração'
Select @Valor1 * @Valor2 As 'Multiplicação'
Select @Valor1 / @Valor2 As 'Divisão'

-- Deixando o Código mais Simples realizando o Agrupamento de Selects --
Select @Valor1 + @Valor2 As 'Adição', 
		   @Valor1 - @Valor2 As 'Subtração',
           @Valor1 * @Valor2 As 'Multiplicação',
		   @Valor1 / @Valor2 As 'Divisão'
		   
-- Realizando a União de Selects semelhantes --
Select @Valor1 + @Valor2 As 'Adição'
Union
Select @Valor1 - @Valor2 As 'Subtração'
Union
Select @Valor1 * @Valor2 As 'Multiplicação'
Union
Select @Valor1 / @Valor2 As 'Divisão'


-- Realizando a União Total de Selects semelhantes --
Select @Valor1 + @Valor2 As 'Adição'
Union All
Select @Valor1 - @Valor2 As 'Subtração'
Union All
Select @Valor1 * @Valor2 As 'Multiplicação'
Union All
Select @Valor1 / @Valor2 As 'Divisão'


-- Realizando a União Total de Selects semelhantes com Ordenação por Colunas --
Select @Valor1 + @Valor2 As Resultado, 'Adição' As 'Operacao'
Union All
Select @Valor1 - @Valor2 As Resultado, 'Subtração' As 'Operacao'
Union All
Select @Valor1 * @Valor2 As Resultado, 'Multiplicação' As 'Operacao'
Union All
Select @Valor1 / @Valor2 As Resultado, 'Divisão' As 'Operacao'
Order By Operacao Desc

Select @Valor1 + @Valor2 As Resultado, 'Adição' As 'Operacao'
Union All
Select @Valor1 - @Valor2 As Resultado, 'Subtração' As 'Operacao'
Union All
Select @Valor1 * @Valor2 As Resultado, 'Multiplicação' As 'Operacao'
Union All
Select @Valor1 / @Valor2 As Resultado, 'Divisão' As 'Operacao'
Order By Resultado ASC