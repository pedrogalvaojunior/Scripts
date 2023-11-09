Create Database BufferCacheDatabase
Go

Use BufferCacheDatabase
Go

Create Table BufferCacheDatabaseTable
 (BufferID Int Identity Primary Key Clustered,
  BufferDescription Varchar(50) Default 'Buffer Table',
  BufferDateTime DateTime Default GetDate())
Go

Insert Into BufferCacheDatabaseTable Default Values
Go 1000

-- Sumarizado - Totais --
Select ST.Name As 'Tabela',
       SP.rows As 'Linhas',
	   SA.data_pages As 'P�ginas de Dados',
	   SA.used_pages As 'P�ginas de Dados Utilizadas',
	   SA.total_pages As 'Total de P�ginas de Dados'	   
from sys.tables ST Inner Join sys.partitions SP
                    On ST.object_id = SP.object_id
				   Inner Join sys.allocation_units SA
				    On SA.container_id = SP.partition_id
Go

-- Detalhado - Total de Linhas por P�ginas --
Select ST.Name As 'Tabela',
	   SB.page_id As 'Id P�gina',
	   SB.page_type As 'Tipo da P�gina',
	   SB.Row_Count As 'Linhas por P�gina',
   	   SB.free_space_in_bytes As 'Espa�o Livre em Bytes'
from sys.tables ST Inner Join sys.partitions SP
                    On ST.object_id = SP.object_id
				   Inner Join sys.allocation_units SA
				    On SA.container_id = SP.partition_id
				   Inner Join sys.dm_os_buffer_descriptors SB
				    On SB.allocation_unit_id = SA.allocation_unit_id
Order By SB.page_type Asc
Go

Select * from sys.partitions

Select * from sys.allocation_units

Select * from sys.data_spaces

Select * from sys.dm_os_buffer_descriptors

select * from Sys.system_internals_partitions

select * from Sys.system_internals_allocation_units 
