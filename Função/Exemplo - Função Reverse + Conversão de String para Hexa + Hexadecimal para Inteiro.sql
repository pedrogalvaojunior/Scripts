declare @hexstring as varchar(max)
set @hexstring = 'B2A1'

--Invertendo a posição da String
set @hexstring = Reverse(@hexstring)

Select @hexstring


-- Realizando a conversão da expressão para Inteiro com base na conversão em Hexadecimal
Select Convert(Int,Convert(varbinary(max), @hexstring))