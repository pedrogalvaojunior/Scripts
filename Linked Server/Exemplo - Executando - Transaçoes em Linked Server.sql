EXEC sp_addlinkedserver @server = 'SalesServer', 
    @srvproduct='SQL Server'
GO

EXECUTE ('CalculateCommissions') AT SalesServer
