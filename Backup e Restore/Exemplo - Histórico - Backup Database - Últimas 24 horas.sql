SELECT CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
             msdb.dbo.backupset.database_name, 
             MAX(msdb.dbo.backupset.backup_finish_date) AS last_db_backup_date, 
             DATEDIFF(hh, MAX(msdb.dbo.backupset.backup_finish_date), GETDATE()) AS [Backup Age (Hours)] 
FROM msdb.dbo.backupset 
WHERE msdb.dbo.backupset.type = 'D'  
GROUP BY msdb.dbo.backupset.database_name 
HAVING (MAX(msdb.dbo.backupset.backup_finish_date) < DATEADD(hh, - 24, GETDATE()))