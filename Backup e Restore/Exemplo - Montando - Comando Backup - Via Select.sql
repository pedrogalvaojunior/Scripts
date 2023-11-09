select 'Backup Database '+sd.name + ' To Disk = '+'''D:\MSSQL2005-Backup\'+sd.name+'.Bak'+''' With Init, Stats = 10, Description = '+'''Backup para armazenamento e remoção - Database - '+sd.Name+''''+Char(13)+'Go'
from Sys.SysDatabases SD
where sd.dbid >=9
and sd.name like '%new%'