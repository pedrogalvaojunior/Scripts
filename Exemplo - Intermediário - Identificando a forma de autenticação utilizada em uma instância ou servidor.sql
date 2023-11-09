-- Exemplo 1 -- Consultando dados do registro do Windows --
EXEC master.dbo.xp_instance_regread 
    N'HKEY_LOCAL_MACHINE', 
    N'Software\Microsoft\MSSQLServer\MSSQLServer',   
    N'LoginMode', 
    @AuthenticationMode OUTPUT
Go
 
SELECT 
    CASE @AuthenticationMode    
        WHEN 1 THEN 'Windows Authentication'   
        WHEN 2 THEN 'Windows and SQL Server Authentication'   
        ELSE 'Unknown'  
    END AS [Authentication Mode]
Go 

-- Exemplo 2 -- Utilizando a função de sistema ServerProperty --
SELECT CASE SERVERPROPERTY('IsIntegratedSecurityOnly')   
             WHEN 1 THEN 'Windows Authentication'   
             WHEN 0 THEN 'Windows and SQL Server Authentication'  
       END as [Authentication Mode] 
Go