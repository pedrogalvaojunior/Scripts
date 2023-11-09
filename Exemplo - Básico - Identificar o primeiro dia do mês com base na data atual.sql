-- Exemplo 1 --
declare @Hoje date, @In�cioM�s date;
set @Hoje= cast(Current_timestamp as date);
set @In�cioM�s= DateAdd(day, -(day(@Hoje) -1), @Hoje);

-- Exemplo 2 -- 
DECLARE @DataFim  DATETIME  ='2017-03-08';

DECLARE @DataInicio   DATETIME = DATEFROMPARTS(YEAR(@DataFim),MONTH(@DataFim),1);

SELECT @DataInicio,@DataFim

-- Exemplo 3 --
Set DateFirst 1

Declare @DataDeNascimento Date, @PrimeiroDiaDoMes Date

Set @DataDeNascimento = '1980-04-28'
Set @PrimeiroDiaDoMes = DateFromParts(Year(@DataDeNascimento),Month(@DataDeNascimento),1)

Select Concat('O m�s come�a no dia:', DateName(day,@PrimeiroDiaDoMes), '� que representa o in�cio do m�s de: ', 
                        DateName(Month, @DataDeNascimento), 
                       ' sendo um(a): ', DateName(weekday, @PrimeiroDiaDoMes), 
		               ' no decorrer do ano de: ', Year(@DataDeNascimento), 
					   ', a data representa o dia de n�mero:', DatePart(DAYOFYEAR, @PrimeiroDiaDoMes)) As 'Sobre o m�s de nascimento do nosso goleiro....',
		   Concat('O nosso goleiro nasceu no dia: ', @DataDeNascimento, ' sendo esta um(a): ',
		     Case DatePart(WEEKDAY, @DataDeNascimento)
		       When 1 Then 'Domingo'
			   When 2 Then 'Segunda-feira'
			   When 3 Then 'Ter�a-feira'
			   When 4 Then 'Quarta-feira'
			   When 5 Then 'Quinta-feira'
			   When 6 Then 'Sexta-feira'
			   When 7 Then 'S�bado'
		     End,
			 ' que representa o dia de n�mero:', DatePart(DAYOFYEAR, @DataDeNascimento), 
			 ' ao longo do ano, ele escolheu a camisa de n�mero: ', Datepart(WW, @DataDeNascimento),
			 ' para fazer refer�ncia ao n�mero da semana no decorrer do ano em que ele nasceu...' ) As 'N�mero da camisa..'
Go