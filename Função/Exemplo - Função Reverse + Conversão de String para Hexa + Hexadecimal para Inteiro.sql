declare @hexstring as varchar(max)
set @hexstring = 'B2A1'

--Invertendo a posi��o da String
set @hexstring = Reverse(@hexstring)

Select @hexstring


-- Realizando a convers�o da express�o para Inteiro com base na convers�o em Hexadecimal
Select Convert(Int,Convert(varbinary(max), @hexstring))