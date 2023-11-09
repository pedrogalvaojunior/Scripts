-- Exemplo 1 - Sumarizado --
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

-- Exemplo 2 - Detalhada --
Select ST.Name As 'Tabela',
       SP.rows As 'Linhas',
	   SA.data_pages As 'P�ginas de Dados',
	   SA.used_pages As 'P�ginas de Dados Utilizadas',
	   SA.total_pages As 'Total de P�ginas de Dados',	   
	   SB.Row_Count
from sys.tables ST Inner Join sys.partitions SP
                    On ST.object_id = SP.object_id
				   Inner Join sys.allocation_units SA
				    On SA.container_id = SP.partition_id
				   Inner Join sys.dm_os_buffer_descriptors SB
				    On SB.allocation_unit_id = SA.allocation_unit_id
Go

-- Exemplo 3 - Mais Detalhada --
Select ST.Name As 'Tabela',
       SP.rows As 'Linhas',
	   SB.free_space_in_bytes As 'Espa�o Livre em Bytes',
	   SB.page_id As 'Identificador da P�gina',
	   SB.page_type As 'Tipo da P�gina',
	   SB.Row_Count As 'Total de Linhas por P�gina'
from sys.tables ST Inner Join sys.partitions SP
                    On ST.object_id = SP.object_id
				   Inner Join sys.allocation_units SA
				    On SA.container_id = SP.partition_id
				   Inner Join sys.dm_os_buffer_descriptors SB
				    On SB.allocation_unit_id = SA.allocation_unit_id
Go