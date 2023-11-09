if 1=0 
 begin 
    declare @word varchar(100) = 'apple' 
    declare @table table(id int)
    select @word 
 end
else
 begin 
    select @word 
    set @word = 'pear' 
    select @word 
    select COUNT(*) from @table
 end