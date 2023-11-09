-- Criando a Tabela Valores --
Create Table Valores
 (Contador Int Primary Key Identity(1,1),
  CodigoCaracter Char(4),
  SequenciaDeControle Int)
Go

-- Inserindo os registros com CódigoCaracter 0001 --
Insert Into Valores Values ('0001',1),('0001',2),('0001',3),('0001',4)
Go

-- Inserindo os registros com CódigoCaracter 0002 --
Insert Into Valores Values ('0002',5),('0002',6),('0002',7),('0002',8)
Go

-- Inserindo os registros com CódigoCaracter 0003 --
Insert Into Valores Values ('0003',9),('0003',10)
Go

-- Consultando os registros inseridos --
Select Contador, CodigoCaracter, SequenciaDeControle from Valores
Go

-- Declarando um bloco de execução para alterar os registros de acordo com uma condição --
Declare @ContadorRegistros Int,
              @ContadorSequenciaDeControle Int,
		      @ValorColunaCodigoCaracter Char(4)

Set @ContadorRegistros=1
Set @ContadorSequenciaDeControle=1

While @ContadorRegistros <= (Select Count(CodigoCaracter) from Valores)
Begin
 
 Set @ValorColunaCodigoCaracter=(Select CodigoCaracter From Valores Where Contador = @ContadorRegistros)
  
 If (@ValorColunaCodigoCaracter = (Select CodigoCaracter From Valores Where Contador = @ContadorRegistros) And @ContadorRegistros > 1)
  Set @ContadorSequenciaDeControle=@ContadorSequenciaDeControle + 1
 Else
  Set @ContadorSequenciaDeControle=0

 Update Valores
 Set SequenciaDeControle = @ContadorSequenciaDeControle
 Where Contador = @ContadorRegistros

 Set @ContadorRegistros += 1

End

-- Consultando os registros após a alteração --
Select Contador, CodigoCaracter, SequenciaDeControle from Valores
Go
