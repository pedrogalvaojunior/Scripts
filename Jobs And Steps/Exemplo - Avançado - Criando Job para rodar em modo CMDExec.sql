Alter PROCEDURE dbo.usp_ExecCmdShellProcess
AS  
    BEGIN 
        DECLARE @job NVARCHAR(100), @BulkCMD Varchar(1000)
        SET @job = 'xp_cmdshell replacement'+Convert(Varchar(10),GetDate()) ;  

		SET @BulkCMD = 'BULK INSERT ListFiles FROM '+'''C:\TEMP\LISTFILES.TXT'' '+
		'WITH (FIELDTERMINATOR = '';'', ROWTERMINATOR = '''+ CHAR(10) +''', CODEPAGE = ''ACP'')'

        EXEC msdb..sp_add_job @job_name = @job, 
            @description = 'Automated job to execute command shell script', 
            @owner_login_name = 'americas\saopgalv', @delete_level = 1 ;  

        EXEC msdb..sp_add_jobstep @job_name = @job, @step_id = 1, 
            @step_name = 'Command Shell Execution', @subsystem = 'CMDEXEC', 
            @command ='dir /b > C:\TEMP\LISTFILES.TXT', @on_success_action = 1;

        EXEC msdb..sp_add_jobserver @job_name = @job ;  

		EXEC msdb..sp_start_job @job_name = @job ;

        Exec(@Bulkcmd)
						
    END ; 
GO 
