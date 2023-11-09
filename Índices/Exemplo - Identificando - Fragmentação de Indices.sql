SELECT object_name(i.object_id) as object_name ,i.name as IndexName 
		,ps.avg_fragmentation_in_percent
		,avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL , 'DETAILED') as ps
INNER JOIN sys.indexes as i
ON i.object_id = ps.object_id
	AND i.index_id = ps.index_id
WHERE ps.avg_fragmentation_in_percent > 50
AND ps.index_id > 0
ORDER BY 1

ALTER INDEX PK_Employee_EmployeeID
ON HumanResources.Employee
REBUILD
WITH (ONLINE = ON)

