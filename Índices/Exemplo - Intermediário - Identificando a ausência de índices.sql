SELECT avg_total_user_cost, avg_user_impact,  user_seeks, user_scans,  ID.equality_columns, 
             ID.inequality_columns, ID.included_columns, ID.statement
FROM sys.dm_db_missing_index_group_stats GS LEFT OUTER JOIN sys.dm_db_missing_index_groups IG 
                                                                                    On (IG.index_group_handle = GS.group_handle)
																				LEFT OUTER JOIN sys.dm_db_missing_index_details ID 
																				On (ID.index_handle = IG.index_handle) 
Where ID.database_id = DB_ID('CycleCount')
ORDER BY avg_total_user_cost * avg_user_impact * (user_seeks + user_scans)DESC


select * from sys.dm_db_missing_index_details
select * from sys.dm_db_missing_index_group_stats
select * from sys.dm_db_missing_index_groups