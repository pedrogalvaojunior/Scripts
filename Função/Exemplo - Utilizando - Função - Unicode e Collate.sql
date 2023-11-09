SELECT COUNT(*) AS Result 
FROM sys.databases d1 INNER JOIN sys.databases d2
                       ON UNICODE(CAST(d1.name AS VARCHAR(255)) COLLATE Latin1_General_CS_AS) = UNICODE(CAST(d2.name AS NVARCHAR(255)) COLLATE SQL_Latin1_General_CP850_BIN)
WHERE d1.database_id <= 4
AND d2.database_id <= 4;


Select UNICODE(CAST(d1.name AS VARCHAR(255))) from sys.databases d1