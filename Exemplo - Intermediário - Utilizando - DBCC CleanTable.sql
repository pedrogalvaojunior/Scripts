Create Database TesteDBCCCleanTable
Go

Use TesteDBCCCleanTable
Go

Create Table dbo.QueimadasCleanTable
(	CodigoQueimada int IDENTITY(1,1) NOT NULL,
	DataHora datetime NOT NULL,
	Satelite varchar(10) NOT NULL,
	Pais char(6) NOT NULL,
	Estado varchar(20) NOT NULL,
	Municipio varchar(40) NOT NULL,
	Bioma varchar(15) NOT NULL,
	DiaSemChuva int NOT NULL,
	Precipitacao varchar(50) NULL,
	RiscoFogo float NOT NULL,
	Latitude decimal(10, 5) NOT NULL,
	Longitude decimal(10, 5) NOT NULL,
	AreaIndu varchar(50) NULL,
	FRP varchar(50) NULL
 CONSTRAINT [PK_CodigoQueimada_Queimadas2018_CleanTable] PRIMARY KEY CLUSTERED 
(
	[CodigoQueimada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


Insert Into QueimadasCleanTable ([DataHora], [Satelite], [Pais], [Estado], [Municipio], [Bioma], [DiaSemChuva], [Precipitacao], [RiscoFogo], [Latitude], [Longitude], [AreaIndu], [FRP])
Select [DataHora], [Satelite], [Pais], [Estado], [Municipio], [Bioma], [DiaSemChuva], [Precipitacao], [RiscoFogo], [Latitude], [Longitude], [AreaIndu], [FRP] 
From ProjetoDWQueimadas.dbo.Queimadas2018
Go

sp_spaceused 'QueimadasCleanTable'
Go

Select object_name(ddips.object_id) As 'Tabela', 
       si.name As 'Índice', 
       convert(decimal(5,2),isnull(ddips.avg_fragmentation_in_percent,0)) As '% Média de Fragmentação', 
       convert(decimal(5,2),isnull(ddips.avg_page_space_used_in_percent,0)) As '% Média de Espaço utilizado', 
	   ddips.page_count As 'Páginas', 
       ddips.compressed_page_count As 'Páginas compactadas', 
       ddips.record_count As 'Registros', 
       ddips.ghost_record_count As 'Registros Fantasmas' 
From sys.dm_db_index_physical_stats(db_id(), object_id('QueimadasCleanTable'),null, null, 'detailed') ddips Inner Join sys.indexes si 
      on si.object_id = ddips.object_id 
--Where ddips.avg_fragmentation_in_percent > 0 
Go

EXEC sp_columns @table_name = 'QueimadasCleanTable'
Go

Select st.name As 'TableName', 
       sc.name As 'ColumnName', 
	   sc.column_id As 'ColumnID',
	   sty.name As 'DataType',
	   sc.max_length As 'MaxLength'
from sys.tables st Inner Join sys.columns sc
                    on st.object_id = sc.object_id
				   Inner Join sys.systypes sty
				    on sc.system_type_id = sty.xtype
Where st.name = 'QueimadasCleanTable'
And sty.name = 'VarChar'
Order By st.Name Asc, sc.column_id Asc
Go


Alter Table QueimadasCleanTable
Drop Column Municipio, Bioma, AreaIndu, FRP
Go

Dbcc CleanTable(TesteDBCCCleanTable,'dbo.QueimadasCleanTable')
Go

sp_spaceused 'QueimadasCleanTable'
Go

Select object_name(ddips.object_id) As 'Tabela', 
       si.name As 'Índice', 
       convert(decimal(5,2),isnull(ddips.avg_fragmentation_in_percent,0)) As '% Média de Fragmentação', 
       convert(decimal(5,2),isnull(ddips.avg_page_space_used_in_percent,0)) As '% Média de Espaço utilizado', 
	   ddips.page_count As 'Páginas', 
       ddips.compressed_page_count As 'Páginas compactadas', 
       ddips.record_count As 'Registros', 
       ddips.ghost_record_count As 'Registros Fantasmas' 
From sys.dm_db_index_physical_stats(db_id(), object_id('QueimadasCleanTable'),null, null, 'detailed') ddips Inner Join sys.indexes si 
      on si.object_id = ddips.object_id 
--Where ddips.avg_fragmentation_in_percent > 0 
Go

Truncate Table QueimadasCleanTable
Go

Delete From QueimadasCleanTable
Go

sp_spaceused 'QueimadasCleanTable'
Go

Select object_name(ddips.object_id) As 'Tabela', 
       si.name As 'Índice', 
       convert(decimal(5,2),isnull(ddips.avg_fragmentation_in_percent,0)) As '% Média de Fragmentação', 
       convert(decimal(5,2),isnull(ddips.avg_page_space_used_in_percent,0)) As '% Média de Espaço utilizado', 
	   ddips.page_count As 'Páginas', 
       ddips.compressed_page_count As 'Páginas compactadas', 
       ddips.record_count As 'Registros', 
       ddips.ghost_record_count As 'Registros Fantasmas' 
From sys.dm_db_index_physical_stats(db_id(), object_id('QueimadasCleanTable'),null, null, 'detailed') ddips Inner Join sys.indexes si 
      on si.object_id = ddips.object_id 
--Where ddips.avg_fragmentation_in_percent > 0 
Go