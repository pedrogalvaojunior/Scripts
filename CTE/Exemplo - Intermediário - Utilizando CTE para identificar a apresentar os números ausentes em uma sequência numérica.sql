-- Criando o Banco de Dados --
Create Database ControleDeEstoque
Go

-- Acessando o Banco de Dados --
Use ControleDeEstoque
Go

-- Bloco de Código 2 -- Criando a Tabela Movimentacao —
Create Table Movimentacao
(CodigoMovimentacao Int Primary Key Identity(1,1),
CodigoProduto Int Not Null,
 CodigoLancamentoContabil Int Not Null,
DataMovimentacao Date Default GetDate())
Go

-- Bloco de Código 3 – Inserindo a massa de dados na Tabela Movimentacao --
Insert Into Movimentacao (CodigoLancamentoContabil, CodigoProduto)
Values (1,1),(2,1),(3,1),(4,1),
(1,2),(2,2),(3,2),(4,2),
(1,3),(2,3),(3,3),(4,3)
Go

-- Consultando os dados --
Select CodigoMovimentacao, CodigoLancamentoContabil, CodigoProduto, DataMovimentacao
From Movimentacao
Go

-- Bloco de Código 4 – Removendo alguns lançamentos para similar a ausência numérica --
Delete From Movimentacao
Where CodigoProduto = 2
And CodigoLancamentoContabil = 1
Go

Delete From Movimentacao
Where CodigoProduto = 3
And CodigoLancamentoContabil = 2
Go

Delete From Movimentacao
Where CodigoProduto = 3
And CodigoLancamentoContabil = 3
Go

-- Bloco de Código 5 – Identificando as quantidades de lançamentos contábeis por produtos --
Select M.CodigoProduto, 
           Min(CodigoLancamentoContabil) As MenorLancamentoCadastrado,
           Max(CodigoLancamentoContabil) As MaiorLancamentoCadastrado,
           Count(CodigoLancamentoContabil) As QuantidadeLancamento
From Movimentacao M
Group By M.CodigoProduto
Go

-- Utilizando CTE --
Declare  @CodigoProduto TinyInt = 3,
              @QuantidadeLancamentosContabeis TinyInt

Set @QuantidadeLancamentosContabeis= (Select Max(CodigoLancamentoContabil) From Movimentacao Where CodigoProduto = @CodigoProduto Group By CodigoProduto)
 
;With CTEIdentificarSequenciaNumerica (CodigoProduto, NumeroSequencial)
As
(
 Select @CodigoProduto As CodigoProduto, 1 As NumeroSequencial

 Union All
 
 Select CodigoProduto, NumeroSequencial+1 From CTEIdentificarSequenciaNumerica
 Where NumeroSequencial < @QuantidadeLancamentosContabeis
)

Select C.CodigoProduto, C.NumeroSequencial, 'Lançamentos Cadastrados' As Status 
From CTEIdentificarSequenciaNumerica C 
Where C.NumeroSequencial In (Select CodigoLancamentoContabil From Movimentacao Where CodigoProduto = C.CodigoProduto)

 Union 

Select C.CodigoProduto, C.NumeroSequencial, 'Lançamentos não Cadastrados' As Status 
From CTEIdentificarSequenciaNumerica C 
Where C.NumeroSequencial Not In (Select CodigoLancamentoContabil From Movimentacao Where CodigoProduto = C.CodigoProduto)
Go