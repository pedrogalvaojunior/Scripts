sp_configure

sp_configure 'ad hoc distributed queries',1
reconfigure with override
go

EXEC sp_addlinkedserver 

@server = N'ETEC-SR', 

@srvproduct=N'Access', 

@provider=N'MSDASQL', 

@datasrc=N'ETEC', --Name of DSN from odbc 64 administrator

@provstr=N'MSDASQL', 

@catalog=N'C:\Users\Junior Galvão\Desktop\ETEC\Events.accdb'; --pathname to accdb file


EXEC sp_addlinkedserver 

@server = N'MYLINKEDSERVER2', 

@provider = N'Microsoft.ACE.OLEDB.12.0', 

@srvproduct = N'OLE DB Provider for ACE',

@provstr=N'Microsoft.ACE.OLEDB.12.0',

@catalog=N'C:\Users\Junior Galvão\Desktop\ETEC\Events.accdb', --pathname to accdb file

@datasrc = N'C:\Users\Junior Galvão\Desktop\ETEC\Events.accdb';

GO


SELECT * FROM MYLINKEDSERVER2.[C:\Users\Junior Galvão\Desktop\ETEC\Events.accdb]..Events