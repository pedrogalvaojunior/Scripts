CREATE TRIGGER MyTrigger ON dbo.MyTable
AFTER INSERT
AS

if exists ( select * from table t 
    inner join inserted i on i.name=t.name and i.date=t.date)
begin
    rollback
    RAISERROR ('Duplicate Data', 16, 1);
end
go