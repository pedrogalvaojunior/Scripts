-- Criando o Banco de Dados --
Create Database EnderecamentoIPs
Go

-- Acessando --
Use EnderecamentoIPs
Go

-- Criando a Função ConverterInteiroParaBinario --
Create Or Alter Function ConverterInteiroParaBinario (@ValorInteiro Bigint)
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

-- Criando a Tabela TabelaIPs --
Create Table TabelaIPs
(Codigo SmallInt Primary Key Identity(1,1),
 EnderecoIP Varchar(15) Not Null)
Go

-- Criando a Tabela EnderecamentoIPs --
Create Table EnderecamentoIPs
(CodigoEnderecamento SmallInt Primary Key Identity(1,1),
 EnderecoIP Varchar(15) Not Null,
 PrimeiroOcteto TinyInt,
 SegundoOcteto TinyInt,
 TerceiroOcteto TinyInt,
 QuartoOcteto TinyInt,
 PrimeiroOctetoBinario Char(8) Default '',
 SegundoOctetoBinario Char(8) Default '',
 TerceiroOctetoBinario Char(8) Default '',
 QuartoOctetoBinario Char(8) Default '')
Go

-- Inserindo a relação de EnderecosIPs --
Insert Into TabelaIPs Values('128.255.255.255')
Insert Into TabelaIPs Values('191.255.120.154')
Insert Into TabelaIPs Values('239.255.255.255')
Insert Into TabelaIPs Values('255.255.255.192')
Insert Into TabelaIPs Values('255.255.255.255')
Insert Into TabelaIPs Values('10.0.0.1')
Insert Into TabelaIPs Values('10.0.0.138')
Insert Into TabelaIPs Values('10.0.0.2')
Insert Into TabelaIPs Values('10.1.1.1')
Insert Into TabelaIPs Values('10.1.10.1')
Insert Into TabelaIPs Values('10.1.23.19')
Insert Into TabelaIPs Values('10.10.1.1')
Insert Into TabelaIPs Values('10.10.1.10')
Insert Into TabelaIPs Values('10.10.225.255')
Insert Into TabelaIPs Values('10.100.10.10')
Insert Into TabelaIPs Values('12.0.0.0')
Insert Into TabelaIPs Values('12.0.0.4')
Insert Into TabelaIPs Values('12.20.40.32')
Insert Into TabelaIPs Values('120.15.36.48')
Insert Into TabelaIPs Values('127.0.0.0')
Insert Into TabelaIPs Values('127.0.0.1')
Insert Into TabelaIPs Values('128.1.0.20')
Insert Into TabelaIPs Values('128.101.0.1')
Insert Into TabelaIPs Values('128.2.0.3')
Insert Into TabelaIPs Values('13.0.0.15')
Insert Into TabelaIPs Values('131.107.1.101')
Insert Into TabelaIPs Values('131.107.1.103')
Insert Into TabelaIPs Values('15.0.1.2')
Insert Into TabelaIPs Values('161.41.255.255')
Insert Into TabelaIPs Values('164.41.0.0')
Insert Into TabelaIPs Values('164.41.255.254')
Insert Into TabelaIPs Values('172.16.16.1')
Insert Into TabelaIPs Values('172.16.16.124')
Insert Into TabelaIPs Values('172.18.12.36')
Insert Into TabelaIPs Values('191.168.0.10')
Insert Into TabelaIPs Values('192.168.0.100')
Insert Into TabelaIPs Values('192.168.0.101')
Insert Into TabelaIPs Values('192.168.0.227')
Insert Into TabelaIPs Values('192.168.0.254')
Insert Into TabelaIPs Values('192.166.0.254')
Insert Into TabelaIPs Values('192.3.40.2')
Insert Into TabelaIPs Values('196.239.26.0')
Insert Into TabelaIPs Values('200.241.16.0')
Insert Into TabelaIPs Values('200.241.16.8')
Insert Into TabelaIPs Values('224.0.0.2')
Insert Into TabelaIPs Values('224.0.0.2')
Insert Into TabelaIPs Values('240.0.0.0')
Insert Into TabelaIPs Values('241.16.18.0')
Insert Into TabelaIPs Values('243.15.63.100')
Insert Into TabelaIPs Values('255.255.0.0')
Go

-- Consultando --
Select Codigo, EnderecoIP From TabelaIPs
Go

-- Aplicando a Função String_Split() para dividir os Octetos em Linhas --
Declare @ContadorDeLinhas TinyInt, @EnderecoIP Varchar(15), @PrimeiroOcteto TinyInt, @SegundoOcteto TinyInt,
              @TerceiroOcteto TinyInt, @QuartoOcteto TinyInt

Set @ContadorDeLinhas = 1

While @ContadorDeLinhas <= (Select Count(Codigo) From TabelaIPs)
Begin

 Set @EnderecoIP = (Select EnderecoIP From TabelaIPs Where Codigo = @ContadorDeLinhas)

 Set @PrimeiroOcteto=(Select Value As PrimeiroOcteto From TabelaIPs Cross Apply String_Split(EnderecoIP,'.') 
							      Where Codigo = @ContadorDeLinhas
							      Order By Codigo
							      OffSet 0 Row
							      Fetch Next 1 Rows Only)

 Set @SegundoOcteto=(Select Value As SegundoOcteto From TabelaIPs Cross Apply String_Split(EnderecoIP,'.')
							       Where Codigo = @ContadorDeLinhas							 
							       Order By Codigo Asc
							       OffSet 1 Row
							       Fetch Next 1 Rows Only)

 Set @TerceiroOcteto=(Select Value As TerceiroOcteto From TabelaIPs Cross Apply String_Split(EnderecoIP,'.')
							      Where Codigo = @ContadorDeLinhas							 
							      Order By Codigo Asc 
							      OffSet 2 Row
							      Fetch Next 1 Rows Only)

 Set @QuartoOcteto= (Select Value As QuartoOcteto From TabelaIPs Cross Apply String_Split(EnderecoIP,'.')
						         Where Codigo = @ContadorDeLinhas 						  
						         Order By Codigo
						         OffSet 3 Row
						         Fetch Next 1 Rows Only)
 
 -- Inserindo na Tabela EnderecamentoIPs --
 Insert Into EnderecamentoIPs
 Select @EnderecoIP, @PrimeiroOcteto, @SegundoOcteto, @TerceiroOcteto, @QuartoOcteto, 
            dbo.ConverterInteiroParaBinario(@PrimeiroOcteto),
			dbo.ConverterInteiroParaBinario(@SegundoOcteto),
			dbo.ConverterInteiroParaBinario(@TerceiroOcteto),
			dbo.ConverterInteiroParaBinario(@QuartoOcteto)

 Set @ContadorDeLinhas = @ContadorDeLinhas + 1
End
Go

-- Consultando a Tabela EnderecamentoIPs --
Select EnderecoIP, PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto,
           PrimeiroOctetoBinario, SegundoOctetoBinario, TerceiroOctetoBinario, QuartoOctetoBinario
From EnderecamentoIPs
Go