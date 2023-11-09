-- Declarando vari�veis para recebimento de valores --
Declare @Valor1 SmallInt,
              @Valor2 SmallInt
             
-- Atribui��o de valores para vari�veis --
Set @Valor1 = 10
Set @Valor2 = 20

-- Opera��es Matem�ticas --
Select @Valor1 + @Valor2 As 'Adi��o'
Select @Valor1 - @Valor2 As 'Subtra��o'
Select @Valor1 * @Valor2 As 'Multiplica��o'
Select @Valor1 / @Valor2 As 'Divis�o'

-- Deixando o C�digo mais Simples realizando o Agrupamento de Selects --
Select @Valor1 + @Valor2 As 'Adi��o', 
		   @Valor1 - @Valor2 As 'Subtra��o',
           @Valor1 * @Valor2 As 'Multiplica��o',
		   @Valor1 / @Valor2 As 'Divis�o'
		   
-- Realizando a Uni�o de Selects semelhantes --
Select @Valor1 + @Valor2 As 'Adi��o'
Union
Select @Valor1 - @Valor2 As 'Subtra��o'
Union
Select @Valor1 * @Valor2 As 'Multiplica��o'
Union
Select @Valor1 / @Valor2 As 'Divis�o'


-- Realizando a Uni�o Total de Selects semelhantes --
Select @Valor1 + @Valor2 As 'Adi��o'
Union All
Select @Valor1 - @Valor2 As 'Subtra��o'
Union All
Select @Valor1 * @Valor2 As 'Multiplica��o'
Union All
Select @Valor1 / @Valor2 As 'Divis�o'


-- Realizando a Uni�o Total de Selects semelhantes com Ordena��o por Colunas --
Select @Valor1 + @Valor2 As Resultado, 'Adi��o' As 'Operacao'
Union All
Select @Valor1 - @Valor2 As Resultado, 'Subtra��o' As 'Operacao'
Union All
Select @Valor1 * @Valor2 As Resultado, 'Multiplica��o' As 'Operacao'
Union All
Select @Valor1 / @Valor2 As Resultado, 'Divis�o' As 'Operacao'
Order By Operacao Desc

Select @Valor1 + @Valor2 As Resultado, 'Adi��o' As 'Operacao'
Union All
Select @Valor1 - @Valor2 As Resultado, 'Subtra��o' As 'Operacao'
Union All
Select @Valor1 * @Valor2 As Resultado, 'Multiplica��o' As 'Operacao'
Union All
Select @Valor1 / @Valor2 As Resultado, 'Divis�o' As 'Operacao'
Order By Resultado ASC