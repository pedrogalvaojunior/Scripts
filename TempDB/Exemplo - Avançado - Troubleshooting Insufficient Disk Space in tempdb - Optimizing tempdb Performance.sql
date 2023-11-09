/* Tempdb file size  FILEGROWTH increment 
0 to 100 MB        10 MB
100 to 200 MB   20 MB
200 MB or more 10%* 
* You may have to adjust this percentage based on the speed of the I/O subsystem 
on which the tempdb files are located. */

-- Viewing tempdb Size and Growth Parameters --
SELECT 
    name AS FileName, 
    size*1.0/128 AS FileSizeinMB,
    CASE max_size 
        WHEN 0 THEN 'Autogrowth is off.'
        WHEN -1 THEN 'Autogrowth is on.'
        ELSE 'Log file will grow to a maximum size of 2 TB.'
    END,
    growth AS 'GrowthValue',
    'GrowthIncrement' = 
        CASE
            WHEN growth = 0 THEN 'Size is fixed and will not grow.'
            WHEN growth > 0 AND is_percent_growth = 0 
                THEN 'Growth value is in 8-KB pages.'
            ELSE 'Growth value is a percentage.'
        END
FROM tempdb.sys.database_files
GO

-- Detecting Disk I/O Path Errors --
MSSQLSERVER_823, 
MSSQLSERVER_824, or 
MSSQLSERVER_825