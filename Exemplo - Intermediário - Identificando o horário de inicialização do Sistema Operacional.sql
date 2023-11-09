DECLARE @dtComputerStart DATETIME,
        @bUse1 INT = 5550

SELECT @dtComputerStart = DATEADD(SECOND, ((((ms_ticks) % 65536000) / 1000) * -1), GETDATE()) FROM sys.dm_os_sys_info
SELECT DATEADD(SECOND, @bUse1, @dtComputerStart) AS DtLastAccess
GO