Create a full partial backup

BACKUP DATABASE TestBackup READ_WRITE_FILEGROUPS
TO DISK = 'C:\TestBackup_Partial.BAK'
GO

Create a differential partial backup

BACKUP DATABASE TestBackup READ_WRITE_FILEGROUPS
TO DISK = 'C:\TestBackup_Partial.DIF'
WITH DIFFERENTIAL
GO