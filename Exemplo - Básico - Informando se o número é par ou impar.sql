-- Exemplo 1 --
DECLARE @varInt INT = 1;

WHILE (@varInt <= 150) 
 BEGIN

	IF @varInt % 2 = 0 
	 PRINT STR(@varInt) + ' � par';
	ELSE 
	 PRINT STR(@varInt) + ' � �mpar';
	
	SET @varInt = @varInt + 1;
END


-- Exemplo 2 --
Create Table Numeros
(Numero SmallInt Identity(1,1))
Go

Insert Into Numeros Default Values
Go 32687


Select IIF(Numero%2=0, -- Condi��o
           CONCAT('O n�mero: ', Numero, ' � par....'), -- Resultado se a condi��o for verdadeira 
           Concat('O n�mero: ', Numero, ' � impar...')) As 'An�lise' -- Resultado se a condi��o for falsa
 from Numeros
 Where Numero <= 200