SELECT name FROM master..sysdatabases 
WHERE dbid > 4 AND (512 & status) <> 512