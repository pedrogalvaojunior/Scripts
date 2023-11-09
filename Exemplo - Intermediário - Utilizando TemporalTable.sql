-- Criando o Banco de Dados --
Create Database DatabaseTemporalTable
Go

-- Acessando o Banco de Dados --
Use DatabaseTemporalTable
Go

-- Criando a Tabela TemporalTableTemperatura --
Create Table TemporalTableTemperatura
(Codigo Int Identity(1,1) Primary Key Clustered,
 Local Char(10) Default 'Minha Casa',
 Cidade Char(9) Default 'São Roque',
 DataAtual Date Default GetDate(),
 HoraAtual Time Default GetDate(),
 Temperatura TinyInt,
 DataHoraInicial Datetime2 (0) GENERATED ALWAYS AS ROW START,  
 DataHoraFinal Datetime2 (0) GENERATED ALWAYS AS ROW END,  
 PERIOD FOR SYSTEM_TIME (DataHoraInicial, DataHoraFinal))
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.TemporalTableTemperaturaHistorico))   
Go
 
 -- Inserindo Dados na Tabela TemporalTableTemperatura --
 Insert Into TemporalTableTemperatura (Temperatura)
 Values (25)
 Go

-- Gerando um Delay de 20 segundos --
WAITFOR DELAY '00:00:20'
Go

-- Atualizando os dados na Tabela TemporalTableTemperatura --
Update TemporalTableTemperatura
Set Temperatura = 26,
      HoraAtual = GetDate()
Go

-- Gerando um novo Delay de 40 segundos --
WAITFOR DELAY '00:00:40'
Go

-- Atualizando os dados na Tabela TemporalTableTemperatura --
Update TemporalTableTemperatura
Set Temperatura = 27,
      HoraAtual = GetDate()
Go

-- Gerando um novo Delay de 1 minuto e 20 segundos --
WAITFOR DELAY '00:01:20'
Go

-- Atualizando os dados na Tabela TemporalTableTemperatura --
Update TemporalTableTemperatura
Set Temperatura = 27,
      HoraAtual = GetDate()
Go


-- Consultando dados na Tabela TemporalTableTemperatura --
Select * From TemporalTableTemperatura
Go

-- Consultando dados Temporais, obtendo todas as manipulações realizadas --
Select * From TemporalTableTemperatura
For System_Time All
Go

-- Conhecendo outras formas de consultar dados temporais --
Select 'System_Time as Of' As 'Operação'
Select * From TemporalTableTemperatura
For System_Time as Of '2019-01-22 12:33:56'
Go

Select 'For System_Time From' As 'Operação'
Select * From TemporalTableTemperatura
For System_Time From '2019-01-22 12:33:56' To '2019-01-22 12:48:36'
Go

Select 'For System_Time Between' As 'Operação'
Select * From TemporalTableTemperatura
For System_Time Between '2019-01-22 12:48:36' And '2019-01-22 12:58:22'
Order By Temperatura Desc
Go

Select 'For System_Time Contained In' As 'Operação'
Select * From TemporalTableTemperatura
For System_Time Contained In ('2019-01-22 12:33:00' ,'2019-01-22 12:55:00')
Go

-- Excluíndo os dados cadastrados na Tabela TemporalTableTemperatura --
Delete From TemporalTableTemperatura
Go

/* O que aconteceria com os dados em nossa tabela espelho:
1 - Os dados seriam excluídos também?
2 - Os dados são mantidos?
3 - A tabela espelho será excluída?
4 - Não podemos remover dados em tabelas que utilizam versionamento de dados? */

-- Consultando dados na Tabela TemporalTableTemperaturaHistorico --
Select Local, Cidade, DataAtual, HoraAtual, Temperatura From TemporalTableTemperaturaHistorico
Go


-- Removendo o Versionamento --
ALTER TABLE TemporalTableTemperatura 
SET (SYSTEM_VERSIONING = OFF)
Go

ALTER TABLE TemporalTableTemperatura DROP PERIOD FOR SYSTEM_TIME
Go

ALTER TABLE TemporalTableTemperatura DROP COLUMN Dt_Inicio, Dt_Fim;
Go