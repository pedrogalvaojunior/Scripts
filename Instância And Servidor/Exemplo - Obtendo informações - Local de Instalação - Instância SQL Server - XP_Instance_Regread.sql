DECLARE @Local varchar(8000) 
EXEC master.dbo.xp_instance_regread
    N'HKEY_LOCAL_MACHINE',
    N'Software\Microsoft\MSSQLServer\Setup',
    N'SQLPath', 
    @Local output

SELECT @Local
GO