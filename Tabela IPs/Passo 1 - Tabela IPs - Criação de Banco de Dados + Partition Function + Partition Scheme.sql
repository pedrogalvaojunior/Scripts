-- Criando o Banco de Dados Enderecamento --
Create Database Enderecamento
On  Primary
(Name = N'Enderecamento-Data', 
 FileName = N'P:\Data\Enderecamento-Data.mdf', 
 Size = 8MB, 
 Maxsize = Unlimited, 
 Filegrowth = 512MB ), 
Filegroup [ClasseA] 
 (Name = N'Enderecamento-Data-ClasseA', 
  FileName = N'P:\Data\Enderecamento-Data-ClasseA.mdf' , 
  Size = 8MB, 
  Maxsize = Unlimited,
  Filegrowth = 512MB), 
Filegroup [ClasseB] 
 (Name = N'Enderecamento-Data-ClasseB', 
  FileName = N'P:\Data\Enderecamento-Data-ClasseB.ndf', 
  Size = 8MB, 
  Maxsize = Unlimited, 
  Filegrowth = 512MB), 
Filegroup [ClasseC] 
(Name = N'Enderecamento-Data-ClasseC', 
 FileName = N'P:\Data\Enderecamento-Data-ClasseC.ndf', 
 Size = 8MB, 
 Maxsize = Unlimited, 
 Filegrowth = 512MB), 
Filegroup [ClasseD] 
(Name = N'Enderecamento-Data-ClasseD', 
 FileName = N'P:\Data\Enderecamento-Data-ClasseD.ndf', 
 Size = 8Mb, 
 Maxsize = Unlimited, 
 FileGROWTH = 512MB), 
Filegroup [ClasseE] 
(Name = N'Enderecamento-Data-ClasseE', 
 FileName = N'P:\Data\Enderecamento-Data-ClasseE.ndf', 
 Size = 8Mb, 
 Maxsize = Unlimited, 
 Filegrowth = 512MB)
LOG ON 
(Name = N'Enderecamento-Log', 
 FileName = N'S:\MSSQL-2019\Log\Enderecamento-Log.ldf' , 
 Size = 1024MB, 
 Maxsize = Unlimited, 
 Filegrowth = 786432KB)
 Go

 -- Definindo o Filegroup ClasseA como padrão --
 Alter Database Enderecamento
  Modify Filegroup [ClasseA] Default
Go

-- Alterando o Modelo de Recuperação para Bulk_Logged --
Alter Database Enderecamento
 Set Recovery Bulk_Logged
Go

-- Desativando a contagem de Linhas processadas --
Set NoCount On
Go

-- Acessando o Banco de Dados --
Use Enderecamento
Go

-- Criando a Partition Function PF_DistribuicaoClassesIPs
Create Partition Function PF_DistribuicaoClassesIPs (Tinyint)
As Range Left For Values (62, 124, 186, 248)
Go

-- Criando o Partition Schema PS_DistribuicaoClassesIPs --
Create Partition Scheme PS_DistribuicaoClassesIPs
As Partition PF_DistribuicaoClassesIPs
To (ClasseA, ClasseB, ClasseC, ClasseD, ClasseE)
Go

-- Criando a Função [dbo].[ConverterInteiroParaBinario] para realizar a conversão de números inteiros para binário --
Create   Function [dbo].[ConverterInteiroParaBinario] (@ValorInteiro Bigint)
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

-- Criando a Tabela Numeracao --
Create Table Numeracao
 (Codigo TinyInt Primary Key Identity(0,1))
Go

-- Criando o Índice NonClustered ColumnStore IND_ColumnStoreIndex_Codigo
Create NonClustered Columnstore Index [IND_ColumnStoreIndex_Codigo] On Numeracao(Codigo)
On [Primary]
Go

-- Criando a Tabela TabelaIPs vinculada ao Partition Schema PS_DistribuicaoClassesIPs --
Create Table TabelaIPs
(PrimeiroOcteto TinyInt Not Null,
 SegundoOcteto TinyInt Not Null,
 TerceiroOcteto TinyInt Not Null,
 QuartoOcteto TinyInt Not Null,
 Constraint [PK_NumeroIP_PrimeiroOcteto] Primary Key Clustered (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto))
On [PS_DistribuicaoClassesIPs] (PrimeiroOcteto)
Go