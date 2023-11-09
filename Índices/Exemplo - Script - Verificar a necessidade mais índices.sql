SELECT
	equality_columns  ,
	inequality_columns,
	included_columns  ,
	REPLACE (REPLACE (REPLACE (STATEMENT, ']', ''), '[', ''), DB_NAME (a.database_id) + '.DBO.', '') STATEMENT,
	avg_total_user_cost * avg_user_impact * (user_seeks + user_scans) COST,
	avg_total_user_cost, avg_user_impact, user_seeks, user_scans, unique_compiles,
	STATEMENT,
	'CREATE NONCLUSTERED INDEX IDX_' + 
	REPLACE (REPLACE (REPLACE (STATEMENT, ']', ''), '[', ''), DB_NAME (a.database_id) + '.DBO.', '') + 
	'_ ON ' + REPLACE (REPLACE (REPLACE (STATEMENT, ']', ''), '[', ''), DB_NAME (a.database_id) + '.DBO.', '') + ' (' + 
	ISNULL (equality_columns, '') +
	ISNULL (CASE WHEN equality_columns IS NOT NULL THEN ', ' ELSE '' END + inequality_columns, '') + 
	') ' + 
	ISNULL ('INCLUDE (' + included_columns + ')', '') SCRIPT
FROM
	sys.dm_db_missing_index_details a
	INNER JOIN sys.dm_db_missing_index_groups b
	ON
		a.index_handle = b.index_handle
	INNER JOIN sys.dm_db_missing_index_group_stats c
	ON
		b.index_group_handle = group_handle
WHERE
	a.database_id = db_id()
ORDER BY
	unique_compiles DESC