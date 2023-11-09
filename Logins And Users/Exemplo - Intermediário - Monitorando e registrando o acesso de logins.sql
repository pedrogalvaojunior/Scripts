USE master;
CREATE TABLE Ultimo_Login (
   [LoginName] sysname primary key,
   Data_conexao datetime,
   Evento xml
);

USE master
Go

CREATE TRIGGER [Monitora_Login] 
   on ALL SERVER  with execute as '____'
   after LOGON    
   as
begin
declare @Evento XML, @LoginName sysname, @Data_conexao datetime;
set @Evento= Eventdata();
set @LoginName= @Evento.value ('(/EVENT_INSTANCE/LoginName)[1]','sysname');
set @Data_conexao= @Evento.value ('(/EVENT_INSTANCE/PostTime)[1]','datetime');

IF exists (SELECT * from master..Ultimo_Login where [LoginName] = @LoginName)
  UPDATE master..Ultimo_Login
    set Data_conexao= @Data_conexao,
        Evento= @Evento
    where [LoginName] = @LoginName
else
  INSERT into master..Ultimo_Login ([LoginName], Data_conexao, Evento)
      values (@LoginName, @Data_conexao, @Evento);

end;
go

declare @3meses datetime;
set @3meses= dateadd (month, -3, cast(current_timestamp as date));

SELECT P.name, P.type_desc, P.create_date, UL.Data_conexao
  from sys.server_principals as P
       left join master..Ultimo_Login as UL on UL.[LoginName] = P.name
  where P.is_disabled <> 1
        and P.type in ('S', 'U')
        and P.create_date < @3meses
        and (UL.[LoginName] is null or UL.Data_conexao < @3meses)
  order by P.name;