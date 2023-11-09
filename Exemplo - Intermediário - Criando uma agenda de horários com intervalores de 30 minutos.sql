-- Exemplo 1 - Utilizando CTE --
Declare @AgendamentoData Date, @AgendamentoHoraInicial Time, @AgendamentoHoraFinal Time

Set @AgendamentoData=GetDate()
Set @AgendamentoHoraInicial='08:00'
Set @AgendamentoHoraFinal='18:00'

;With AgendaDeHorarios(Data, Hora)
As
(
    Select @AgendamentoData As Data, @AgendamentoHoraInicial As Hora
    Union All
    Select Data, DateAdd(MINUTE,30, Hora) From AgendaDeHorarios
    Where Hora <= @AgendamentoHoraFinal
)
Select Data, Hora From AgendaDeHorarios
Go

-- Exemplo 2 - Utilizando Function - MultiStatement Table Value --
Create Function F_AgendaDeHorarios (@AgendamentoData Date, @AgendamentoHora TIME)
RETURNS @Agenda Table
(Codigo TinyInt Identity(1,1),
 Data Date,
 Horario Time)
AS
Begin

    Insert Into @Agenda Values(@AgendamentoData, @AgendamentoHora)
  
    While @AgendamentoHora <= '18:00'
    Begin
     Insert Into @Agenda (Data, Horario)
     Select Top 1 Data, DateAdd(MINUTE,30, Horario) From @Agenda
     Order By Codigo Desc

     Set @AgendamentoHora = DateAdd(Minute,30, @AgendamentoHora)
    End
 Return
End
Go

-- Executando a Função --
Select * From F_AgendaDeHorarios ('2019-06-25','15:00')
Go

-- Inserindo o Resultado em uma Tabela --
Select * Into AgendaDeHorarios From F_AgendaDeHorarios ('2019-06-25','15:00')
Go 

-- Criando uma View --
Create View V_ExibirAgendamentoHorarios
As
 Select * From AgendaDeHorarios

-- Executando a View --
Select * From V_ExibirAgendamentoHorarios
Go