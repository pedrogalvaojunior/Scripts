-- Criando o Banco de Dados RodizioAulas --
Create Database RodizioAulas
Go

-- Acessando o Banco de Dados RodizioAulas --
Use RodizioAulas
Go

-- Criando a Tabela Alunos --
Create Table Alunos
 (CodigoAluno TinyInt Primary Key Identity(1,1),
  NomeAluno Varchar(20) Not Null Default 'Aluno - ')
Go

-- Inserindo 10 linhas de registro l�gicos na Tabela Alunos --
Insert Into Alunos Default Values
Go 10

-- Atualizando o nome dos Alunos --
Update Alunos
Set NomeAluno = Concat(NomeAluno, CodigoAluno)
Go

-- Consultando os dados manipulados na Tabela Alunos --
Select CodigoAluno, NomeAluno From Alunos
Go

-- Alterando o Idioma do usu�rio para Portugu�s Brasil --
Set Language Portuguese
Go

-- Declarando as vari�veis utilizadas como par�metros de Entrada de Valores --
Declare @Mes TinyInt, @Ano SmallInt, @DataInicial Date

-- Atribuindo os valores para as respectivas vari�veis --
Select @DataInicial = '2021-05-01', @Mes = Month(@DataInicial), @Ano=Year(@DataInicial)

-- Definindo a CTE Recursiva CTECalendarioMensal -- Utilizada para gerar o calend�rio de datas de acordo com o m�s e ano --
;With CTECalendarioMensal (DataCorrente) 
As
(
  Select DateAdd(Year, @Ano - 1900, DateAdd(Month, @Mes - 1, 0))
  Union All
  Select DataCorrente+1 From CTECalendarioMensal
  Where Month(DataCorrente + 1) = @Mes
)

-- Definindo a CTEDiasDaSemana -- Utilizada para definir de acordo com o dia da semana os devidos dias --
,CTEDiasDaSemana ([Segunda],[Terca],[Quarta],[Quinta],[Sexta], NomeDoMes)
As
(
Select [2] As 'Segunda', 
           [3] As 'Terca', [4] As 'Quarta',
           [5] As 'Quinta',[6] As 'Sexta',
		   NomeDoMes
From (

-- Identificando o Dia, Dia da Semana, N�mero da Semana no Mes e o Nome do M�s --
          Select Day(DataCorrente) As Dia, 
		             DatePart(WeekDay, DataCorrente) As DiaDaSemana, 
					 DatePart(Week, DataCorrente) As NumeroDaSemanaNoMes,
					 DateName(Month,@DataInicial) As NomeDoMes
          From CTECalendarioMensal
         ) As Datas
Pivot (Max(Dia) For DiaDaSemana In ([2], [3], [4], [5], [6])) As P) -- Estabelecendo o Pivot, transformando os dias da semana em colunas --

-- Definindo a CTESemana1 -- Utilizada para identificar os dias da semana Segundas, Quartas e Sextas-feiras --
,CTESemana1
As
(
Select  C.NomeAluno, 
            Replace(IsNull(CD.Segunda,''),0,'') As 'Segunda-Feira',
			'' As 'Ter�a-Feira',
			Replace(IsNull(CD.Quarta,''),0,'')  As 'Quarta-Feira', 
            '' As 'Quinta-Feira',
			 Replace(IsNull(CD.Sexta,''),0,'')  As 'Sexta-Feira'
From CTEDiasDaSemana CD Outer Apply (Select NomeAluno From Alunos Where CodigoAluno % 2 = 1) As C (NomeAluno)  -- Definindo os alunos com n�meros impares
Where Segunda <=7)

-- Definindo a CTESemana2 -- Utilizada para identificar os dias da semana Ter�as e Quintas-feiras --
,CTESemana2
As
(
Select  C.NomeAluno, 
            '' As 'Segunda-Feira',
			Replace(IsNull(CD.Terca,''),0,'') As 'Ter�a-Feira',
            '' As 'Quarta-Feira',
			Replace(IsNull(CD.Quinta,''),0,'')  As 'Quinta-Feira', 
            '' As 'Sexta-Feira'
From CTEDiasDaSemana CD Outer Apply (Select NomeAluno From Alunos Where CodigoAluno % 2 = 0) As C (NomeAluno)  -- Definindo os alunos com n�meros pares
Where Segunda >=8 And Segunda <=14 )

-- Definindo a CTESemana3 -- Utilizada para identificar os dias da semana Segundas, Quartas e Sextas-feiras --
,CTESemana3
As
(
Select  C.NomeAluno, 
            Replace(IsNull(CD.Segunda,''),0,'') As 'Segunda-Feira',
			'' As 'Ter�a-Feira',
			Replace(IsNull(CD.Quarta,''),0,'')  As 'Quarta-Feira', 
            '' As 'Quinta-Feira',
			 Replace(IsNull(CD.Sexta,''),0,'')  As 'Sexta-Feira'
From CTEDiasDaSemana CD Outer Apply (Select NomeAluno From Alunos Where CodigoAluno % 2 = 1) As C (NomeAluno)  -- Definindo os alunos com n�meros impares
Where Segunda >=15 And Segunda <=21) 

-- Definindo a CTESemana4 -- Utilizada para identificar os dias da semana Ter�as e Quintas-feiras --
,CTESemana4
As
(
Select  C.NomeAluno, 
            '' As 'Segunda-Feira',
			Replace(IsNull(CD.Terca,''),0,'') As 'Ter�a-Feira',
            '' As 'Quarta-Feira',
			Replace(IsNull(CD.Quinta,''),0,'')  As 'Quinta-Feira', 
            '' As 'Sexta-Feira'
From CTEDiasDaSemana CD Outer Apply (Select NomeAluno From Alunos Where CodigoAluno % 2 = 0) As C (NomeAluno) -- Definindo os alunos com n�meros pares
Where Segunda >=22 And Segunda <=28)

-- Definindo a CTESemana5 -- Utilizada para identificar os dias da semana Segundas, Quartas e Sextas-feiras --
,CTESemana5
As
(
Select  C.NomeAluno, 
            Replace(IsNull(CD.Segunda,''),0,'') As 'Segunda-Feira',
			'' As 'Ter�a-Feira',
			Replace(IsNull(CD.Quarta,''),0,'')  As 'Quarta-Feira', 
            '' As 'Quinta-Feira',
			 Replace(IsNull(CD.Sexta,''),0,'')  As 'Sexta-Feira'
From CTEDiasDaSemana CD Outer Apply (Select NomeAluno From Alunos Where CodigoAluno % 2 = 1) As C (NomeAluno)  -- Definindo os alunos com n�meros impares
Where Segunda >=29 And Segunda <=31)

/* Elaborando a identifica��o do Rod�zio de Alunos de Acordo com as Semanas, sendo Segundas, Quartas e Sextas para Semanas 1, 3 e 5
e Ter�as e Quintas para Semanas 2 e 4 */
Select  Distinct Upper(OA.NomeDoM�s) As 'M�s','     1�' As [Semana], 
                         Concat('      Dia ',[Segunda-Feira]) As 'Segunda-Feira',
						 '' As 'Ter�a-Feira',
                         Concat('      Dia ',[Quarta-Feira]) As 'Quarta-Feira',
						 '' As 'Quinta-Feira',
						 Concat('     Dia ',[Sexta-Feira]) As 'Sexta-Feira'
From CTESemana1 Outer Apply (Select NomeDoMes From CTEDiasDaSemana) As OA (NomeDoM�s)

Union All
Select '', NomeAluno As 'Nome Aluno', 
           '       X' As 'Segunda-Feira', 
		   '' As 'Ter�a-Feira', 
           '       X' As'Quarta-Feira',
		   '' As 'Quinta-Feira',
		   '       X' As 'Sexta-Feira'
From CTESemana1 As C

Union All
Select '','','','','','',''
Union All
Select 'M�s' As 'M�s','Semana','Segunda-Feira','Ter�a-Feira','Quarta-Feira','Quinta-Feira','Sexta-Feira'

Union All
Select Distinct Upper(OA.NomeDoM�s) As 'M�s', '     2�' As Semana, 
                         '' As 'Segunda-Feira',
						 Concat('     Dia ',[Ter�a-Feira]) As 'Ter�a-Feira',
                         '' As 'Quarta-Feira',
						 Concat('     Dia ',[Quinta-Feira]) As 'Ter�a-Feira',
						'' As 'Sexta-Feira'
From CTESemana2 Outer Apply (Select NomeDoMes From CTEDiasDaSemana) As OA (NomeDoM�s)
 
Union All
Select '' As 'M�s', NomeAluno As 'Nome Aluno', 
           '' As 'Segunda-Feira', 
		   '       X' As 'Ter�a-Feira', 
           '' As'Quarta-Feira', 
		   '        X' As 'Quinta-Feira',
		   '' As 'Sexta-Feira'
From CTESemana2 As C

Union All
Select '','','','','','',''
Union All
Select 'M�s' As 'M�s','Semana','Segunda-Feira','Ter�a-Feira','Quarta-Feira','Quinta-Feira','Sexta-Feira'

Union All
Select Distinct Upper(OA.NomeDoM�s) As 'M�s', '     3�' As Semana, 
           Concat('      Dia ',[Segunda-Feira]) As 'Segunda-Feira',
		   '' As 'Ter�a-Feira',
           Concat('      Dia ',[Quarta-Feira]) As 'Quarta-Feira',
		   '' As 'Quinta-Feira',
		   Concat('     Dia ',[Sexta-Feira]) As 'Sexta-Feira'
From CTESemana3 Outer Apply (Select NomeDoMes From CTEDiasDaSemana) As OA (NomeDoM�s)
 
Union All
Select '', NomeAluno As 'Nome Aluno', 
           '       X' As 'Segunda-Feira', 
		   '' As 'Ter�a-Feira', 
           '       X' As'Quarta-Feira', 
		   '' As 'Quinta-Feira',
		   '       X' As 'Sexta-Feira'
From CTESemana3 As C

Union All
Select '','','','','','',''
Union All
Select 'M�s' As 'M�s','Semana','Segunda-Feira','Ter�a-Feira','Quarta-Feira','Quinta-Feira','Sexta-Feira'

Union All
Select Distinct Upper(OA.NomeDoM�s) As 'M�s', '     4�' As Semana, 
                        '' As 'Segunda-Feira',
						Concat('     Dia ',[Ter�a-Feira]) As 'Ter�a-Feira',
                        '' As 'Quarta-Feira',
						Concat('     Dia ',[Quinta-Feira]) As 'Ter�a-Feira',
						'' As 'Sexta-Feira'
From CTESemana4 Outer Apply (Select NomeDoMes From CTEDiasDaSemana) As OA (NomeDoM�s)
 
Union All
Select '', NomeAluno As 'Nome Aluno', 
           '' As 'Segunda-Feira', 
		   '       X' As 'Ter�a-Feira', 
		   '' As'Quarta-Feira', 
		   '        X' As 'Quinta-Feira',
		   '' As 'Sexta-Feira'
From CTESemana4 As C

Union All
Select '','','','','','',''
Union All
Select 'M�s' As 'M�s','Semana','Segunda-Feira','Ter�a-Feira','Quarta-Feira','Quinta-Feira','Sexta-Feira'

Union All
Select Distinct Upper(OA.NomeDoMes) As 'M�s', '     5�' As Semana, 
                        Concat('      Dia ',[Segunda-Feira]) As 'Segunda-Feira',
                        '' As 'Ter�a-Feira',
                        Concat('      Dia ',[Quarta-Feira]) As 'Quarta-Feira',
						'' As 'Quinta-Feira',
						Concat('     Dia ',[Sexta-Feira]) As 'Sexta-Feira'
From CTESemana5 Outer Apply (Select NomeDoMes From CTEDiasDaSemana) As OA (NomeDoMes)
 
Union All
Select '', NomeAluno As 'Nome Aluno', 
          '       X' As 'Segunda-Feira', '' As 'Ter�a-Feira', 
          '       X' As'Quarta-Feira', '' As 'Quinta-Feira',
		  '       X' As 'Sexta-Feira'
From CTESemana5 As C
Go