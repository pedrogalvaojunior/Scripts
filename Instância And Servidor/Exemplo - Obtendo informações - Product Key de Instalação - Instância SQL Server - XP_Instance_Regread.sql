Declare @Val nvarchar(4000) 

Exec master .dbo.xp_instance_regread
    N'HKEY_LOCAL_MACHINE',
    N'Software\Microsoft\MSSQLServer\Setup',
    N'ProductCode', 
    @Val output

Select @Val As ProductCode
Go

