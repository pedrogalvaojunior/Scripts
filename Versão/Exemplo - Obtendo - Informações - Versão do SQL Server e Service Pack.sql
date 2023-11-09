SELECT 	@@servername 'Server Name',
	substring(@@version,1,charindex('-',@@version)-1)
	+convert(varchar(100),SERVERPROPERTY('edition'))+ ' '+
	+convert(varchar(100),SERVERPROPERTY('productlevel'))'Server Version'