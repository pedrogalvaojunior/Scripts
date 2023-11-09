Select Object_Name(SSI.object_id) As 'Objeto Pai',
           SI.Name + 
		   Case SSI.Type
		    When 0 Then ' Heap'
			When 1 Then ' Clustered'
			When 2 Then ' NonClustered'
			When 3 Then ' XML'
			When 4 Then ' Espacial'
		  End As 'Descri��o',
		  SI.dpages As 'P�gs. por Dados Alocados em �ndices',
		  SI.used As 'P�gs por Tabela + �ndices alocadas',
		  SI.rows As Linhas,
		  Round(SIPS.avg_fragment_size_in_pages,2) 'M�dia do tamanho fragmenta��o por p�gina'
From sys.sysindexes SI Inner Join Sys.indexes SSI
									   On SI.Name = SSI.Name
									  Inner Join sys.dm_db_index_physical_stats(DB_ID('Aulas23092011'),Null,Null,Null, 'LIMITED') SIPS
									   On SSI.object_id = SIPS.object_id
Where SI.Name Is Not Null
And SIPS.avg_fragmentation_in_percent > 10.0 AND SIPS.index_id > 0
Order By [M�dia do tamanho fragmenta��o por p�gina] Desc
Go
