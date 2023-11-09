EXEC sp_addlinkedserver @server = 'SalesServer', 
    @srvproduct=N'SQL Server'
GO

DELETE SalesServer.SalesDB.Sales.Orders
WHERE Quarter = 3
--
--
EXEC sp_dropserver 'MyEmployees'
EXEC sp_addlinkedserver
    @server = 'MyEmployees',
    @srvproduct = 'Jet 4.0',
    @provider = 'Microsoft.Jet.OLEDB.4.0',
    @datasrc = 'C:\Documents and Settings\User\My Documents\Microsoft Press\SQLAppliedTechSBS\Chapter08\EmployeeList.xls',
    @provstr = 'Excel 8.0'
GO
UPDATE OPENQUERY(MyEmployees, 'SELECT * FROM [Employees$]')
SET LastName = 'Newname'
WHERE Region = 'CA'

