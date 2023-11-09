SELECT t.name, i.name, i.type_desc, c.name
FROM sys.tables t INNER JOIN sys.indexes i
			 	   ON t.object_id = i.object_id AND i.index_id = 1
			      INNER JOIN sys.index_columns ic
				   ON i.object_id = ic.object_id AND i.index_id = ic.index_id		      
				  INNER JOIN sys.columns c
				   ON ic.object_id = c.object_id AND ic.column_id = c.column_id
GO