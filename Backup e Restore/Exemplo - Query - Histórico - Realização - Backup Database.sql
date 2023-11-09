DECLARE @db_name VARCHAR(100)
SELECT @db_name = DB_NAME()

-- Get Backup History for required database

SELECT TOP ( 30 )
s.database_name,
m.physical_device_name,
cast(CAST(s.backup_size / 1000000 AS INT) as varchar(14))
+ ' ' + 'MB' as bkSize,
CAST(DATEDIFF(second, s.backup_start_date,
s.backup_finish_date) AS VARCHAR(4)) + ' '
+ 'Seconds' TimeTaken,
s.backup_start_date,
CAST(s.first_lsn AS varchar(50)) AS first_lsn,
CAST(s.last_lsn AS varchar(50)) AS last_lsn,
CASE s.[type]
WHEN 'D' THEN 'Full'
WHEN 'I' THEN 'Differential'
WHEN 'L' THEN 'Transaction Log'
END as BackupType,
s.server_name,
s.recovery_model
FROM msdb.dbo.backupset s
inner join msdb.dbo.backupmediafamily m ON s.media_set_id = m.media_set_id
WHERE s.database_name = @db_name
ORDER BY backup_start_date desc,
backup_finish_date