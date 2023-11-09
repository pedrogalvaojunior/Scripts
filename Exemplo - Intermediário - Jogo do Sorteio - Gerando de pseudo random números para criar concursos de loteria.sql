-- Criando o Banco de Dados Loteria--
Create Database Loteria
Go

-- Acessando --
Use Loteria
Go

-- Criando a Tabela ConcursosSorteados --
Create Table ConcursosSorteados
 (CodigoConcurso SmallInt Primary Key Identity(1,1),
   DataConcurso DateTime Default GetDate(),
   Numero1Sorteado TinyInt,
   Numero2Sorteado TinyInt,
   Numero3Sorteado TinyInt,
   Numero4Sorteado TinyInt,
   Numero5Sorteado TinyInt,
   Numero6Sorteado TinyInt)
Go

-- Exemplo 1 - Utilizando While para Sortear os números --
-- Limpando a Tabela ConcursosSorteados --
If (Select Count(*) From ConcursosSorteados) >= 1
 Truncate Table ConcursosSorteados
Go

-- Iniciando a marcação de tempo --
Declare @HoraInicio DateTime
Set @HoraInicio = GetDate()

-- Declarando a variável de controle de Concursos --
Declare @QuantidadeDeConcursosSorteados SmallInt, -- Quantidade Máximo de Sorteios --
              @Numero1 TinyInt=1

Set @QuantidadeDeConcursosSorteados = 100

-- Loop para Gerar os Números para cada sorteios com faixas específicas de valores --
While @QuantidadeDeConcursosSorteados >= 1
Begin
 
 -- Sorteando os Pseudo Random Números --
 Set @Numero1 = 10*Rand() -- Números de 0 até 10 --

-- Inserindo os números sorteados para cada concurso --
  Insert Into ConcursosSorteados (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
  Values (IIf(@Numero1=0, 60, @Numero1), 10 + (10)*RAND() , 20 + (10)*RAND(), 30 + (10)*RAND(), 40 + (10)*RAND(), 50 + (10)*RAND())

 Set @QuantidadeDeConcursosSorteados -=1 
End

-- Finalizando a marcação de tempo --
Select DateDiff(MILLISECOND,@HoraInicio, GetDate()) As 'Milésimos'
Go

-- Apresentando os concursos sorteados e seus respectivos números --
Select CodigoConcurso As Concurso, Convert(Char(19),DataConcurso,100) As Data, 
           Numero1Sorteado, Numero2Sorteado,
		   Numero3Sorteado, Numero4Sorteado,
		   Numero5Sorteado, Numero6Sorteado
From ConcursosSorteados
Go

-- Exemplo 2 - Utilizando While + Multiplas CTEs para Sortear os números --
-- Limpando a Tabela ConcursosSorteados --
If (Select Count(*) From ConcursosSorteados) >= 1
 Truncate Table ConcursosSorteados
Go

 -- Iniciando a marcação de tempo --
Declare @HoraInicio DateTime
Set @HoraInicio = GetDate()

-- Declarando a variável de controle de Concusos --
Declare @QuantidadeDeConcursosSorteados SmallInt -- Quantidade Máximo de Sorteios --
Set @QuantidadeDeConcursosSorteados = 200

While @QuantidadeDeConcursosSorteados >=1
Begin

-- CTE para realizar a geração dos Pseudo Random Números para cada sorteios com faixas específicas de valores -- 
;With CTESortearNumeros (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
As
(
    Select 10*Rand() As Numero1Sorteado,
               10 + (10)*RAND() As Numero2Sorteado,
               20 + (10)*RAND() As Numero3Sorteado,
               30 + (10)*RAND() As Numero4Sorteado,
               40 + (10)*RAND() As Numero5Sorteado,
               50 + (10)*RAND() As Numero6Sorteado           
)
,CTENumero1Sorteado (Numero1Sorteado)
As
(Select IIf(Numero1Sorteado=0, 60, Numero1Sorteado) As Numero1Sorteado From CTESortearNumeros)

Insert Into ConcursosSorteados (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
Select CN1.Numero1Sorteado, C.Numero2Sorteado, C.Numero3Sorteado, C.Numero4Sorteado, C.Numero5Sorteado, C.Numero6Sorteado
From CTESortearNumeros C, CTENumero1Sorteado CN1

Set @QuantidadeDeConcursosSorteados -=1
End

-- Finalizando a marcação de tempo --
Select DateDiff(MILLISECOND,@HoraInicio, GetDate()) As 'Milésimos'
Go

-- Apresentando os concursos sorteados e seus respectivos números --
Select CodigoConcurso As Concurso, Convert(Char(19),DataConcurso,100) As Data, 
           Numero1Sorteado, Numero2Sorteado,
		   Numero3Sorteado, Numero4Sorteado,
		   Numero5Sorteado, Numero6Sorteado
From ConcursosSorteados
Go

-- Exemplo 3 - Utilizando While + CTE para Sortear os Números através de Select... Values()... --
-- Limpando a Tabela ConcursosSorteados --
If (Select Count(*) From ConcursosSorteados) >= 1
 Truncate Table ConcursosSorteados
Go

 -- Iniciando a marcação de tempo --
Declare @HoraInicio DateTime
Set @HoraInicio = GetDate()

-- Declarando a variável de controle de Concusos --
Declare @QuantidadeDeConcursosSorteados SmallInt -- Quantidade Máximo de Sorteios --
Set @QuantidadeDeConcursosSorteados = 30000

While @QuantidadeDeConcursosSorteados >=1
Begin

-- CTE para realizar a geração dos Pseudo Random Números para cada sorteios com faixas aleatórias de valores -- 
;With CTESortearNumeros (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
As
(Select IIf(Convert(TinyInt,Numero1Sorteado)=0, Rand()*61, Numero1Sorteado),
            IIf(Convert(TinyInt,Numero2Sorteado)=0, Rand()*61, Numero2Sorteado),
            IIf(Convert(TinyInt,Numero3Sorteado)=0, Rand()*61, Numero3Sorteado),
            IIf(Convert(TinyInt,Numero4Sorteado)=0, Rand()*61, Numero4Sorteado),
            IIf(Convert(TinyInt,Numero5Sorteado)=0, Rand()*61, Numero5Sorteado),
            IIf(Convert(TinyInt,Numero6Sorteado)=0, Rand()*61, Numero6Sorteado)
 From (Values (Rand()*61, Rand()*61, Rand()*61, Rand()*61, Rand()*61, Rand()*61)
          ) As Numeros(Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado))

Insert Into ConcursosSorteados (Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado)
Select Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado 
From CTESortearNumeros

Set @QuantidadeDeConcursosSorteados -=1
End

-- Finalizando a marcação de tempo --
Select DateDiff(MILLISECOND,@HoraInicio, GetDate()) As 'Milésimos'
Go

-- Apresentando os concursos sorteados e seus respectivos números --
Select CodigoConcurso As Concurso, Convert(Char(19),DataConcurso,100) As Data, 
           Numero1Sorteado, Numero2Sorteado,
		   Numero3Sorteado, Numero4Sorteado,
		   Numero5Sorteado, Numero6Sorteado
From ConcursosSorteados
Go

-- Validação dos Dados Duplicados --
Select CodigoConcurso As Concurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado
From ConcursosSorteados 
Where Numero1Sorteado= Numero2Sorteado
Or Numero1Sorteado= Numero3Sorteado
Or Numero1Sorteado= Numero4Sorteado
Or Numero1Sorteado= Numero5Sorteado
Or Numero1Sorteado= Numero6Sorteado
Go

Select CodigoConcurso As Concurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado
From ConcursosSorteados 
Where Numero2Sorteado= Numero1Sorteado
Or Numero2Sorteado= Numero3Sorteado
Or Numero2Sorteado= Numero4Sorteado
Or Numero2Sorteado= Numero5Sorteado
Or Numero2Sorteado= Numero6Sorteado
Go

Select CodigoConcurso As Concurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado
From ConcursosSorteados 
Where Numero3Sorteado= Numero1Sorteado
Or Numero3Sorteado= Numero2Sorteado
Or Numero3Sorteado= Numero4Sorteado
Or Numero3Sorteado= Numero5Sorteado
Or Numero3Sorteado= Numero6Sorteado
Go

Select CodigoConcurso As Concurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado
From ConcursosSorteados 
Where Numero4Sorteado= Numero1Sorteado
Or Numero4Sorteado= Numero2Sorteado
Or Numero4Sorteado= Numero3Sorteado
Or Numero4Sorteado= Numero5Sorteado
Or Numero4Sorteado= Numero6Sorteado
Go

Select CodigoConcurso As Concurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado
From ConcursosSorteados 
Where Numero5Sorteado= Numero1Sorteado
Or Numero5Sorteado= Numero2Sorteado
Or Numero5Sorteado= Numero3Sorteado
Or Numero5Sorteado= Numero4Sorteado
Or Numero5Sorteado= Numero6Sorteado
Go

Select CodigoConcurso As Concurso, Numero1Sorteado, Numero2Sorteado, Numero3Sorteado, Numero4Sorteado, Numero5Sorteado, Numero6Sorteado
From ConcursosSorteados 
Where Numero6Sorteado= Numero1Sorteado
Or Numero6Sorteado= Numero2Sorteado
Or Numero6Sorteado= Numero3Sorteado
Or Numero6Sorteado= Numero4Sorteado
Or Numero6Sorteado= Numero5Sorteado
Go

-- Tratamento de Números Sorteados iguais no mesmo concurso --
-- Atualizando a coluna Numero1Sorteado --
Declare @NumerosDeTratamentos TinyInt = 4

While @NumerosDeTratamentos >= 1
Begin
If Exists (Select CodigoConcurso From ConcursosSorteados Where Numero1Sorteado = Numero2Sorteado
                                                                                                Or Numero1Sorteado = Numero3Sorteado
																								Or Numero1Sorteado = Numero4Sorteado
																								Or Numero1Sorteado = Numero5Sorteado
																								Or Numero1Sorteado = Numero6Sorteado)
Begin
 Update ConcursosSorteados
 Set Numero1Sorteado = 60*Rand()
 Where CodigoConcurso In (Select CodigoConcurso From ConcursosSorteados Where Numero1Sorteado = Numero2Sorteado
                                                                                                                              Or Numero1Sorteado = Numero3Sorteado
																															  Or Numero1Sorteado = Numero4Sorteado
																															  Or Numero1Sorteado = Numero5Sorteado
																															  Or Numero1Sorteado = Numero6Sorteado)
End

-- Atualizando a coluna Numero2Sorteado --
If Exists (Select CodigoConcurso From ConcursosSorteados Where Numero2Sorteado = Numero1Sorteado
                                                                                                Or Numero2Sorteado = Numero3Sorteado
																								Or Numero2Sorteado = Numero4Sorteado
																								Or Numero2Sorteado = Numero5Sorteado
																								Or Numero2Sorteado = Numero6Sorteado)
Begin
 Update ConcursosSorteados
 Set Numero2Sorteado = 60*Rand()
 Where CodigoConcurso In (Select CodigoConcurso From ConcursosSorteados Where Numero2Sorteado = Numero1Sorteado
                                                                                                                              Or Numero2Sorteado = Numero3Sorteado
																															  Or Numero2Sorteado = Numero4Sorteado
																															  Or Numero2Sorteado = Numero5Sorteado
																															  Or Numero2Sorteado = Numero6Sorteado)
End

-- Atualizando a coluna Numero3Sorteado --
If Exists (Select CodigoConcurso From ConcursosSorteados Where Numero3Sorteado = Numero1Sorteado
                                                                                                Or Numero3Sorteado = Numero2Sorteado
																								Or Numero3Sorteado = Numero4Sorteado
																								Or Numero3Sorteado = Numero5Sorteado
																								Or Numero3Sorteado = Numero6Sorteado)
Begin
 Update ConcursosSorteados
 Set Numero3Sorteado = 60*Rand()
 Where CodigoConcurso In (Select CodigoConcurso From ConcursosSorteados Where Numero3Sorteado = Numero1Sorteado
                                                                                                                              Or Numero3Sorteado = Numero2Sorteado
																															  Or Numero3Sorteado = Numero4Sorteado
																															  Or Numero3Sorteado = Numero5Sorteado
																															  Or Numero3Sorteado = Numero6Sorteado)
End

-- Atualizando a coluna Numero4Sorteado --
IF Exists (Select CodigoConcurso From ConcursosSorteados Where Numero4Sorteado = Numero1Sorteado
                                                                                                Or Numero4Sorteado = Numero2Sorteado
																								Or Numero4Sorteado = Numero3Sorteado
																								Or Numero4Sorteado = Numero5Sorteado
																								Or Numero4Sorteado = Numero6Sorteado)
Begin
 Update ConcursosSorteados
 Set Numero4Sorteado = 60*Rand()
 Where CodigoConcurso In (Select CodigoConcurso From ConcursosSorteados Where Numero4Sorteado = Numero1Sorteado
                                                                                                                              Or Numero4Sorteado = Numero2Sorteado
																															  Or Numero4Sorteado = Numero3Sorteado
																															  Or Numero4Sorteado = Numero5Sorteado
																															  Or Numero4Sorteado = Numero6Sorteado)
End

-- Atualizando a coluna Numero5Sorteado --
IF Exists (Select CodigoConcurso From ConcursosSorteados Where Numero5Sorteado = Numero1Sorteado
                                                                                                Or Numero5Sorteado = Numero2Sorteado
																								Or Numero5Sorteado = Numero3Sorteado
																								Or Numero5Sorteado = Numero4Sorteado
																								Or Numero5Sorteado = Numero6Sorteado)
Begin
 Update ConcursosSorteados
 Set Numero5Sorteado = 60*Rand()
 Where CodigoConcurso In (Select CodigoConcurso From ConcursosSorteados Where Numero5Sorteado = Numero1Sorteado
                                                                                                                              Or Numero5Sorteado = Numero2Sorteado
																															  Or Numero5Sorteado = Numero3Sorteado
																															  Or Numero5Sorteado = Numero4Sorteado
																															  Or Numero5Sorteado = Numero6Sorteado)
End

-- Atualizando a coluna Numero6Sorteado --
IF Exists (Select CodigoConcurso From ConcursosSorteados Where Numero6Sorteado = Numero1Sorteado
                                                                                                Or Numero6Sorteado = Numero2Sorteado
																								Or Numero6Sorteado = Numero3Sorteado
																								Or Numero6Sorteado = Numero4Sorteado
																								Or Numero6Sorteado = Numero5Sorteado)
Begin
 Update ConcursosSorteados
 Set Numero6Sorteado = 60*Rand()
 Where CodigoConcurso In (Select CodigoConcurso From ConcursosSorteados Where Numero6Sorteado = Numero1Sorteado
                                                                                                                              Or Numero6Sorteado = Numero2Sorteado
																															  Or Numero6Sorteado = Numero3Sorteado
																															  Or Numero6Sorteado = Numero4Sorteado
																															  Or Numero6Sorteado = Numero5Sorteado)
End

Set @NumerosDeTratamentos -=1
End
Go