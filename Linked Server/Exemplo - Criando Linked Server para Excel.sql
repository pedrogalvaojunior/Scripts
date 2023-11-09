EXEC sp_addlinkedserver @server = 'SalesServer', 
    @srvproduct='SQL Server'
GO

SELECT CustomerID, Date, Amount
FROM SalesServer.SalesDB.Sales.Orders
WHERE Quarter = @Quarter
--
EXEC sp_addlinkedserver
    @server = 'MyEmployees',
    @srvproduct = 'Jet 4.0',
    @provider = 'Microsoft.Jet.OLEDB.4.0',
    @datasrc = 'C:\Documents and Settings\User\My Documents\Microsoft Press\SQLAppliedTechSBS\Chapter08\EmployeeList.xls',
    @provstr = 'Excel 8.0'
GO
SELECT * FROM MyEmployees...Employees$
