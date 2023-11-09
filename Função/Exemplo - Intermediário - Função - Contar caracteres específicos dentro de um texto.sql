-- Exemplo 1 --
Create FUNCTION [dbo].[CountChar] (@Palavra Varchar(100), @String Varchar(Max))
RETURNS int AS
Begin
 Declare @Count int, @CountTexto int
 
 Set @CountTexto = 0
 Set @Count = 0

 While @Count <= Len(@String)
  Begin
   Set @CountTexto = Case 
                                    When Substring(@String, @Count, Len(@Palavra)) = @Palavra Then @CountTexto + 1
									 Else @CountTexto
	  						       End

   Set @Count = @Count + 1  
 End

 Return @CountTexto
End
 
-- Executando --
 Select dbo.CountChar('/','Pedro / Galvão / Junior')
 Go

-- Exemplo 2 --
/*Creio que a idéia inicial de todos seria fazer um loop na string, correndo por todos os caracteres somando a quantidade de vezes em que o
caracter aparece na string. Algo mais ou menos assim: */

DECLARE @Str VarChar(200), @Caracter_A_Procurar VarChar(200), @i Int, @Qtde_Caracter Int;

SET @Str = ‘Um teste para validar quantos caracteres existem nesta String’

SET @Caracter_A_Procurar = ‘a’

SET @i = 0

SET @Qtde_Caracter = 0

WHILE @i <= LEN(@Str)

BEGIN

    IF SUBSTRING(@Str, @i, 1) = @Caracter_A_Procurar

        SET @Qtde_Caracter = @Qtde_Caracter + 1

    SET @i = @i + 1

END

SELECT @Qtde_Caracter

-- Ok, o código acima funciona, mas pensando bem, existe outra maneira bem mais eficiente de fazer esta validação. Que tal assim:

DECLARE @Str VarChar(200), @Caracter_A_Procurar VarChar(200)

SET @Str = ‘Um teste para validar quantos caracteres existem nesta String’

SET @Caracter_A_Procurar = ‘a’

SELECT LEN(@Str) – LEN(REPLACE(@Str, @Caracter_A_Procurar, ”))

O código acima pega a string e faz um replace do caracter “a” por nada, e depois verifica a quantidade de caracteres da string sem o “a” e
subtrai pela quantidade de caracteres original. O resultado será exatamente a quantidade de vezes em que “a” aparece na string.