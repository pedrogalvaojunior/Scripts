SELECT OrderInfo.OrderID, OrderInfo.CustomerID, OrderInfo.EmployeeID
FROM OPENROWSET(
  'Microsoft.Jet.OLEDB.4.0',
  'C:\Documents and Settings\User\My Documents\Microsoft Press\SQLAppliedTechSBS\Chapter08\Northwind.mdb'; 'Admin';'', 
  'SELECT OrderID, CustomerID, EmployeeID FROM Orders')
As OrderInfo
