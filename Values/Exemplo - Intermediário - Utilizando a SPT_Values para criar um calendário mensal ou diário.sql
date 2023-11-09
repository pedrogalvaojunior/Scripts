-- show all the days in the current month

Select dateadd(month,datediff(month,0,getdate()),0) + number
from master..spt_values n with (nolock)
where number between 0 and day(dateadd(month,datediff(month,-1,getdate()),0) - 1) -1 and type = 'p'

-- show all the hours in the current day

Select dateadd(hour,number,dateadd(day,datediff(day,0,getdate()),0))
from master..spt_values n with (nolock)
where number between 0 and 23 and type = 'p'