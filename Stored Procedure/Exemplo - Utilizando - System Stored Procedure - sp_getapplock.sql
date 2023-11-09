use tempdb
print 'session_id='+Convert(Varchar(30),@@SPID)

exec dbo.critical_section_worker '00:00:10'