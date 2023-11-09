-- Exemplo 1 --
DECLARE @varInt INT = 1;

WHILE (@varInt <= 150) 
 BEGIN

	IF @varInt % 2 = 0 
	 PRINT STR(@varInt) + ' é par';
	ELSE 
	 PRINT STR(@varInt) + ' é ímpar';
	
	SET @varInt = @varInt + 1;
END


-- Exemplo 2 --
Create Table Numeros
(Numero SmallInt Identity(1,1))
Go

Insert Into Numeros Default Values
Go 32687


Select IIF(Numero%2=0, -- Condição
           CONCAT('O número: ', Numero, ' é par....'), -- Resultado se a condição for verdadeira 
           Concat('O número: ', Numero, ' é impar...')) As 'Análise' -- Resultado se a condição for falsa
 from Numeros
 Where Numero <= 200