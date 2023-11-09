DECLARE @DateString CHAR(10)
SET @DateString = CONVERT(CHAR(10), DATEADD(d, -2, GETDATE()), 103)

EXECUTE master.dbo.xp_delete_file 0, 
                  N'E:\MSSQL2005-Backup\BaanModelEA',N'bak', @DateString, 1