-- Verificando a existência do Banco de Dados TesteDoisArquivos --
If Exists (Select Name From sys.sysdatabases Where Name = 'TesteDoisArquivos') 
 Drop Database TesteDoisArquivos
 Go

 -- Criando o Banco de Dados TesteDoisArquivos --
Create Database TesteDoisArquivos
On Primary
 (Name = 'TesteDoisArquivos-Data1',
  FileName = 'S:\MSSQL-2019\DATA\TesteDoisArquivos-Data1.MDF',
  Size=8MB,
  MaxSize=8192MB,
  FileGrowth=64MB),
  (Name = 'TesteDoisArquivos-Data2',
  FileName = 'S:\MSSQL-2019\DATA\TesteDoisArquivos-Data2.NDF',
  Size=8MB,
  MaxSize=8192MB,
  FileGrowth=64MB)
Log On
(Name = 'TesteDoisArquivos-Log',
  FileName = 'S:\MSSQL-2019\Log\TesteDoisArquivos-Log.LDF',
  Size=8MB,
  MaxSize=8192MB,
  FileGrowth=64MB)
Go

-- Desanexando o Banco de Dados TesteDoisArquivos --
Exec sp_detach_db 'TesteDoisArquivos'
Go

-- Anexando o Banco de Dados TesteDoisArquivos, informando o conjunto de arquivos --
Exec sp_attach_db 'TesteDoisArquivos',
 @FileName1 = N'S:\MSSQL-2019\DATA\TesteDoisArquivos-Data1.mdf',
 @FileName2 = N'S:\MSSQL-2019\Log\TesteDoisArquivos-Log.ldf',
 @FileName3 = N'S:\MSSQL-2019\DATA\TesteDoisArquivos-Data2.ndf'
Go

-- Alterando o Modelo de Recuperação para Simple --
Alter Database TesteDoisArquivos
Set Recovery Full
Go

-- Acessando o Banco de Dados --
Use TesteDoisArquivos
Go

-- Criando a Tabela TabelaTesteDoisArquivos --
Create Table TabelaTesteDoisArquivos
(Codigo Int Identity(1,1) Primary Key Clustered,
 Descricao Char(100) Default 'Este é um teste de armazenamento de dados',
 ValorBig1 BigInt Default Rand()*100000+1,
 ValorBig2 BigInt Default Rand()*200000+2)
Go

-- Inserindo a Massa de Dados na Tabela TabelaTesteDois Arquivos --
Insert Into TabelaTesteDoisArquivos Default Values
Go 1000000

-- Consultando --
Select * From TabelaTesteDoisArquivos
Go