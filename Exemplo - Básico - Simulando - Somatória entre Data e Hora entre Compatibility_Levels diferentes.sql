Create Database TesteSomatoriaDatas
Go

Use TesteSomatoriaDatas
Go

Select name, database_id, 
		   compatibility_level As 'Nível de Compatibilidade',
           recovery_model As ' ID - Modelo Recuperação', 
		   recovery_model_desc As 'Modelo de Recuperação'
from sys.databases
Where Name = 'TesteSomatoriaDatas'
Go

-- Testando a soma de Data e Hora --
Select GetDate() + Cast('01:25' As Time)
Go

/*  Vai dar erro -- O motivo é que a partir da versão 2012, a Microsoft alterou a forma com que realizamos 
     cálculos que envolvem valores de Data e Hora, pois internamente ela tenta realizar uma conversão implícita,
	 o que acaba gerando erro de incompatibilidade de dados. Para garantir total precisão e veracidade de resultado]
	 ao trabalhar com valores de Data e Hora, em operações que envolvem cálculos devemos realizar a conversão de
	 forma explícita, ou seja, no comando Select especificar qual tipo de dados vamos utilizar. */

-- Alterando o nível de compatibilidade para versão 2008 --
Alter Database TesteSomatoriaDatas
Set Compatibility_Level = 100
Go

-- Testando a soma de Data e Hora --
Select GetDate() + Cast('01:25' As time)
Go

-- Alterando o nível de compatibilidade para versão 2012 --
Alter Database TesteSomatoriaDatas
Set Compatibility_Level = 120
Go

-- Testando a soma de Data e Hora --
Select GetDate() + Cast('01:25' As Time)
Go

-- Contornando para versões mais atuais --
/* Para contornar esta limitação vamos realizar a conversão explícita dos dados, definindo o datatype
    DateTime */

-- Alterando o nível de compatibilidade para versão 2019 --
Alter Database TesteSomatoriaDatas
Set Compatibility_Level = 150
Go

-- Testando a soma de Data e Hora --
Select Cast(GetDate() + '01:25' As DateTime),
           GetDate() + Cast('01:25' As DateTime)
Go

