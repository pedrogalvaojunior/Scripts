-- Acessando --
Use Loteria
Go

-- Implementa��o 1 -- Informando manualmente o n�mero do concurso -- 
-- Exemplo 1 - Aplicando o Unpivot, girando as colunas para linhas --
Select CodigoConcurso, ListaDeNumeros 
From (
          Select CodigoConcurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado 
          From ConcursosSorteados
         ) As C
Unpivot (
              ListaDeNumeros For NumeroSorteados In (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, 
                                                Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
              ) As UP
Where CodigoConcurso = 1
Go

-- Exemplo 2 - Identificando o menor e maior n�mero Sorteado --
Select CodigoConcurso, ListaDeNumeros 
From (
          Select CodigoConcurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado 
          From ConcursosSorteados
         ) As C
Unpivot (
               ListaDeNumeros For NumeroSorteados In (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, 
                                                                                    Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
              ) As UP
Where CodigoConcurso = 1
Group By CodigoConcurso
Go

-- Exemplo 3 - CTE - Identificando o Menor e Maior N�mero utilizando as fun��o Min() e Max() fora da CTE --
;With CTEListaDeNumerosSorteados (CodigoConcurso, ListaDeNumeros)
As
(Select CodigoConcurso, ListaDeNumeros 
 From (
            Select CodigoConcurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado 
            From ConcursosSorteados
           ) As C
 Unpivot (
                ListaDeNumeros For NumeroSorteados In (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, 
                                                                                     Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
               ) As UP
 Where CodigoConcurso = 1)
Select CodigoConcurso, Min(ListaDeNumeros) As Menor, Max(ListaDeNumeros) As Maior From CTEListaDeNumerosSorteados
Group By CodigoConcurso
Go

-- Exemplo 4 - CTE - Identificando o Menor e Maior N�mero utilizando as fun��o Min() e Max() dentro da CTE --
;With CTEListaDeNumerosSorteadosMenorMaior (CodigoConcurso, Menor, Maior)
As
(Select CodigoConcurso, 
            Min(ListaDeNumeros) As Menor, 
            Max(ListaDeNumeros) As Maior  
 From (
           Select CodigoConcurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado 
           From ConcursosSorteados
          ) As C
 Unpivot (
                ListaDeNumeros For NumeroSorteados In (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, 
                                                                                     Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
               ) As UP
 Where CodigoConcurso = 1
 Group By CodigoConcurso)
Select CodigoConcurso, Menor, Maior From CTEListaDeNumerosSorteadosMenorMaior
Go

-- Implementa��o 2 - Utilizando var�avel para informar o c�digo do concurso --
-- Acessando --
Use Loteria
Go

-- Declarando a var�avel @CodigoConcurso --
Declare @CodigoConcurso Smallint
Set @CodigoConcurso =10

-- Exemplo 1 - Aplicando o Unpivot, girando as colunas para linhas --
Select CodigoConcurso, ListaDeNumeros 
From (
		   Select CodigoConcurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado 
		   From ConcursosSorteados
		  ) As C
Unpivot (
               ListaDeNumeros For NumeroSorteados In (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, 
                                                                                    Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
              ) As UP
Where CodigoConcurso = @CodigoConcurso

-- Exemplo 2 - Identificando o menor e maior n�mero Sorteado --
Select CodigoConcurso, Min(ListaDeNumeros) As Menor, Max(ListaDeNumeros) As Maior
From (
           Select CodigoConcurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado 
           From ConcursosSorteados
          ) As C
Unpivot (
                ListaDeNumeros For NumeroSorteados In (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, 
                                                                                     Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
              ) As UP
Where CodigoConcurso = @CodigoConcurso
Group By CodigoConcurso

-- Exemplo 3 - CTE - Identificando o Menor e Maior N�mero utilizando as fun��o Min() e Max() fora da CTE --
;With CTEListaDeNumerosSorteados (CodigoConcurso, ListaDeNumeros)
As
(Select CodigoConcurso, ListaDeNumeros 
 From (
            Select CodigoConcurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado 
            From ConcursosSorteados
           ) As C
 Unpivot (
                ListaDeNumeros For NumeroSorteados In (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, 
                                                                                     Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
              ) As UP
 Where CodigoConcurso = @CodigoConcurso)
Select CodigoConcurso, Min(ListaDeNumeros) As Menor, Max(ListaDeNumeros) As Maior From CTEListaDeNumerosSorteados
Group By CodigoConcurso

-- Exemplo 4 - CTE - Identificando o Menor e Maior N�mero utilizando as fun��o Min() e Max() dentro da CTE --
;With CTEListaDeNumerosSorteadosMenorMaior (CodigoConcurso, Menor, Maior)
As
(Select CodigoConcurso, 
            Min(ListaDeNumeros) As Menor, 
            Max(ListaDeNumeros) As Maior  
 From (
            Select CodigoConcurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado 
            From ConcursosSorteados
          ) As C
 Unpivot (
                ListaDeNumeros For NumeroSorteados In (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, 
                                                                                     Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
               ) As UP
 Where CodigoConcurso = @CodigoConcurso
 Group By CodigoConcurso)
Select CodigoConcurso, Menor, Maior From CTEListaDeNumerosSorteadosMenorMaior
Go