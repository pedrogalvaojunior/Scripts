Create Database TesteSomatoriaDatas
Go

Use TesteSomatoriaDatas
Go

Select name, database_id, 
		   compatibility_level As 'N�vel de Compatibilidade',
           recovery_model As ' ID - Modelo Recupera��o', 
		   recovery_model_desc As 'Modelo de Recupera��o'
from sys.databases
Where Name = 'TesteSomatoriaDatas'
Go

-- Testando a soma de Data e Hora --
Select GetDate() + Cast('01:25' As Time)
Go

/*  Vai dar erro -- O motivo � que a partir da vers�o 2012, a Microsoft alterou a forma com que realizamos 
     c�lculos que envolvem valores de Data e Hora, pois internamente ela tenta realizar uma convers�o impl�cita,
	 o que acaba gerando erro de incompatibilidade de dados. Para garantir total precis�o e veracidade de resultado]
	 ao trabalhar com valores de Data e Hora, em opera��es que envolvem c�lculos devemos realizar a convers�o de
	 forma expl�cita, ou seja, no comando Select especificar qual tipo de dados vamos utilizar. */

-- Alterando o n�vel de compatibilidade para vers�o 2008 --
Alter Database TesteSomatoriaDatas
Set Compatibility_Level = 100
Go

-- Testando a soma de Data e Hora --
Select GetDate() + Cast('01:25' As time)
Go

-- Alterando o n�vel de compatibilidade para vers�o 2012 --
Alter Database TesteSomatoriaDatas
Set Compatibility_Level = 120
Go

-- Testando a soma de Data e Hora --
Select GetDate() + Cast('01:25' As Time)
Go

-- Contornando para vers�es mais atuais --
/* Para contornar esta limita��o vamos realizar a convers�o expl�cita dos dados, definindo o datatype
    DateTime */

-- Alterando o n�vel de compatibilidade para vers�o 2019 --
Alter Database TesteSomatoriaDatas
Set Compatibility_Level = 150
Go

-- Testando a soma de Data e Hora --
Select Cast(GetDate() + '01:25' As DateTime),
           GetDate() + Cast('01:25' As DateTime)
Go

