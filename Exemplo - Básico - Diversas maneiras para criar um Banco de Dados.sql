-- Exemplo 1 --
Create Database FatecBD2 --
Go

-- Exemplo 2 - Especificando suas configurações --
Create Database FatecBD2015
On Primary
	(Name = 'FatecBD2015-Data',
		FileName = 'C:\Bancos\Fatec\FatecBD2015-Data.MDF',
		Size = 50 MB,
		MaxSize = 500MB,
		FileGrowth = 10 MB)
Log On
	(Name = 'FatecBD2015-Log',
		FileName = 'C:\Bancos\Fatec\FatecBD2015-Log.LDF',
		Size = 100 MB,
		MaxSize = Unlimited,
		FileGrowth = 10%)
Go

-- Exercício 2 - Criando um novo Banco de Dados com dois arquivos de dados e um arquivo de log --
Create Database FatecBDTwoFiles
On Primary
	(Name = 'FatecBDTwoFiles-Data',
		FileName = 'C:\Bancos\Fatec\FatecBDTwoFiles-Data.MDF',
		Size = 50 MB,
		MaxSize = 500MB,
		FileGrowth = 10 MB),
	(Name = 'FatecBDTwoFiles-Data-1',
		FileName = 'C:\Bancos\Fatec\FatecBDTwoFiles-Data-1.MDF',
		Size = 50 MB,
		MaxSize = 500MB,
		FileGrowth = 10 MB)
Log On
	(Name = 'FatecBDTwoFiles-Log-1',
		FileName = 'C:\Bancos\Fatec\FatecBDTwoFiles-Log-1.LDF',
		Size = 100 MB,
		MaxSize = Unlimited,
		FileGrowth = 10%)
Go

-- Exercício 3 - Criando um novo Banco de Dados com múltiplos arquivos de dados e logs --
Create Database FatecBDVeryFiles
On Primary
	(Name = 'FatecBDVeryFiles-Data',
		FileName = 'C:\Bancos\Fatec\FatecBDVeryFiles-Data.MDF',
		Size = 10 MB,
		MaxSize = 100MB,
		FileGrowth = 10 MB),
	(Name = 'FatecBDVeryFiles-Data-1',
		FileName = 'C:\Bancos\Fatec\FatecBDVeryFiles-Data-1.MDF',
		Size = 20 MB,
		MaxSize = 200MB,
		FileGrowth = 20 MB),
	(Name = 'FatecBDVeryFiles-Data-2',
		FileName = 'C:\Bancos\Fatec\FatecBDVeryFiles-Data-2.MDF',
		Size = 40 MB,
		MaxSize = 400MB,
		FileGrowth = 40 MB),
	(Name = 'FatecBDVeryFiles-Data-3',
		FileName = 'C:\Bancos\Fatec\FatecBDVeryFiles-Data-3.MDF',
		Size = 60 MB,
		MaxSize = 600MB,
		FileGrowth = 6 MB)
Log On
	(Name = 'FatecBDTwoFiles-Log',
		FileName = 'C:\Bancos\Fatec\FatecBDTwoFiles-Log.LDF',
		Size = 100 MB,
		MaxSize = Unlimited,
		FileGrowth = 10%),
	(Name = 'FatecBDTwoFiles-Log-1',
		FileName = 'C:\Bancos\Fatec\FatecBDTwoFiles-Log-1.LDF',
		Size = 200 MB,
		MaxSize = 2048Mb,
		FileGrowth = 20%),
	(Name = 'FatecBDTwoFiles-Log-2',
		FileName = 'C:\Bancos\Fatec\FatecBDTwoFiles-Log-2.LDF',
		Size = 10 MB,
		MaxSize = 10Gb,
		FileGrowth = 5%)
Go

-- Exercício 4 - Criando um novo Banco de Dados com dois Filegroups --
Create Database FatecBDTwoFileGroups
On Primary
	(Name = 'FatecBDTwoFileGroups-Data',
		FileName = 'C:\Bancos\Fatec\FatecBDTwoFileGroups-Data.MDF',
		Size = 50 MB,
		MaxSize = 500MB,
		FileGrowth = 10 MB),
Filegroup Secundary
	(Name = 'FatecBDTwoFileGroups-Data-Secundary',
		FileName = 'C:\Bancos\Fatec\FatecBDTwoFileGroups-Data-Secundary.MDF',
		Size = 50 MB,
		MaxSize = 500MB,
		FileGrowth = 10 MB)
Log On
	(Name = 'FatecBDTwoFileGroups-Log',
		FileName = 'C:\Bancos\Fatec\FatecBDTwoFileGroups-Log.LDF',
		Size = 100 MB,
		MaxSize = Unlimited,
		FileGrowth = 10%)
Go

-- Exercício 5 - Estrutura do Banco de Dados, Arquivos, Filegroups e Logs --
Select * from Sys.sysfiles

Select * from sys.sysfilegroups

Select * from sys.sysaltfiles
Where name like 'FatecBDTwoFiles%'
