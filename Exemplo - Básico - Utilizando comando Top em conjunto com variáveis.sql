Use tempdb
Go

-- Criando a Tabela Numeros--
Create Table Numeracao
 (Linha TinyInt Identity(1,1),
  Numeros TinyInt Not Null)
Go

-- Inserindo 25 linhas de registro --
Insert Into Numeracao
Values (1), (1), (1), (1), (1),
             (2), (2), (2), (2), (2),
             (3), (3), (3), (3), (3),
             (4), (4), (4), (4), (4),
             (5), (5), (5), (5), (5)
Go

-- Consultando todos os dados --
Select Linha, Numeros from Numeracao
Go

-- Utilizando o comando Select Distinct eliminando linhas repetidas no Select --
Select Distinct Numeros From Numeracao
Go

-- Retornando as 10 primeiras linhas de registro --
Select Top 10 Linha, Numeros From Numeracao
Order By Linha Asc
Go

-- Retornando as 10 últimas linhas de registro --
Select Top 10 Linha, Numeros From Numeracao
Order By Linha Desc
Go

-- Retornando 30 porcento de linhas de registro --
Select Top 30 Percent Linha, Numeros From Numeracao
Order By Linha Desc -- Verificar se realmente é necessário utilizar o Order By --
Go

-- Apresentando o percentual aleatório de linhas existentes na Tabela Numeracao criando uma Query Dinâmica + Debug --
Declare @Porcentagem TinyInt, @Comando Varchar(200)

Set @Porcentagem = Rand()*100
Set @Comando = Concat('Select Top ', @Porcentagem, ' Percent Linha, Numeros From Numeracao')

-- Simulando um Debug --
--Print @Comando
-- Ou --
--Select @Comando

-- Fazer um CTRL+C e CTRL+V para testar o comando ---

-- Apresentando o resultado da variável --
Select Concat(@Porcentagem,'%') As 'Porcentagem'

-- Executando a Query Dinâmica --
Exec (@Comando)
Go

-- Apresentando o percentual aleatório de linhas existentes na Tabela Numeracao passando a variável diretamente no Top --
Declare @Porcentagem TinyInt

Set @Porcentagem = Rand()*100

-- Apresentando o resultado da variável --
Select Concat(@Porcentagem,'%') As 'Porcentagem'

Select Top(@Porcentagem) Percent Linha, Numeros From Numeracao
Go