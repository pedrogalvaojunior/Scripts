Select t.Name As 'Nome da Tabela',
           si.name As 'Nome do Índice',
           si.type_desc As 'Tipo do Índice',
           sIc.key_ordinal As 'Ordinal Coluna',
           c.name As 'Nome da Coluna',
           ty.name As 'Tipo da Coluna',
	       six.rows As 'Total de Linhas inseridas',
	       six.reserved As 'Páginas de dados reservadas',
	       six.used As 'Páginas de dados usadas',
	       six.dpages As 'Páginas de dados preparado para uso',
	      Case sic.is_descending_key
	       When 0 Then 'ASC'
		   When 1 Then 'DESC'
	      End As 'Tipo da Ordenação'
From sys.indexes si Inner Join sys.tables t 
                                 On t.object_id = si.object_id
                                Inner Join sys.index_columns sic 
								 On sic.object_id = si.object_id AND sic.index_id = si.index_id
                                Inner Join sys.columns c 
								 On c.object_id = sic.object_id AND c.column_id = sic.column_id
                                Inner Join sys.types ty 
							     On c.system_type_id = ty.system_type_id
								Inner Join sys.sysindexes six
								 On six.name = si.name
Where t.name = 'HeapTableAlunos' 
Order By t.Name, si.name, sic.key_ordinal
Go
