EXEC sp_addlinkedserver @server = N'Sales', 
@srvproduct='SQL Server'
GO
--
EXEC sp_addlinkedserver
    @server = 'MyEmployees',
    @srvproduct = 'Jet 4.0',
    @provider = 'Microsoft.Jet.OLEDB.4.0',
    @datasrc = 'C:\Documents and Settings\User\My Documents\Microsoft Press\SQLAppliedTechSBS\Chapter08\EmployeeList.xls',
    @provstr = 'Excel 8.0'
GO
--
EXEC sp_addlinkedserver 
   @server = 'NwindAccess', 
   @provider = 'Microsoft.Jet.OLEDB.4.0', 
   @srvproduct = 'OLE DB Provider for Jet',
   @datasrc = 'C:\Documents and Settings\User\My Documents\Microsoft Press\SQLAppliedTechSBS\Chapter08\Northwind.mdb'
GO
--
EXEC sp_addlinkedserver
   @server = 'PostSales',
   @srvproduct = 'Oracle',
   @provider = 'MSDAORA',
   @datasrc = 'PostSalesServer'
GO
--
SELECT *
FROM sys.servers
WHERE is_linked = 1
--
EXEC sp_dropserver 'MyEmployees'
GO
