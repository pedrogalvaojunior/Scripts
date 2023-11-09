CREATE TRIGGER [Log_PasswordChange] 
   on ALL SERVER
   for ALTER_LOGIN
   as
begin
declare @objectName SYSNAME;
set @objectName= '';

set @objectName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','SYSNAME');

PRINT @objectName + ' alterado por ' + SUSER_SNAME();
end;
go