--Finding growth of database files
SELECT
 rtrim(sd.name) as DBName,
 rtrim(saf.name) AS FileName,
 rtrim(saf.filename) FilePath,
 saf.size*1.0/128 AS FileSizeinMB,
 CASE saf.maxsize
 WHEN 0 THEN 'Autogrowth is off.'
 WHEN -1 THEN 'Autogrowth is on.'
 ELSE 'Log file will grow to a maximum size of 2 TB.'
 END AutogrowthStatus,
 saf.growth AS 'GrowthValue',
 'GrowthIncrement' =
 CASE
 WHEN saf.growth = 0 THEN 'Size is fixed and will not grow.'
 WHEN saf.growth > 0 THEN 'Growth value is in 8-KB pages.'
 ELSE 'Growth value is a percentage.'
 END
 FROM master..sysaltfiles saf, master..sysdatabases sd
 WHERE saf.dbid = sd.dbid
-- and saf.dbid = 2 
GO