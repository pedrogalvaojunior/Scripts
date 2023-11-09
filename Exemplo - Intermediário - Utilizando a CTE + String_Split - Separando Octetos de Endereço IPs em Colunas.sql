-- Exemplo 1 -- Passando um endereço de IP fixo --
;With CTESeparacaoOctetos (NumeroOcteto, NumeroDecimal)
As
(
 Select Row_Number() Over (Order By (Select Null)) As NumeroOcteto, Value As NumeroDecimal From String_Split('192.168.1.10','.') 
 )
, CTEOctetos (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
 As
 (Select (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 1),
             (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 2),
             (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 3),
             (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 4))
Select * From CTEOctetos
Go

-- Exemplo 2 -- Passando o endereço de IP através de uma variável --
-- Declarando a variável para receber o IP --
Declare @EnderecoIP Varchar(15)
Set @EnderecoIP = '164.41.255.254'

;With CTESeparacaoOctetos (NumeroOcteto, NumeroDecimal)
As
(
 Select Row_Number() Over (Order By (Select Null)) As NumeroOcteto, Value As NumeroDecimal From String_Split(@EnderecoIP,'.') 
 )
, CTEOctetos (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
 As
 (Select (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 1),
             (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 2),
             (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 3),
             (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 4))
Select @EnderecoIP As IP, * From CTEOctetos
Go

-- Exemplo 3 -- Utilizando Tabela com Endereços IPs --
-- Criando a Tabela TabelaIPs --
Create Table TabelaIPs
(Codigo SmallInt Primary Key Identity(1,1),
 EnderecoIP Varchar(15) Not Null)
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

-- Declarando a variável para receber o IP --
Declare @EnderecoIP Varchar(15)
Set @EnderecoIP = '164.41.255.254'

;With CTESeparacaoOctetos (NumeroOcteto, NumeroDecimal)
As
(
 Select Row_Number() Over (Order By (Select Null)) As NumeroOcteto, Value As NumeroDecimal From TabelaIPs T Cross Apply String_Split(@EnderecoIP,'.') 
 Where T.EnderecoIP = @EnderecoIP
 )
, CTEOctetos (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
 As
 (Select (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 1),
             (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 2),
             (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 3),
             (Select NumeroDecimal From CTESeparacaoOctetos Where NumeroOcteto = 4))
Select @EnderecoIP As IP, * From CTEOctetos
Go