-- Acessando o Banco de dados Loteria --
Use Loteria
Go

-- Criando a Tabela de Concursos --
Create Table Concursos
(Concurso Int Primary Key Identity(1,1),
  N1 TinyInt,
  N2 TinyInt,
  N3 TinyInt,
  N4 TinyInt,
  N5 TinyInt)
Go

-- Inserindo os números para cada concurso --
Insert Into Concursos (N1, N2, N3, N4, N5)
Values (2, 7, 8, 10, 47),
			(4, 11, 12, 13, 32),
			(1, 3, 13,	16, 43),
			(3, 4, 14,	43, 50),
			(12, 15, 33, 44, 50),
			(3, 5, 8, 10, 44),
			(12, 13, 29, 44, 50),
			(4, 8, 14, 16, 50),
			(3, 8, 12, 29, 43)
Go

-- Montando as CTEs para contar os números para cada coluna --

-- Coluna N1 --
;With CTEContadorN1
As
(Select N1, Count(N1) As ContadorN1 From Concursos Group By N1),

-- Coluna N2 --
CTEContadorN2
As
(Select N2, Count(N2) As ContadorN2 From Concursos Group By N2),

-- Coluna N3 --
CTEContadorN3
As
(Select N3, Count(N3) As ContadorN3 From Concursos Group By N3),

-- Coluna N4 --
CTEContadorN4
As
(Select N4, Count(N4) As ContadorN4 From Concursos Group By N4),

-- Coluna N5 --
CTEContadorN5
As
(Select N5, Count(N5) As ContadorN5 From Concursos Group By N5)


-- Identificando o número mais sorteado para cada coluna e a quantidade sorteada independente do concurso --
Select Numero1.N1, Numero1.QuantidadeSorteada, 
           Numero2.N2, Numero2.QuantidadeSorteada,
           Numero3.N3, Numero3.QuantidadeSorteada,
           Numero4.N4, Numero4.QuantidadeSorteada,
           Numero5.N5, Numero5.QuantidadeSorteada
From ( -- Maior número de vezes sorteado o N1 --
			Select Top 1 N1, Max(ContadorN1) As 'QuantidadeSorteada' From CTEContadorN1
			Group By N1
			Order By QuantidadeSorteada Desc) As Numero1,
		 ( -- Maior número de vezes sorteado o N2 --
		  Select N2, QuantidadeSorteada 
		  From (
					Select Top 1 N2, Max(ContadorN2) As 'QuantidadeSorteada' From CTEContadorN2
					Group By N2
					Order By QuantidadeSorteada Desc) As B) As Numero2,
        ( -- Maior número de vezes sorteado o N3 --
		  Select N3, QuantidadeSorteada 
		  From (
					Select Top 1 N3, Max(ContadorN3) As 'QuantidadeSorteada' From CTEContadorN3
					Group By N3
					Order By QuantidadeSorteada Desc) As C) As Numero3,
        ( -- Maior número de vezes sorteado o N5 --
		  Select N4, QuantidadeSorteada 
		  From (
					Select Top 1 N4, Max(ContadorN4) As 'QuantidadeSorteada' From CTEContadorN4
					Group By N4
					Order By QuantidadeSorteada Desc) As D) As Numero4,
        ( -- Maior número de vezes sorteado o N6 --
		  Select N5, QuantidadeSorteada
		  From (
					Select Top 1 N5, Max(ContadorN5) As 'QuantidadeSorteada' From CTEContadorN5
					Group By N5
					Order By QuantidadeSorteada Desc) As E) As Numero5
Go
