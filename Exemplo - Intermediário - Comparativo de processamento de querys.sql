Set Statistics Time On
Go

-- Query 1 --
select count(*) from sales.SalesOrderDetail

-- Query 2 --
Select Convert(bigint, [rows])
from sys.sysindexes
where id = object_id('Sales.SalesOrderDetail')
And indid < 2

-- Query 3 --
Select cast(p.[rows] as float)
from sys.tables as tbl 
   inner join sys.indexes as idx
    on idx.object_id = tbl.object_id
	 and idx.index_id < 2
   inner join sys.partitions as p
    on p.object_id = cast(tbl.object_id as int)
	and p.index_id = idx.index_id
Where ((tbl.name = N'SalesOrderDetail' And SCHEMA_NAME(tbl.schema_id) = 'Sales'));

-- Query 4 --
Select Sum(row_count) from sys.dm_db_partition_stats
where object_id = OBJECT_ID('Sales.SalesOrderDetail')
and (index_id = 0 or index_id = 1)
