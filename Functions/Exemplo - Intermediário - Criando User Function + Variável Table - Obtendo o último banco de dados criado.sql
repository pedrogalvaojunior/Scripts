create function fn_ret_last_created_db()
returns varchar(50)
as
begin
	declare @db_info varchar(50)

	declare @dbs table
	(	name varchar(30),
		created datetime)

	insert into @dbs
	select top 1 name,create_date 
	from sys.databases
	order by create_date desc

	select @db_info = db.name+' '+convert(varchar(20),db.created)
	from @dbs db
	return @db_info	
end

--test
create database new_test_db

select dbo.fn_ret_last_created_db()

drop database new_test_db