Select DB_NAME() AS [DatabaseName], Name, file_id, physical_name,
    (size * 8.0/1024) as Size,
    ((size * 8.0/1024) - (FILEPROPERTY(name, 'SpaceUsed') * 8.0/1024)) As FreeSpace
    From sys.database_files
Go