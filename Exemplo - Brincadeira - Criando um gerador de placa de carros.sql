-- Criando o Banco de Dados --
Create Database GeradorDePlacas
Go

-- Acessando o Banco de Dados --
Use GeradorDePlacas
Go

-- Desativando a contagem de linhas --
Set NoCount On
Go

-- Criando a Tabela LetrasCombinadas para armazenar todas as combinações de Letras --
Create Table LetrasCombinadas
(CodigoSequencialLetrasCombinadas SmallInt Primary Key Identity(1,1) Not Null,
 SequencialDeLetrasCombinadas Char(3) Not Null)
Go

-- Criando a Tabela Numeracao para armazenar a faixa numérica de 1 até 9999 --
Create Table Numeracao
(CodigoNumeracao SmallInt Primary Key Identity(1,1) Not Null)
Go

-- Criando a Tabela Placas para armazenar o CodigoSequencialLetrasCombinadas e o número da Placa --
Create Table Placas
(CodigoSequencialPlacas Int Primary Key Identity(1,1) Not Null,
 CodigoSequencialLetrasCombinadas SmallInt Not Null,
 CodigoSequencialNumeroPlacas SmallInt Not Null)
Go

-- Criando a Tabela FaixasDeFaixasDePlacasPorEstado para armazenar as faixas de placas por Estado --
Create Table FaixasDePlacasPorEstado
(CodigoSequencialFaixasDePlacasPorEstado TinyInt Primary Key Identity(1,1) Not Null,
 CodigoSequencialFaixasDeLetrasNumerosInicial Char(7) Not Null,
 CodigoSequencialFaixasDeLetrasNumerosFinal Char(7) Not Null,
 FaixasDePlacasPorEstadoNomeDoEstado Varchar(30) Not Null)
Go

-- Inserindo a distribuição de Faixas de Placas Por Estado --
Insert Into FaixasDePlacasPorEstado Values ('AAA0001','BEZ9999','Paraná')
Insert Into FaixasDePlacasPorEstado Values ('BFA0001','GKI9999','São Paulo')
Insert Into FaixasDePlacasPorEstado Values ('GKJ0001','HOK9999','Minas Gerais')
Insert Into FaixasDePlacasPorEstado Values ('HOL0001','HQE9999','Maranhão')
Insert Into FaixasDePlacasPorEstado Values ('HQF0001','HTW9999','Mato Grosso do Sul')
Insert Into FaixasDePlacasPorEstado Values ('HTX0001','HZA9999','Ceará')
Insert Into FaixasDePlacasPorEstado Values ('HZB0001','IAP9999','Sergipe')
Insert Into FaixasDePlacasPorEstado Values ('IAQ0001','JDO9999','Rio Grande do Sul')
Insert Into FaixasDePlacasPorEstado Values ('JDP0001','JKR9999','Distrito Federal')
Insert Into FaixasDePlacasPorEstado Values ('JKS0001','JSZ9999','Bahia')
Insert Into FaixasDePlacasPorEstado Values ('JTA0001','JWE9999','Pará')
Insert Into FaixasDePlacasPorEstado Values ('JWF0001','JXY9999','Amazonas')
Insert Into FaixasDePlacasPorEstado Values ('JXZ0001','KAU9999','Mato Grosso')
Insert Into FaixasDePlacasPorEstado Values ('KAV0001','KFC9999','Goiás')
Insert Into FaixasDePlacasPorEstado Values ('KFD0001','KME9999','Pernambuco')
Insert Into FaixasDePlacasPorEstado Values ('KMF0001','LVE9999','Rio de Janeiro')
Insert Into FaixasDePlacasPorEstado Values ('LVF0001','LWQ9999','Piauí')
Insert Into FaixasDePlacasPorEstado Values ('LWR0001','MMM9999','Santa Catarina')
Insert Into FaixasDePlacasPorEstado Values ('MMN0001','MOW9999','Paraíba')
Insert Into FaixasDePlacasPorEstado Values ('MOX0001','MTZ9999','Espírito Santo')
Insert Into FaixasDePlacasPorEstado Values ('MUA0001','MVK9999','Alagoas')
Insert Into FaixasDePlacasPorEstado Values ('MVL0001','MXG9999','Tocantins')
Insert Into FaixasDePlacasPorEstado Values ('MXH0001','MZM9999','Rio Grande do Norte')
Insert Into FaixasDePlacasPorEstado Values ('MZN0001','NAG9999','Acre')
Insert Into FaixasDePlacasPorEstado Values ('NAH0001','NBA9999','Roraima')
Insert Into FaixasDePlacasPorEstado Values ('NBB0001','NEH9999','Rondônia')
Insert Into FaixasDePlacasPorEstado Values ('NEI0001','NFB9999','Amapá')
Insert Into FaixasDePlacasPorEstado Values ('NFC0001','NGZ9999','Goiás')
Insert Into FaixasDePlacasPorEstado Values ('NHA0001','NHT9999','Maranhão')
Insert Into FaixasDePlacasPorEstado Values ('NHU0001','NIX9999','Piauí')
Insert Into FaixasDePlacasPorEstado Values ('NIY0001','NJW9999','Mato Grosso')
Insert Into FaixasDePlacasPorEstado Values ('NJX0001','NLU9999','Goiás')
Insert Into FaixasDePlacasPorEstado Values ('NLV0001','NMO9999','Alagoas')
Insert Into FaixasDePlacasPorEstado Values ('NMP0001','NNI9999','Maranhão')
Insert Into FaixasDePlacasPorEstado Values ('NNJ0001','NOH9999','Rio Grande do Norte')
Insert Into FaixasDePlacasPorEstado Values ('NOI0001','NPB9999','Amazonas')
Insert Into FaixasDePlacasPorEstado Values ('NPC0001','NPQ9999','Mato Grosso')
Insert Into FaixasDePlacasPorEstado Values ('NPR0001','NQK9999','Paraíba')
Insert Into FaixasDePlacasPorEstado Values ('NQL0001','NRE9999','Ceará')
Insert Into FaixasDePlacasPorEstado Values ('NRF0001','NSD9999','Mato Grosso do Sul')
Insert Into FaixasDePlacasPorEstado Values ('NSE0001','NTC9999','Pará')
Insert Into FaixasDePlacasPorEstado Values ('NTD0001','NTW9999','Bahia')
Insert Into FaixasDePlacasPorEstado Values ('NTX0001','NUG9999','Mato Grosso')
Insert Into FaixasDePlacasPorEstado Values ('NUH0001','NUL9999','Roraima')
Insert Into FaixasDePlacasPorEstado Values ('NUM0001','NVF9999','Ceará')
Insert Into FaixasDePlacasPorEstado Values ('NVG0001','NVN9999','Sergipe')
Insert Into FaixasDePlacasPorEstado Values ('NVO0001','NWR9999','Goiás')
Insert Into FaixasDePlacasPorEstado Values ('NWS0001','NXQ9999','Maranhão')
Insert Into FaixasDePlacasPorEstado Values ('NXR0001','NXT9999','Acre')
Insert Into FaixasDePlacasPorEstado Values ('NXU0001','NXW9999','Pernambuco')
Insert Into FaixasDePlacasPorEstado Values ('NXX0001','NYG9999','Minas Gerais')
Insert Into FaixasDePlacasPorEstado Values ('NYH0001','NZZ9999','Bahia')
Insert Into FaixasDePlacasPorEstado Values ('OAA0001','OAO9999','Amazonas')
Insert Into FaixasDePlacasPorEstado Values ('OAP0001','OBS9999','Mato Grosso')
Insert Into FaixasDePlacasPorEstado Values ('OBT0001','OCA9999','Pará')
Insert Into FaixasDePlacasPorEstado Values ('OCB0001','OCU9999','Ceará')
Insert Into FaixasDePlacasPorEstado Values ('OCV0001','ODT9999','Espírito Santo')
Insert Into FaixasDePlacasPorEstado Values ('ODU0001','OEI9999','Piauí')
Insert Into FaixasDePlacasPorEstado Values ('OEJ0001','OES9999','Sergipe')
Insert Into FaixasDePlacasPorEstado Values ('OET0001','OFH9999','Paraíba')
Insert Into FaixasDePlacasPorEstado Values ('OFI0001','OFW9999','Pará')
Insert Into FaixasDePlacasPorEstado Values ('OFX0001','OGG9999','Paraiba')
Insert Into FaixasDePlacasPorEstado Values ('OGH0001','OHA9999','Goiás')
Insert Into FaixasDePlacasPorEstado Values ('OHB0001','OHK9999','Alagoas')
Insert Into FaixasDePlacasPorEstado Values ('OHL0001','OHW9999','Rondônia')
Insert Into FaixasDePlacasPorEstado Values ('OHX0001','OIQ9999','Ceará')
Insert Into FaixasDePlacasPorEstado Values ('OIR0001','OJK9999','Maranhão')
Insert Into FaixasDePlacasPorEstado Values ('OJR0001','OKC9999','Rio Grande do Norte')
Insert Into FaixasDePlacasPorEstado Values ('OKI0001','OLG9999','Bahia')
Insert Into FaixasDePlacasPorEstado Values ('OLH0001','OLN9999','Tocantins')
Insert Into FaixasDePlacasPorEstado Values ('OLO0001','OMH9999','Minas Gerais')
Insert Into FaixasDePlacasPorEstado Values ('OMI0001','OOF9999','Goiás')
Insert Into FaixasDePlacasPorEstado Values ('OOG0001','OOU9999','Mato Grosso do Sul')
Insert Into FaixasDePlacasPorEstado Values ('OOV0001','ORC9999','Minas Gerais')
Insert Into FaixasDePlacasPorEstado Values ('ORD0001','ORM9999','Alagoas')
Insert Into FaixasDePlacasPorEstado Values ('ORN0001','OSV9999','Ceará')
Insert Into FaixasDePlacasPorEstado Values ('OSW0001','OTZ9999','Pará')
Insert Into FaixasDePlacasPorEstado Values ('OUA0001','OUE9999','Piauí')
Insert Into FaixasDePlacasPorEstado Values ('OUF0001','OVD9999','Bahia')
Insert Into FaixasDePlacasPorEstado Values ('OVE0001','OWC9999','Espírito Santo')
Insert Into FaixasDePlacasPorEstado Values ('OWD0001','OYG9999','Santa Catarina')
Insert Into FaixasDePlacasPorEstado Values ('PEE0001','PFQ9999','Pernambuco')
Insert Into FaixasDePlacasPorEstado Values ('PFR0001','PGK9999','Pernambuco')
Insert Into FaixasDePlacasPorEstado Values ('PGL0001','PHE9999','Pernambuco')
Insert Into FaixasDePlacasPorEstado Values ('SAV0001','SAV9999','São Paulo')
Go

-- Validando os dados inseridos na Tabela FaixasDePlacasPorEstado --
Select * From FaixasDePlacasPorEstado
Go

-- Inserindo 9999 linhas de registros lógicos na Tabela Numeracao --
Insert Into Numeracao Default Values
Go 9999

-- Validando os dados inseridos na Tabela Numeracao --
Select * From Numeracao
Go

-- Montando a CTE Recursiva para Gerar todas as combinações de Letras --
;With CTEMeuAlfabeto
As
(Select * From (Values ('A'),('B'),('C'),('D'),('E'),('F'),('G'),('H'),('I'),('J'),('K'),
					   ('L'),('M'),('N'),('O'),('P'),('Q'),('R'),('S'),('T'),('U'),('V'),
					   ('W'),('X'),('Y'),('Z')) As Alfabeto (LetrasDoAlfabeto)
)
-- Inserindo as combinações de letras na Tabela LetrasCombinadas --
Insert Into LetrasCombinadas
Select Distinct Concat(A1.LetrasDoAlfabeto, A2.LetrasDoAlfabeto, A3.LetrasDoAlfabeto) As ConcatenacaoLetrasCombinadas
From CTEMeuAlfabeto A1 
      Cross Join CTEMeuAlfabeto A2 -- Aqui que a mágia acontece --
      Cross Join CTEMeuAlfabeto A3 -- O cross join vai cruzar e combinar todas as letras --
Order By ConcatenacaoLetrasCombinadas Asc
Go

-- Validando os dados inseridos na Tabela LetrasCombinadas --
Select * From LetrasCombinadas
Go


-- Cenário 1 --
-- Inserindo dados na Tabela de Placas através de Loop Condicional - 19Hrs e 33s de processamento --

-- Limpando a Tabela de Placas --
Truncate Table Placas
Go

-- Declarando as variáveis de controle --
Declare @ContadorSequencialTotalPlacasInseridas Int = 1, @ContadorSequencialParcialPlacasInseridas Int = 1, @CodigoSequencialLetrasCombinadas Int = 1

-- Abrindo o Loop de Inserção --
While @ContadorSequencialTotalPlacasInseridas <=(Select Max(CodigoSequencialLetrasCombinadas) From LetrasCombinadas)
Begin

 Set @CodigoSequencialLetrasCombinadas=(Select CodigoSequencialLetrasCombinadas From LetrasCombinadas
                                        Where CodigoSequencialLetrasCombinadas = @ContadorSequencialTotalPlacasInseridas)

 While @ContadorSequencialParcialPlacasInseridas <=9999 -- Contador a cada 9999 incrementa a variável @ContadorSequencialTotalPlacasInseridas 
 Begin
  Insert Into Placas (CodigoSequencialLetrasCombinadas, CodigoSequencialNumeroPlacas)
  Values (@CodigoSequencialLetrasCombinadas, @ContadorSequencialParcialPlacasInseridas)
  
  Set @ContadorSequencialParcialPlacasInseridas +=1									 
 End

 Set @ContadorSequencialParcialPlacasInseridas = 1
 Set @CodigoSequencialLetrasCombinadas +=1
 Set @ContadorSequencialTotalPlacasInseridas +=1

End

-- Cenário 2 --
-- Inserindo dados na Tabela de Placas através de CTE Recursiva com Junção Cruzada -- 1 hora, 33 e 40s de processamento --

-- Limpando a Tabela de Placas --
Truncate Table Placas
Go

-- Declarando as variáveis de controle --
Declare @ContadorSequencialTotalPlacasInseridas Int = 1, @CodigoSequencialLetrasCombinadas SmallInt = 1

While @ContadorSequencialTotalPlacasInseridas <=(Select Max(CodigoSequencialLetrasCombinadas) From LetrasCombinadas)
Begin

 -- Realizando a Junção Cruzada entre as Tabelas LetrasCombinadas x CTENumeracao --
 ;With CTENumeracao
 As
 (Select 1 As Numero
  Union All
  Select Numero + 1 From CTENumeracao
  Where Numero <=9998
 )
 Insert Into Placas (CodigoSequencialLetrasCombinadas, CodigoSequencialNumeroPlacas)
 Select LC.CodigoSequencialLetrasCombinadas, N.Numero
 From LetrasCombinadas LC Cross Join -- Aqui acontece a mágia
                           CTENumeracao N -- Cross Joi vai combinar todas as Letras com 9999 números --
 Where CodigoSequencialLetrasCombinadas = @CodigoSequencialLetrasCombinadas
 Option (MaxRecursion 0)

 Set @CodigoSequencialLetrasCombinadas +=1
 Set @ContadorSequencialTotalPlacasInseridas +=1
End
Go

-- Cenário 3 --
-- Inserindo dados na Tabela de Placas através de Junção Cruzada - 43 minutos e 28s de processamento --

-- Limpando a Tabela de Placas --
Truncate Table Placas
Go

-- Declarando as variáveis de controle --
Declare @ContadorSequencialTotalPlacasInseridas Int = 1, @CodigoSequencialLetrasCombinadas SmallInt = 1

While @ContadorSequencialTotalPlacasInseridas <=(Select Max(CodigoSequencialLetrasCombinadas) From LetrasCombinadas)
Begin

 -- Realizando a Junção Cruzada entre as Tabelas LetrasCombinadas x Numeração --
 Insert Into Placas (CodigoSequencialLetrasCombinadas, CodigoSequencialNumeroPlacas)
 Select LC.CodigoSequencialLetrasCombinadas, N.CodigoNumeracao
 From LetrasCombinadas LC Cross Join -- Aqui acontece a mágia
                           Numeracao N -- Cross Joi vai combinar todas as Letras com 9999 números --
 Where CodigoSequencialLetrasCombinadas = @CodigoSequencialLetrasCombinadas

 Set @CodigoSequencialLetrasCombinadas +=1
 Set @ContadorSequencialTotalPlacasInseridas +=1
End
Go

-- Apresentando as Placas Geradas --
Select top 100 Concat(LC.SequencialDeLetrasCombinadas,'-',
	   Convert(Char(4),Case 
	   When P.CodigoSequencialNumeroPlacas BetWeen 1 And 9 Then Concat('000',P.CodigoSequencialNumeroPlacas)
	   When P.CodigoSequencialNumeroPlacas BetWeen 10 And 99 Then Concat('00',P.CodigoSequencialNumeroPlacas)
	   When P.CodigoSequencialNumeroPlacas BetWeen 100 And 999 Then Concat('0',P.CodigoSequencialNumeroPlacas)
       When P.CodigoSequencialNumeroPlacas BetWeen 1000 And 9999 Then Convert(Char(4),P.CodigoSequencialNumeroPlacas)
      End)) As 'Placa',
	  IsNull(F.FaixasDePlacasPorEstadoNomeDoEstado,'Sequência não atribuída...') As 'Nome do Estado'
From LetrasCombinadas LC Inner Join Placas P
                          On LC.CodigoSequencialLetrasCombinadas = P.CodigoSequencialLetrasCombinadas
						 Left Join FaixasDePlacasPorEstado F
						  On LC.SequencialDeLetrasCombinadas Between SubString(F.CodigoSequencialFaixasDeLetrasNumerosInicial,1,3)
						  And SubString(F.CodigoSequencialFaixasDeLetrasNumerosFinal,1,3)
Go

-- Validar a geração final de placas com CodigoSequencialNumeroPlacas = 9999 --
Select * From Placas
Where CodigoSequencialNumeroPlacas = 9999
Go

-- Criando a Visão V_ApresentarPlacas --
Create View V_ApresentarPlacas
As
Select Concat(LC.SequencialDeLetrasCombinadas,'-',
	       Convert(Char(4), Case 
										When P.CodigoSequencialNumeroPlacas BetWeen 1 And 9 Then Concat('000',P.CodigoSequencialNumeroPlacas)
	                                    When P.CodigoSequencialNumeroPlacas BetWeen 10 And 99 Then Concat('00',P.CodigoSequencialNumeroPlacas)
	                                    When P.CodigoSequencialNumeroPlacas BetWeen 100 And 999 Then Concat('0',P.CodigoSequencialNumeroPlacas)
                                        When P.CodigoSequencialNumeroPlacas BetWeen 1000 And 9999 Then Convert(Char(4),P.CodigoSequencialNumeroPlacas)
                                      End)) As 'Placa',
	       IsNull(F.FaixasDePlacasPorEstadoNomeDoEstado,'Sequência não atribuída...') As 'Nome do Estado'
From LetrasCombinadas LC Inner Join Placas P
                                              On LC.CodigoSequencialLetrasCombinadas = P.CodigoSequencialLetrasCombinadas
						                     Left Join FaixasDePlacasPorEstado F
						                      On LC.SequencialDeLetrasCombinadas Between SubString(F.CodigoSequencialFaixasDeLetrasNumerosInicial,1,3)
						                      And SubString(F.CodigoSequencialFaixasDeLetrasNumerosFinal,1,3)
Go

-- Executando a View V_ApresentarPlacas --
Select * From V_ApresentarPlacas
Go

-- Criando a Stored Procedure P_PesquisarPlacas --
Create or Alter Procedure P_PesquisarPlacas @LetrasCombinadas Char(3), @SequenciaNumerica NVarchar(4) = Null
As
Begin

Set NoCount On

Declare @CodigoSequencialLetrasCombinadas SmallInt=0, @SequenciaNumericaConvertida NVarChar(4)=Null

-- Verificando se a combinação de Letras é válidas --
If Exists (Select CodigoSequencialLetrasCombinadas From LetrasCombinadas Where SequencialDeLetrasCombinadas = @LetrasCombinadas) 
 Begin
 
  Set @CodigoSequencialLetrasCombinadas = (Select CodigoSequencialLetrasCombinadas From LetrasCombinadas Where SequencialDeLetrasCombinadas = @LetrasCombinadas) 

   -- Verificando qual o padrão de placa deverá ser apresentado --
  If IsNumeric(@SequenciaNumerica)=1
   Begin

   Set @SequenciaNumericaConvertida = (Select CodigoNumeracao From Numeracao Where CodigoNumeracao = @SequenciaNumerica)

  -- Tratando a Sequência Numérica para ser apresentada --	
	If Len(@SequenciaNumericaConvertida)=1
    Set @SequenciaNumericaConvertida=CONCAT('000',@SequenciaNumericaConvertida)
   Else If Len(@SequenciaNumericaConvertida)=2
    Set @SequenciaNumericaConvertida=CONCAT('00',@SequenciaNumericaConvertida)
   Else If Len(@SequenciaNumericaConvertida)=3
    Set @SequenciaNumericaConvertida=CONCAT('0',@SequenciaNumericaConvertida)
   Else 
    Set @SequenciaNumericaConvertida=@SequenciaNumerica

    Select Concat(LC.SequencialDeLetrasCombinadas,' - ', @SequenciaNumericaConvertida) As Placa,
               IsNull(F.FaixasDePlacasPorEstadoNomeDoEstado,'Sequência não atribuída...') As 'Nome do Estado'
    From LetrasCombinadas LC Inner Join Placas P
												  On P.CodigoSequencialLetrasCombinadas = LC.CodigoSequencialLetrasCombinadas
												  And P.CodigoSequencialNumeroPlacas = @SequenciaNumerica
                                                 Left Join FaixasDePlacasPorEstado F
   	  					                          On @LetrasCombinadas Between SubString(F.CodigoSequencialFaixasDeLetrasNumerosInicial,1,3)
						                          And SubString(F.CodigoSequencialFaixasDeLetrasNumerosFinal,1,3)
   Where LC.SequencialDeLetrasCombinadas = @LetrasCombinadas
  End
  Else
   Begin

   Set @SequenciaNumericaConvertida = (Case Substring(Convert(NVarChar(4),@SequenciaNumerica),2,1) 
																						 When 'A' Then Concat(SubString(@SequenciaNumerica,1,1),'0',SubString(@SequenciaNumerica,3,2))
																						 When 'B' Then Concat(SubString(@SequenciaNumerica,1,1),'1',SubString(@SequenciaNumerica,3,2))
																						 When 'C' Then Concat(SubString(@SequenciaNumerica,1,1),'2',SubString(@SequenciaNumerica,3,2))
																						 When 'D' Then Concat(SubString(@SequenciaNumerica,1,1),'3',SubString(@SequenciaNumerica,3,2))
																						 When 'E' Then Concat(SubString(@SequenciaNumerica,1,1),'4',SubString(@SequenciaNumerica,3,2))
																						 When 'F' Then Concat(SubString(@SequenciaNumerica,1,1),'5',SubString(@SequenciaNumerica,3,2))
																						 When 'G' Then Concat(SubString(@SequenciaNumerica,1,1),'6',SubString(@SequenciaNumerica,3,2))
																						 When 'H' Then Concat(SubString(@SequenciaNumerica,1,1),'7',SubString(@SequenciaNumerica,3,2))
																						 When 'I' Then Concat(SubString(@SequenciaNumerica,1,1),'8',SubString(@SequenciaNumerica,3,2))
																						 When 'J' Then Concat(SubString(@SequenciaNumerica,1,1),'9',SubString(@SequenciaNumerica,3,2))
																					End)

    Select Concat(LC.SequencialDeLetrasCombinadas,' - ', @SequenciaNumerica) As 'Placa Mercosul',
	           Concat(LC.SequencialDeLetrasCombinadas,' - ', @SequenciaNumericaConvertida) As 'Placa Antiga',
               IsNull(F.FaixasDePlacasPorEstadoNomeDoEstado,'Sequência não atribuída...') As 'Nome do Estado'
    From LetrasCombinadas LC Inner Join Placas P
												  On P.CodigoSequencialLetrasCombinadas = LC.CodigoSequencialLetrasCombinadas
												  And P.CodigoSequencialNumeroPlacas = Convert(SmallInt,@SequenciaNumericaConvertida)
                                                 Left Join FaixasDePlacasPorEstado F
   	  					                          On @LetrasCombinadas Between SubString(F.CodigoSequencialFaixasDeLetrasNumerosInicial,1,3)
						                          And SubString(F.CodigoSequencialFaixasDeLetrasNumerosFinal,1,3)
   Where LC.SequencialDeLetrasCombinadas = @LetrasCombinadas  
  End
End
Else
 Select 'Placa informada inválida...' As 'Mensagem'
End
Go

-- Executando a Stored Procedure P_PesquisarPlacas --
Exec P_PesquisarPlacas 'FBD', '1A27'
Go

-- Analisar plano de execução --

-- Identificar qual índice pode ser mais vantajoso --

-- Criando um novo índice de cobertura para melhorar a performance --
Create NonClustered Index Ind_CoverageIndex_Placas_CodigoSequencialNumeroPlacas
On Placas (CodigoSequencialNumeroPlacas)
Include (CodigoSequencialLetrasCombinadas)
Go

-- Criando um novo índice NonClustered - Composto pelas colunas CodigoSequencialLetrasCombinadas e CodigoSequencialNumeroPlacas --
Create NonClustered Index Ind_NonClustered_Placas_CodigoSequencialLetrasCombinadas_CodigoSequencialNumeroPlacas
On Placas (CodigoSequencialLetrasCombinadas,CodigoSequencialNumeroPlacas)
Go