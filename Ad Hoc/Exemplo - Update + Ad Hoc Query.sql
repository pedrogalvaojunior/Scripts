INSERT OPENROWSET(
    'Microsoft.Jet.OLEDB.4.0',
    'Excel 8.0;DATABASE=C:\Documents and Settings\User\My Documents\Microsoft Press\SQLAppliedTechSBS\Chapter08\EmployeeList.xls',
    'SELECT FirstName, LastName, Title, Region FROM [Employees$]')
VALUES ('John', 
        'Doe', 
        'Consultant', 
        'CA')
--
-- INSERT into a remote SQL Server database
INSERT OPENROWSET(
    'SQLOLEDB',
    'Server=Sales; Trusted_Connection=yes;', 
    'SalesDB.Sales.Orders')
VALUES (175642, '2001-10-04', 6500.05)
GO
--
--
INSERT OPENDATASOURCE(
    'Microsoft.Jet.OLEDB.4.0',
    'Excel 8.0;DATABASE=C:\Documents and Settings\User\My Documents\Microsoft Press\SQLAppliedTechSBS\Chapter08\EmployeeList.xls')...[Employees$]
VALUES ('99',
        'Doe',
        'John',
        'Tester',
        'Mr.',
        '12/06/1964',
        '5/1/1995',
        '507 20th Ave. S.',
        'Seattle',
		'WA',
        '98122',
        'USA',
        '(206) 555-9857',
        '5467',
        'testing',
        '2')



