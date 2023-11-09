EXEC sp_addlinkedserver 
   @server = 'BigSolo', 
   @provider = 'Microsoft.Jet.OLEDB.4.0', 
   @srvproduct = 'OLE DB Provider for Jet',
   @datasrc = 'C:\Big-Solo.mdb'
GO


Select * from [BigSolo]...Produto