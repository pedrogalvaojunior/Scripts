if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CreateDataLoadScript]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CreateDataLoadScript]
GO

Create Procedure sp_CreateDataLoadScript
@TblName varchar(128)
as
/*
exec sp_CreateDataLoadScript 'MyTable'
*/


create table #a (id int identity (1,1), ColType int, ColName varchar(128))

insert #a (ColType, ColName)
select case when DATA_TYPE like '%char%' then 1 else 0 end ,
COLUMN_NAME
from information_schema.columns
where TABLE_NAME = @TblName
order by ORDINAL_POSITION

if not exists (select * from #a)
begin
raiserror('No columns found for table %s', 16,-1, @TblName)
return
end

declare	@id int ,
@maxid int ,
@cmd1 varchar(7000) ,
@cmd2 varchar(7000)

select @id = 0 ,
@maxid = max(id)
from #a

select	@cmd1 = 'select '' insert ' + @TblName + ' ( '
select	@cmd2 = ' + '' select '' + '
while @id < @maxid
begin
select @id = min(id) from #a where id > @id

select @cmd1 = @cmd1 + ColName + ','
from	#a
where	id = @id

select @cmd2 = @cmd2
+ ' case when ' + ColName + ' is null '
+	' then ''null'' '
+	' else '
+	  case when ColType = 1 then  ''''''''' + ' + ColName + ' + ''''''''' else 'convert(varchar(20),' + ColName + ')' end
+ ' end + '','' + '
from	#a
where	id = @id
end


select @cmd1 = left(@cmd1,len(@cmd1)-1) + ' ) '' '
select @cmd2 = left(@cmd2,len(@cmd2)-8) + ' from ' + @tblName

select '/*' + @cmd1 + @cmd2 + '*/'

exec (@cmd1 + @cmd2)
drop table #a

go