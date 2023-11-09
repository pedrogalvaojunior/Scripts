-- Criando um sorteador de números pseudo-aleatórios --

-- Criando a Tabela para armazenar os números sorteados --
Create Table NumerosSorteados
(Codigo Int Primary Key Identity(1,1),
 NumeroSorteado Int Not Null)
Go

-- Desativando a contagem de linhas processadas --
Set NoCount On
Go

-- Exemplo 1 - Utilizando operador Exists --
-- Removendo números sorteados anteriormente --
Truncate Table NumerosSorteados
Go

-- Declarando as variáveis de controle --
Declare @ContadorDeNumeros Int, @NumeroSorteado Int, @QuantidadeDeNumeros Int

-- Atribuindo os valores iniciais --
Set @ContadorDeNumeros = 0
Set @NumeroSorteado=0
Set @QuantidadeDeNumeros=Rand()*10000

-- Realizando o Sorteio --
-- Apresentando os números sorteados --
Print 'Números sorteados'

While @ContadorDeNumeros <= @QuantidadeDeNumeros
Begin

 Set @NumeroSorteado = Rand()*@QuantidadeDeNumeros

 If Exists (Select NumeroSorteado From NumerosSorteados Where NumeroSorteado = @NumeroSorteado)
  Set @NumeroSorteado = Rand()*@QuantidadeDeNumeros
 Else
  Insert Into NumerosSorteados Values (@NumeroSorteado)

 Print @NumeroSorteado

 Set @ContadorDeNumeros = @ContadorDeNumeros + 1
End
Go

-- Apresentando os números em ordem Crescente --
Select NumeroSorteado From NumerosSorteados
Order By NumeroSorteado Asc
Go

-- Apresentando os números em ordem Decrescente --
Select NumeroSorteado From NumerosSorteados
Order By NumeroSorteado Desc
Go

-- Exemplo 2 - Utilizando operador Not Exists --
-- Removendo números sorteados anteriormente --
Truncate Table NumerosSorteados
Go

-- Declarando as variáveis de controle --
Declare @ContadorDeNumeros Int, @NumeroSorteado Int, @QuantidadeDeNumeros Int

-- Atribuindo os valores iniciais --
Set @ContadorDeNumeros = 0
Set @NumeroSorteado=0
Set @QuantidadeDeNumeros=Rand()*10000

-- Realizando o Sorteio --
-- Apresentando os números sorteados --
Print 'Números sorteados'

While @ContadorDeNumeros <= @QuantidadeDeNumeros
Begin

 Set @NumeroSorteado = Rand()*@QuantidadeDeNumeros

 If Not Exists (Select NumeroSorteado From NumerosSorteados Where NumeroSorteado = @NumeroSorteado)
  Begin
   Insert Into NumerosSorteados Values (@NumeroSorteado)
   Print @NumeroSorteado
  End

 Set @ContadorDeNumeros = @ContadorDeNumeros + 1
End
Go

-- Apresentando os números em ordem Crescente --
Select NumeroSorteado From NumerosSorteados
Order By NumeroSorteado Asc
Go

-- Apresentando os números em ordem Decrescente --
Select NumeroSorteado From NumerosSorteados
Order By NumeroSorteado Desc
Go

-- Exemplo 3 - Sorteando a quantidade total de números definidos aleatoriamente --
-- Removendo números sorteados anteriormente --
Truncate Table NumerosSorteados
Go

-- Declarando as variáveis de controle --
Declare @ContadorDeNumeros Int, @NumeroSorteado Int, @QuantidadeDeNumeros Int

-- Atribuindo os valores iniciais --
Set @ContadorDeNumeros = 0
Set @NumeroSorteado=0
Set @QuantidadeDeNumeros=Rand()*10000

-- Realizando o Sorteio --
-- Apresentando os números sorteados --
Print Concat('Total de Números sorteados:',@QuantidadeDeNumeros)

While @ContadorDeNumeros < @QuantidadeDeNumeros
Begin

 Set @NumeroSorteado = Rand()*10000

 If Not Exists (Select NumeroSorteado From NumerosSorteados Where NumeroSorteado = @NumeroSorteado)
  Begin
   Insert Into NumerosSorteados Values (@NumeroSorteado)
   Print @NumeroSorteado

   Set @ContadorDeNumeros = @ContadorDeNumeros + 1
  End
   
End
Go

-- Apresentando os números em ordem Crescente --
Select NumeroSorteado From NumerosSorteados
Order By NumeroSorteado Asc
Go

-- Apresentando os números em ordem Decrescente --
Select NumeroSorteado From NumerosSorteados
Order By NumeroSorteado Desc
Go

-- Exemplo 4 - Utilizando coluna calculada --
-- Criando a Tabela NumerosAleatorios --
Create Table NumerosAleatorios
(Codigo Int Primary Key Identity(1,1),
 NumeroAleatorio As (Codigo*Rand()*100))
Go

-- Removendo números sorteados anteriormente --
Truncate Table NumerosAleatorios
Go

-- Inserindo 1000 pseudo números aleatórios --
Insert Into NumerosAleatorios Default Values
Go 1000

If Exists (Select name from sys.tables where name='NumerosSorteados')
 Drop Table NumerosSorteados

-- Materializando os números em uma nova tabela, este procedimento é necessário pois a cada execução do Select é sorteado outros números --
Select Convert(Int,NumeroAleatorio) As Numero Into NumerosSorteados From NumerosAleatorios
Go

-- Ordem Crescente --
Select Numero From NumerosSorteados
Order By Numero Asc
Go

-- Ordem Decrescente --
Select Numero From NumerosSorteados
Order By Numero Desc
Go