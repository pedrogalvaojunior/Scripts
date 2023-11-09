SET NOCOUNT ON
 DECLARE @tablename NVARCHAR(128)
 DECLARE @RC INT
 DECLARE curTable CURSOR FOR
 SELECT [name] AS tbl
 FROM sys.tables
 OPEN curTable
 FETCH NEXT FROM curTable
 INTO @tablename
 WHILE @@FETCH_STATUS = 0
 BEGIN
 EXECUTE @RC = dbo.sp_MSunmarkreplinfo @tablename
 FETCH NEXT FROM curTable
 INTO @tablename
 END
 CLOSE curTable
 DEALLOCATE curTable
 GO
 