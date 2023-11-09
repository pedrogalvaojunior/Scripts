declare @Path varchar(128), @FileName varchar(128)

select @Path = 'C:\' , @FileName = 'myfile.txt'

declare @i int
declare @File varchar(1000)

select @File = @Path + @FileName
exec master..xp_fileexist @File, @i out

if @i = 1
print 'exists'
else
print 'not exists'