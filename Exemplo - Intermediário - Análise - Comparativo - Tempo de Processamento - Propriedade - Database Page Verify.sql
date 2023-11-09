-- Criando o Banco de Dados TesteDatabasePageVerify --
Create Database TesteDatabasePageVerify 
Go

-- Acessando o Banco de Dados TesteDatabasePageVerify  --
Use TesteDatabasePageVerify 
Go

-- Criando a Tabela TabelaPageVerify --
Create Table TabelaPageVerify
  (Codigo Int Identity(1,1) Not Null Primary Key,
   Texto VarChar(10) Not Null,
   Quantidade SmallInt Not Null,
   ValoresNumericos Numeric(18, 2) Not Null,
   DataAtual Date Not Null)
Go

-- Criando a Tabela PageVerifyTempoDecorrido --
Create Table PageVerifyTempoDecorrido
(NumeroDaAnalise SmallInt Identity(1,1) Not Null,
 TipoDaAnaliseRealizada  Varchar(20) Not Null,
 HoraInicio Time Not Null,
 HoraFim Time Not Null,
 HoraDiferenca As (DateDiff(Second, HoraInicio, HoraFim)))
Go

-- Desativando a Contagem de Linhas --
Set NoCount On
Go

-- Declarando as vari·veis de controle --
Declare @Counter TinyInt = 0,
             @Text Char(130), 
             @Position TinyInt, 
		     @RowCount Int = 100000,
			 @HoraInicio Time = GetDate(), 
			 @HoraFim Time

Set @Text = '0123456789@ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyzéèùü°¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷Ÿ⁄€‹›‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˘˙˚¸˝ˇ.;^' --There are 130 characters in this text--

While @Counter <10 -- Definindo a quantidade m·xima de testes --
Begin

-- Alterando a Propriedade Page_Verify para None --
Alter Database TesteDatabasePageVerify 
Set Page_Verify None

-- Inserindo a massa de dados na tabela TabelaPageVerify --
While (@RowCount >=1)
Begin

 Set @Position=Rand()*130

   Insert Into TabelaPageVerify (Texto, Quantidade, ValoresNumericos, DataAtual)
   Values(Concat(SubString(@Text,@Position+2,2),SubString(@Text,@Position-4,4),SubString(@Text,@Position+2,4)),
                 Rand()*1000, 
	             Rand()*100+5, 
	             DATEADD(d, 1000*Rand() ,GetDate()))

       Set @RowCount = @RowCount - 1
End

Set @HoraFim=GetDate()

Insert Into PageVerifyTempoDecorrido (TipoDaAnaliseRealizada , HoraInicio, HoraFim)
Values ('None', @HoraInicio, @HoraFim)

-- Alterando a Propriedade Page_Verify para Torn_Page_Detection --
Alter Database TesteDatabasePageVerify 
Set Page_Verify Torn_Page_Detection

-- Inserindo a massa de dados na tabela TabelaPageVerify --
Set @RowCount = 100000
Set @HoraInicio = GetDate() 

While (@RowCount >=1)
Begin

 Set @Position=Rand()*130

   Insert Into TabelaPageVerify (Texto, Quantidade, ValoresNumericos, DataAtual)
   Values(Concat(SubString(@Text,@Position+2,2),SubString(@Text,@Position-4,4),SubString(@Text,@Position+2,4)),
                 Rand()*1000, 
	             Rand()*100+5, 
	             DATEADD(d, 1000*Rand() ,GetDate()))

       Set @RowCount = @RowCount - 1
End

Set @HoraFim=GetDate()

Insert Into PageVerifyTempoDecorrido (TipoDaAnaliseRealizada , HoraInicio, HoraFim)
Values ('Torn_Page_Detection', @HoraInicio, @HoraFim)

-- Alterando a Propriedade Page_Verify para CheckSum --
Alter Database TesteDatabasePageVerify 
Set Page_Verify CheckSum

-- Inserindo a massa de dados na tabela TabelaPageVerify --
Set @RowCount = 100000
Set @HoraInicio = GetDate() 

While (@RowCount >=1)
Begin

 Set @Position=Rand()*130

   Insert Into TabelaPageVerify (Texto, Quantidade, ValoresNumericos, DataAtual)
   Values(Concat(SubString(@Text,@Position+2,2),SubString(@Text,@Position-4,4),SubString(@Text,@Position+2,4)),
                 Rand()*1000, 
	             Rand()*100+5, 
	             DATEADD(d, 1000*Rand() ,GetDate()))

       Set @RowCount = @RowCount - 1
End

Set @HoraFim=GetDate()

Insert Into PageVerifyTempoDecorrido (TipoDaAnaliseRealizada , HoraInicio, HoraFim)
Values ('CheckSum', @HoraInicio, @HoraFim)

Set @Counter = @Counter + 1
End
Go

-- Consultando o resumo detalhado --
Select  NumeroDaAnalise, 
            TipoDaAnaliseRealizada, 
			HoraInicio,
			HoraFim,
			HoraDiferenca As 'Segundos'
From PageVerifyTempoDecorrido
Go

-- Consultando o resumo sumarizado --
Select  TipoDaAnaliseRealizada, 
            Avg(HoraDiferenca) As 'MÈdia em segundos'
From PageVerifyTempoDecorrido
Group By TipoDaAnaliseRealizada
Order By 'MÈdia em segundos' Desc
Go

-- Pivot --
Select 'MÈdia de processamento.....' As 'Sum·rio por segundos', [None],[Torn_Page_Detection],[CheckSum]
From (
           Select  TipoDaAnaliseRealizada, 
                       HoraDiferenca
                       From PageVerifyTempoDecorrido
		 ) As A
Pivot (Avg(HoraDiferenca) For TipoDaAnaliseRealizada In ([None],[Torn_Page_Detection],[CheckSum])) As Pvt
Union All
Select 'Menor tempo de processamento.....', [None],[Torn_Page_Detection],[CheckSum]
From (
           Select  TipoDaAnaliseRealizada, 
                       HoraDiferenca
                       From PageVerifyTempoDecorrido
		 ) As A
Pivot (Min(HoraDiferenca) For TipoDaAnaliseRealizada In ([None],[Torn_Page_Detection],[CheckSum])) As Pvt
Union All
Select 'Maior tempo de processamento.....', [None],[Torn_Page_Detection],[CheckSum]
From (
           Select  TipoDaAnaliseRealizada, 
                       HoraDiferenca
                       From PageVerifyTempoDecorrido
		 ) As A
Pivot (Max(HoraDiferenca) For TipoDaAnaliseRealizada In ([None],[Torn_Page_Detection],[CheckSum])) As Pvt
Union All
Select 'SomatÛria do tempo de processamento.....', [None],[Torn_Page_Detection],[CheckSum]
From (
           Select  TipoDaAnaliseRealizada, 
                       HoraDiferenca
                       From PageVerifyTempoDecorrido
		 ) As A
Pivot (Sum(HoraDiferenca) For TipoDaAnaliseRealizada In ([None],[Torn_Page_Detection],[CheckSum])) As Pvt
Go
