SELECT
 

SUM(size) * 8 AS Tamanho FROM sys.databases DB
 
INNER
 

JOIN sys.master_files
 
ON
 

DB.database_id = sys.master_files.database_id


select name, sum(size)*8 from sys.master_files
where database_id >=5
group by name

select * from sys.master_files

--Sem CTE --
select smf.database_id,
       smf.name, 
       SizeDataFile=(Select (Sum(Size)* 8)/1024 from sys.master_files where database_id = smf.database_id and file_id In (1,3,4)),
       SizeLogFile=(Select (Sum(Size)* 8)/1024 from sys.master_files where database_id = smf.database_id and file_id=2)
from sys.master_files smf
WHERE  smf.database_ID >4 
And Type_desc='Rows'
Order By smf.Name Asc

--Utilizando CTE --
with databasesize (id, name, sizedatafile, sizelogfile)
As
(select Top 200 smf.database_id,
       smf.name, 
       SizeDataFile=(Select (Sum(Size)* 8)/1024 from sys.master_files where database_id = smf.database_id and file_id In (1,3,4)),
       SizeLogFile=(Select (Sum(Size)* 8)/1024 from sys.master_files where database_id = smf.database_id and file_id=2)
from sys.master_files smf
WHERE  smf.database_ID >4 
And Type_desc='Rows'
Order By smf.Name Asc
)
Select * from DatabaseSize