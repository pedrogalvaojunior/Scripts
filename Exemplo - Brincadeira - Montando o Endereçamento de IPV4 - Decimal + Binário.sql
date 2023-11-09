-- Criando o Banco de Dados --
Create Database Enderecamento
Go

-- Acessando --
Use Enderecamento
Go

-- Criando a Função ConverterInteiroParaBinario --
Create Or Alter Function ConverterInteiroParaBinario (@ValorInteiro bigint)
Returns Varchar(255)
As
Begin
 Declare @ValorResultado VarChar(255), @Contador TinyInt
  Set @Contador = 0
  Set @ValorResultado = ''

  While @Contador <255
   Begin
    Set @ValorResultado=Convert(Char(1), @ValorInteiro % 2)+@ValorResultado
    Set @ValorInteiro=Convert(TinyInt, (@ValorInteiro / 2))
	
	Set @Contador=@Contador+1
 End

 Return (Select Right(@ValorResultado,8) As Binario)
End
Go

-- Criando a Tabela de EnderecamentoIP --
Create Table EnderecamentoIP
 (CodigoEnderecamento Int Primary Key Identity(1,1),
   PrimeiroOcteto TinyInt,
   SegundoOcteto As (PrimeiroOcteto),
   TerceiroOcteto As (PrimeiroOcteto),
   QuartoOcteto As (PrimeiroOcteto),
   PrimeiroOctetoBinario Char(8) Default '',
   SegundoOctetoBinario As (PrimeiroOctetoBinario),
   TerceiroOctetoBinario As (PrimeiroOctetoBinario),
   QuartoOctetoBinario As (PrimeiroOctetoBinario))
Go

-- Criando a Tabela EnderecosDecimalXBinario --
Create Table EnderecosDecimalXBinario 
(CodigoEnderecoDecimalXBinario Int Primary Key Identity(1,1),
 EnderecoDecimal Varchar(15) Null,
 EnderecoBinario Char(35) Null)
Go

Truncate Table EnderecamentoIP
Go

-- Inserindo os valores --
Declare @ContadorDeLinhas SmallInt, @RepeticaoDeLinhas SmallInt, @NumeroDecimal SmallInt
Set @ContadorDeLinhas = 0
Set @RepeticaoDeLinhas = 0
Set @NumeroDecimal=0

While (@ContadorDeLinhas <=255) And (@NumeroDecimal <=255)
 Begin
 
   While @RepeticaoDeLinhas <255
    Begin
     Insert Into EnderecamentoIP (PrimeiroOcteto, PrimeiroOctetoBinario)
     Values (@NumeroDecimal, dbo.ConverterInteiroParaBinario(@NumeroDecimal))
  
      Set @RepeticaoDeLinhas = @RepeticaoDeLinhas + 1
   End

  Set @RepeticaoDeLinhas = 0	  
  Set @NumeroDecimal = @NumeroDecimal + 1
  Set @ContadorDeLinhas = @ContadorDeLinhas + 1
 End
Go

-- Consultando --
Select * From EnderecamentoIP
Where PrimeiroOcteto In (1,56,69,78,154,214,254)
Go

-- Apresentando o Enderecamento - Decimal, Binário, Próximo e Anterior --
Select Distinct E1.PrimeiroOcteto,E2.SegundoOcteto,E3.TerceiroOcteto,E4.QuartoOcteto
From EnderecamentoIP E1 Cross Join EnderecamentoIP E2 Cross Join EnderecamentoIP E3 Cross Join EnderecamentoIP E4
Go

--------------------------------------------------------------------------- // ---------------------------------------------------------
Create Table Numeracao
 (Numero TinyInt Primary Key Identity(0,1) Not Null)
Go

Truncate Table Numeracao
Go

Insert Into Numeracao Default Values
Go 256

Select N1.Numero, N2.Numero, N3.Numero, N4.Numero
From Numeracao N1 Cross Join Numeracao N2 Cross Join Numeracao N3 Cross Join Numeracao N4
Order By N1.Numero Asc
Go