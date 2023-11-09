-- código #1
USE nomebanco;
go

CREATE or alter TRIGGER audit_CREATETABLE
  on DATABASE
  for CREATE_TABLE as
begin

set nocount on;

declare @Info_Evento xml;
set @Info_Evento= EVENTDATA();

INSERT into dbo.auditDATABASE (Nome_banco, Tipo_Evento, Nome_Objeto, Tipo_Objeto, Nome_Login)
  SELECT @Info_Evento.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'sysname'),
         @Info_Evento.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname'), 
         @Info_Evento.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname'), 
         @Info_Evento.value('(/EVENT_INSTANCE/ObjectType)[1]', 'sysname'), 
         @Info_Evento.value('(/EVENT_INSTANCE/LoginName)[1]', 'sysname');
end;
go

-- código #2
USE nomebanco;
go
CREATE TABLE dbo.auditDATABASE (
  Nome_banco sysname not null,
  Tipo_Evento sysname not null,
  Nome_Objeto sysname not null,
  Tipo_Objeto sysname not null,
  Data_Evento datetime2 not null  default sysdatetime(),
  Nome_Login sysname not null
);  