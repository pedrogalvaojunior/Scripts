Declare @MyString Varchar(100)

Set @MyString = 'C:\Documents'

-- Resultado --
SELECT LEFT(@MyString, LEN(@MyString) - CHARINDEX('\', REVERSE(@MyString)))
Go

-- Explicação --
Select Left(@MyString,LEN(@MyString)) As Esquerda,
          Len(@MyString) As Tamanho,
		  CHARINDEX('\',@MyString) As 'Posição do Caracter',
		  REVERSE(@MyString) As Reverso
Go