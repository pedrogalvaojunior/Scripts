-- Criando a tabela CalendarioMensal --
Create Table CalendarioMensal
 (Contador TinyInt Identity(1,1) , 
  Semana SmallInt,
  Segunda TinyInt Null, 
  Terca TinyInt Null,  
  Quarta TinyInt Null, 
  Quinta TinyInt Null, 
  Sexta TinyInt Null, 
  Sabado TinyInt Null, 
  Domingo TinyInt Null)
Go

-- Definindo o dia inicial da semana --
Set DateFirst 7 
Go

-- Desativando a contagem de linhas após manipulação de dados
Set NoCount On
Go

-- Declarando e definindo as variáveis --
Declare @InicioDeMes Datetime, 
             @FinalDeMes  Datetime, 
			 @Contador  TinyInt

-- Atribuindo os valores para as variáveis --
Set @InicioDeMes = '2018-01-01'
Set @FinalDeMes = '2018-01-31'
Set @Contador = 1

-- Loop para inserção e atualização dos dias referentes ao mês informando --
While @InicioDeMes <= @FinalDeMes
Begin 
 
  -- Inserindo os valores na Tabela Calendário
  Insert Into CalendarioMensal Default Values
  
  While 1<=@Contador
     Begin  
       Update CalendarioMensal 
       Set Segunda = Case When DatePart(WeekDay,@InicioDeMes) = 2 Then   DatePart(Day,@InicioDeMes) Else Segunda End,
             Terca   = Case When DatePart(WeekDay,@InicioDeMes) = 3 Then   DatePart(Day,@InicioDeMes) Else Terca End,
             Quarta  = Case When DatePart(WeekDay,@InicioDeMes) = 4 Then   DatePart(Day,@InicioDeMes) Else Quarta End,
             Quinta  = Case When DatePart(WeekDay,@InicioDeMes) = 5 Then   DatePart(Day,@InicioDeMes) Else Quinta End,
             Sexta   = Case When DatePart(WeekDay,@InicioDeMes) = 6 Then   DatePart(Day,@InicioDeMes) Else Sexta End,
             Sabado  = Case When DatePart(WeekDay,@InicioDeMes) = 7 Then   DatePart(Day,@InicioDeMes) Else Sabado End,
             Domingo = Case When DatePart(WeekDay,@InicioDeMes) = 1 Then   DatePart(Day,@InicioDeMes) Else Domingo End,
			 Semana = IsNull(DatePart(Week, Segunda),Year(GetDate()-1))
       Where Contador = @Contador 
	   And DatePart(Month,@InicioDeMes) =  DatePart(Month,@FinalDeMes)
   
      If DatePart(WeekDay,@InicioDeMes) = 1 
       Break
        Set @InicioDeMes = Dateadd(Day,1,@InicioDeMes) 
      End 
      
     Set @InicioDeMes = Dateadd(Day,1,@InicioDeMes) 
	 Set @Contador = @Contador + 1
End
Go

-- Consultando o Calendário --
Select Semana As 'Numero da Semana',
           Segunda As 'Segunda-Feira',
           Terca As 'Terça-Feira',
		   Quarta As 'Quarta-Feira', 
		   Quinta As 'Quinta-Feira',
		   Sexta As 'Sexta-Feira',
		   Sabado As 'Sábado',
		   Domingo  As 'Domingo'
From CalendarioMensal
Go