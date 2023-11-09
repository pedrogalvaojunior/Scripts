SELECT
    Employees.FirstName,
    Employees.LastName,
    Employees.Title,
    Employees.Country
FROM OPENDATASOURCE(
    'Microsoft.Jet.OLEDB.4.0',
    'Excel 8.0;DATABASE=C:\Documents and Settings\User\My Documents\Microsoft Press\SQLAppliedTechSBS\Chapter08\EmployeeList.xls')...[Employees$] AS Employees
WHERE LastName IS NOT NULL
ORDER BY Employees.Country DESC
