declare @x float, @y float

set @x = 3.65
set @y = 3.75

--What values are returned by the following statements?
select 'x = ' + str(@x,5,2) 
select 'y = ' + str(@y,10,1)