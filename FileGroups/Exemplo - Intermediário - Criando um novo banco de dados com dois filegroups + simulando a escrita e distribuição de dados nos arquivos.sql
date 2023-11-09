-- Criando o Banco de Dados com Dois FileGroups --
Create Database FatecBDTwoFileGroups
On Primary
	(Name = 'FatecBDTwoFileGroups-Data',
		FileName = 'S:\Databases\DATA\FatecBDTwoFileGroups-Data.MDF',
		Size = 8 MB,
		MaxSize = 4GB,
		FileGrowth = 8 MB),
Filegroup Secondary Default -- Definindo o novo filegroup como default, deixa o primary para armazenar somente os objetos de sistema --
	(Name = 'FatecBDTwoFileGroups-Data-Secondary',
		FileName = 'S:\Databases\DATA\FatecBDTwoFileGroups-Data-Secondary.MDF',
		Size = 8 MB,
		MaxSize = 4GB,
		FileGrowth = 8 MB),
	(Name = 'FatecBDTwoFileGroups-Data-1-Secondary',
		FileName = 'S:\Databases\DATA\FatecBDTwoFileGroups-Data-1-Secondary.NDF',
		Size = 8 MB,
		MaxSize = 8192 MB,
		FileGrowth = 8 MB),
	(Name = 'FatecBDTwoFileGroups-Data-2-Secondary',
		FileName = 'S:\Databases\DATA\FatecBDTwoFileGroups-Data-2-Secondary.NDF',
		Size = 8 MB,
		MaxSize = 8192 MB,
		FileGrowth = 8 MB)
Log On
	(Name = 'FatecBDTwoFileGroups-Log-1-Secondary',
		FileName = 'S:\Databases\LOG\FatecBDTwoFileGroups-Log-1-Secondary.LDF',
		Size = 10 MB,
		MaxSize = Unlimited,
		FileGrowth = 100 MB)
Go

-- Acessando o Banco de Dados --
Use FatecBDTwoFileGroups
Go

-- Simulando a escrita e distribuição dos dados nos arquivos --
-- Criando a Tabela Jogadores --
Create Table Jogadores
(JogadorID Int Primary Key Identity(1,1),
 JogadorNome Varchar(30) Not Null,
 JogadorData DateTime Not Null)
Go

-- Identificando a relação de tabelas e filegroups --
Select o.[name], o.[type], 
             i.[name], i.[index_id],  
			 f.[name]
From sys.indexes i Inner Join sys.filegroups f
                                   On i.data_space_id = f.data_space_id
                                  Inner Join sys.all_objects o
                                   On i.[object_id] = o.[object_id]
Where i.data_space_id = f.data_space_id
And o.type In ('s','u') 
Go

-- Apresentando a lista de arquivos que formam o banco de dados - SQL Server 2008 ou superior --
Select file_id, type, type_desc, data_space_id, name, physical_name, state_desc, size, max_size, growth
From sys.database_files 
Go

-- Apresentando a lista de filegroups existentes no banco de dados --
Select * from sys.sysfilegroups 
Go

-- Simulando escrita em Log --
Declare @Contador Int -- Declarando a variável @Contador

Set @Contador=1 -- Atribuindo um valor inicial igual á 1 

While @Contador <=999999 -- Laço condicional 
 Begin
  Insert Into Jogadores Values ('Pedro',GetDate()+@Contador)

  Set @Contador=@Contador+1 -- Incrementando o valor da variável @Contador
 End
Go