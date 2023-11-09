ALTER DATABASE AdventureWorks
SET RECOVERY SIMPLE;
--Perform Full Database Backup
BACKUP DATABASE AdventureWorks
TO DISK = 'T:\BACKUPS\ADVFULL.BAK'
WITH INIT;
--Perform a differential Backup
BACKUP DATABASE AdventureWorks
TO DISK = 'T:\BACKUPS\ADVDIFF.BAK'
WITH INIT,Differential;
--
USE msdb
GO
SELECT backup_start_date,type, physical_device_name,backup_set_id 
FROM backupset bs inner join backupmediafamily bm
ON bs.media_set_id = bm.media_set_id
WHERE database_name ='AdventureWorks'
ORDER BY backup_start_date desc

--

SELECT filegroup_name,logical_name,physical_name 
FROM msdb..backupfile
WHERE backup_set_id = 8 --change to your backup_set_id

--

RESTORE HEADERONLY FROM DISK='T:\BACKUPS\ADVFULL.BAK'

--

RESTORE HEADERONLY FROM DISK='T:\BACKUPS\ADVFULL.BAK'