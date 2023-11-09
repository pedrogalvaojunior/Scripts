-- Exemplo 1 -- While --
Set NoCount On
Go

Declare @NumeroInicial Int=1, @NumeroFinal Int=100

While @NumeroInicial <= @NumeroFinal
 Begin

  Select @NumeroInicial As Numeracao
  
  Set @NumeroInicial +=1
 End
Go

-- Exemplo 2 -- Insert Into Default Values + Go com número de recursividade --
Create Table TabelaNumeracao 
 (Numero Int Identity(0,2))

Insert Into TabelaNumeracao Default Values
Go 1000

Select * From TabelaNumeracao
Go

-- Exemplo 3 -- Cursor --
Declare @Contador Int=0, @NumeroAtual Int=0

Declare Cursor_Numeracao Cursor For
Select * From TabelaNumeracao
Order By Numero Desc

Open Cursor_Numeracao
While @Contador <= (Select Max(Numero) From TabelaNumeracao)
Begin
 
  Fetch Next From Cursor_Numeracao
  Into @NumeroAtual

  Print Concat('O número atual é: ', @NumeroAtual)

  Set @Contador +=2
  
 End
Go

Close Cursor_Numeracao
Deallocate Cursor_Numeracao
Go

-- Exemplo 4 -- CTE Recursiva -- 
Declare @NumeroInicial Int=1, @NumeroFinal Int=100

;With CTENumeracaoSequencial (Numeracao)
As
(Select @NumeroInicial As Numero
 Union All
 Select 1+Numeracao As NumeroSequencial From CTENumeracaoSequencial
 Where Numeracao < @NumeroFinal)

Select * From CTENumeracaoSequencial
Go

-- Exemplo 5 -- Multíplas CTE Recursivas -- 
;WITH CTEUm 
As 
(Select 1 As Um Union ALL SELECT 1)
,CTEUnidade
As
(Select 1 As Unidade From CTEUm C1, CTEUm C2)
,CTEDezena
As
(Select 1 As Dezena From CTEUnidade C1, CTEUnidade C2)
,CTECentena
As
(Select 1 As Centena From CTEDezena C1, CTEDezena C2)
,CTEMilhar
As
(Select 1 As Milhar From CTECentena C1, CTECentena C2)
,Numeracao 
As
(Select ROW_NUMBER() OVER (ORDER BY (SELECT 1)) as Numeracao From CTEMilhar)
Select * From Numeracao
Go

-- Exemplo 6 -- CTE com Operador de Junção Cross Join --
;With CTENumeracao (Numero)
As
(
 Select * From 
               (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoUnidade (NumeroUnidade)
)
Select Unidade.Numero+Dezena.Numero*10+Centena.Numero*100+Milhar.Numero*1000 As Numero
From CTENumeracao Unidade 
                       Cross Join CTENumeracao Dezena 
					   Cross Join CTENumeracao Centena 
					   Cross Join CTENumeracao Milhar
Order By Numero
Go

-- Exemplo 7 -- CTE com Junção Cruzada Direta --
;With CTENumeracao (Numero)
As
(
 Select * From 
               (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoUnidade (NumeroUnidade)
)
Select Unidade.Numero+Dezena.Numero*10+Centena.Numero*100+Milhar.Numero*1000 As Numero
From CTENumeracao Unidade, CTENumeracao Dezena, CTENumeracao Centena, CTENumeracao Milhar
Order By Numero
Go

-- Exemplo 8 -- Objeto Sequence --
Create Sequence dbo.Numeracao As Int
Start With 1
Increment By 1
MinValue 1
MaxValue 5000
Cycle
Go

Select Next Value For dbo.Numeracao As NumeroLinha, Numero From TabelaNumeracao
Go

Alter Sequence dbo.Numeracao
Restart With 1
Go

-- Exemplo 9 -- Select com Função Row_Number() --
Select Row_Number() Over (Order By Numero) NumeroLinha, 
           Numero 
From TabelaNumeracao
Go

-- Exemplo 10 -- Stored Procedure --
Truncate Table TabelaNumeracao
Go

Create Or Alter Procedure P_NumeracaoSequencial @NumeracaoSequencial Int
As
Set NoCount On

Declare @Contador Int=1

While @Contador <= @NumeracaoSequencial
 Begin
  Begin Transaction
  
  Insert Into TabelaNumeracao With (TabLockX) Default Values

  Commit Transaction

  Set @Contador += 2
 End  
Go

-- Executando --
Execute P_NumeracaoSequencial 100
Go

Select * From TabelaNumeracao
Go

-- Exemplo 11 -- User Defined Function --
Create Or Alter Function F_SequencialNumerica (@Numero Int=0)
Returns Table 
Return 
 Select Unidade+Dezena*10+Centena*100+Milhar*1000 AS Numeracao From
   (Select 0 AS Unidade Union Select 1 Union Select 2 Union Select 3 Union Select 4
     Union Select 5 Union Select 6 Union Select 7 Union Select 8 Union Select 9) SequenciaUnidade,
   (Select 0 AS Dezena Union Select 1 Union Select 2 Union Select 3 Union Select 4
     Union Select 5 Union Select 6 Union Select 7 Union Select 8 Union Select 9 ) SequenciaDezena,
   (Select 0 AS Centena Union Select 1 Union Select 2 Union Select 3 Union Select 4
     Union Select 5 Union Select 6 Union Select 7 Union Select 8 Union Select 9 ) SequenciaCentena,
   (Select 0 AS Milhar Union Select 1 Union Select 2 Union Select 3 Union Select 4
     Union Select 5 Union Select 6 Union Select 7 Union Select 8 Union Select 9 ) SequenciaMilhar
Go

-- Executando --
Select * From F_SequencialNumerica(0)
Where Numeracao=15
Go

-- Exemplo 12 -- Select ... Values com Função Concat() e Operador de Junção Cross Join --
Select CONCAT(NumeroUnidade,NumeroDezena,NumeroCentena, NumeroMilhar) As 'Caractere',
                        (NumeroUnidade+NumeroDezena*10+NumeroCentena*100+NumeroMilhar*1000) As 'Numerico'
 From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoUnidade (NumeroUnidade)
  Cross Join (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoDezena (NumeroDezena)
  Cross Join (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoCentena (NumeroCentena)
  Cross Join (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoMilhar (NumeroMilhar)
Order By 'Numerico'
Go

-- Exemplo 13 -- Select ... Values com Função Concat() e Junção Cruzada Direta --
Select CONCAT(NumeroUnidade,NumeroDezena,NumeroCentena, NumeroMilhar) As 'Caractere',
                        (NumeroUnidade+NumeroDezena*10+NumeroCentena*100+NumeroMilhar*1000) As 'Numerico'
 From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoUnidade (NumeroUnidade),
          (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoDezena (NumeroDezena),
          (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoCentena (NumeroCentena),
          (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoMilhar (NumeroMilhar)
Order By Numerico
Go

-- Exemplo 14 -- Select ... Values com Funções Try_Convert() e Concat() com Junção Cruzada Direta --
Select Try_Convert(Int, CONCAT(NumeroUnidade,NumeroDezena,NumeroCentena, NumeroMilhar),0) As 'Numerico'
 From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoUnidade (NumeroUnidade),
          (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoDezena (NumeroDezena),
          (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoCentena (NumeroCentena),
          (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As NumeracaoMilhar (NumeroMilhar)
Order By Numerico
Go

-- Exemplo 15 -- Select Tabela Derivada com Subquery Select ... Values --
Select NumeroUnidade+NumeroDezena*10+NumeroCentena*100+NumeroMilhar*1000 As Numero 
From 
 (Select * From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As Numeracao (NumeroUnidade)) As Unidade,
 (Select * From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As Numeracao (NumeroDezena)) As Dezena,
 (Select * From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As Numeracao (NumeroCentena)) As Centena,
 (Select * From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As Numeracao (NumeroMilhar)) As Milhar
Order By Numero
Go

-- Exemplo 16 -- Select Tabela Derivada com Função Convert() em conjunto com Select Tabela Derivada mais Subquery Select ... Values --
Select Convert(Int, Numero) As Numero From 
(
 Select CONCAT(NumeroUnidade,NumeroDezena,NumeroCentena, NumeroMilhar) As Numero 
 From 
  (Select * From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As Numeracao (NumeroUnidade)) As Unidade,
  (Select * From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As Numeracao (NumeroDezena)) As Dezena,
  (Select * From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As Numeracao (NumeroCentena)) As Centena,
  (Select * From (Values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) As Numeracao (NumeroMilhar)) As Milhar
) As Numeracao
Where Numero>0
Order By Numero
Go
