-- Acessando --
Use Loteria
Go

-- Implementação 1 -- Informando manualmente o número do concurso -- 
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

-- Exemplo 2 - Identificando o menor e maior número Sorteado --
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

-- Exemplo 3 - CTE - Identificando o Menor e Maior Número utilizando as função Min() e Max() fora da CTE --
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

-- Exemplo 4 - CTE - Identificando o Menor e Maior Número utilizando as função Min() e Max() dentro da CTE --
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

-- Implementação 2 - Utilizando varíavel para informar o código do concurso --
-- Acessando --
Use Loteria
Go

-- Declarando a varíavel @CodigoConcurso --
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

-- Exemplo 2 - Identificando o menor e maior número Sorteado --
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

-- Exemplo 3 - CTE - Identificando o Menor e Maior Número utilizando as função Min() e Max() fora da CTE --
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

-- Exemplo 4 - CTE - Identificando o Menor e Maior Número utilizando as função Min() e Max() dentro da CTE --
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