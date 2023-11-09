DECLARE @dbName varchar(30), @cmd varchar(1000), @Indice Int
 
DECLARE cur_SpaceUsed CURSOR FOR
 
SELECT name FROM SYSDATABASES
 
WHERE  name NOT IN ('master', 'msdb', 'model', 'tempdb')
 
and    status <> 66048
 
OPEN cur_SpaceUsed
 
FETCH NEXT FROM cur_SpaceUsed
 
INTO @dbName
 
WHILE @@FETCH_STATUS = 0
 
BEGIN
 
         SELECT @cmd =  'SET NOCOUNT ON' + char(10) +
 
         'USE ' + @dbName + '' + char(10) + 

         'Go' + char(10) + 

         'DECLARE @Indice Int' + char(10) +
 
         'SELECT @Indice = SUM(reserved) FROM ' + @dbName + 

'..SYSINDEXES WHERE indid IN (0, 1, 255)' + Char(10) +
 
         'SELECT CAST(name AS VARCHAR(30)) AS name, ''total mb'' = 

((size*8)/1024)
 
FROM sysfiles'
 

Print @cmd
 
 
 
FETCH NEXT FROM cur_SpaceUsed
 
INTO @dbName
 
END
 
CLOSE cur_SpaceUsed
 
DEALLOCATE cur_SpaceUsed
