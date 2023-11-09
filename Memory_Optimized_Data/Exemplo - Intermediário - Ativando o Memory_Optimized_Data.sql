-- Acessando --
Use ProjetoDWQueimadas
Go

-- Adicionando um novo Filegroup para utilização com Memory_Optimized_Data --
Alter Database ProjetoDWQueimadas 
 Add FileGroup SecondaryWithMOD
 Contains Memory_Optimized_Data
Go

-- Adicionando um novo arquivo para utilização aplicada ao Memory_Optimized_Data --
Alter Database ProjetoDWQueimadas
 Add File (Name='ProjetoDWQueimadas-MOD', 
                 FileName='S:\MSSQL-2019\DATA\ProjetoDWQueimadas-MOD') 
 To FileGroup SecondaryWithMOD
Go

-- Atividando o Memory_Optimized_Elevate para o modo Snapshot --
Alter Database ProjetoDWQueimadas
 Set Memory_Optimized_Elevate_To_Snapshot = On
Go

-- Criando a Tabela Queimadas1999x2021Mod aplicada ao Memory_Optimized_Data com dados persistentes --
Create Table Queimadas1999x2021Mod
(CodigoQueimada int IDENTITY(1,1) Not Null Primary Key NonClustered,
  DataHora datetime Not Null,
  Satelite varchar(10) Not Null,
  Pais char(6) Not Null,
  Estado varchar(20) Not Null,
  Municipio varchar(40) Not Null,
  Bioma varchar(15) Not Null,
  DiaSemChuva int Not Null,
  Precipitacao float Not Null,
  RiscoFogo float Not Null,
  Latitude decimal(10, 5) Not Null,
  Longitude decimal(10, 5) Not Null,
  LongitudeAproximada  AS (round(Longitude,(2))),
  LatitudeAproximada  AS (round(Latitude,(2))))
With (Memory_Optimized=On) -- Aplicando a Persistência de Dados --
Go

-- Em alguns momentos será necessário alterar as configurações de memória para o Servidor, bem como, a memória mínima para a query --
-- Inserindo uma massa de dados --
Insert Into Queimadas1999x2021Mod ([DataHora], [Satelite], [Pais], [Estado], [Municipio], [Bioma], [DiaSemChuva], [Precipitacao], [RiscoFogo], [Latitude], [Longitude])
Select [DataHora], [Satelite], [Pais], [Estado], [Municipio], [Bioma], [DiaSemChuva], [Precipitacao], [RiscoFogo], [Latitude], [Longitude]
From Queimadas1999x2021
Where Year(DataHora) In (2019)
Go

-- Comparativo entre Tabela Tradicional x Tabela Memory_Optimized_Data --
-- Ativar Plano de Execução ou Live Query Statistics --
Select * From Queimadas1999x2021
Where Municipio Like '%Roque%'
And Year(DataHora) In(2000,2010,2020)
Order By DataHora
Go

Select * From Queimadas1999x2021Mod
Where Municipio Like '%Roque%'
And Year(DataHora) In(2000,2010,2020)
Order By DataHora
Go