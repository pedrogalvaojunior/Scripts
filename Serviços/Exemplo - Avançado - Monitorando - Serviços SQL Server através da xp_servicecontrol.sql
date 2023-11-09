Set NoCount On

CREATE TABLE #ServicesStatus
( 
myid int identity(1,1),
serverName nvarchar(100) default @@serverName,
serviceName varchar(100),
Status varchar(50),
checkdatetime datetime default (getdate())
)
INSERT #ServicesStatus (Status)
EXEC xp_servicecontrol N'QUERYSTATE',N'MSSQLServer'
update #ServicesStatus set serviceName = 'MSSQLServer' where myid = @@identity

INSERT #ServicesStatus (Status)
EXEC xp_servicecontrol N'QUERYSTATE',N'SQLServerAGENT'
update #ServicesStatus set serviceName = 'SQLServerAGENT' where myid = @@identity

INSERT #ServicesStatus (Status)
EXEC xp_servicecontrol N'QUERYSTATE',N'msdtc';
update #ServicesStatus set serviceName = 'msdtc' where myid = @@identity;

INSERT #ServicesStatus (Status)
EXEC xp_servicecontrol N'QUERYSTATE',N'sqlbrowser'
update #ServicesStatus set serviceName = 'sqlbrowser' where myid = @@identity

select * from #ServicesStatus 
