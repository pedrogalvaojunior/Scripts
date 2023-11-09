Create Table #s(Start Datetime, [end] Datetime)

Insert Into #s
Select Cast('2010-04-08 12:00:00' As datetime),Cast('2010-04-08 14:10:00' As datetime) Union All
Select Cast('2010-04-08 13:00:00' As datetime),Cast('2010-04-08 14:00:00' As datetime) Union All
Select Cast('2010-04-08 15:45:00' As datetime),Cast('2010-04-08 16:00:00' As datetime) Union All
Select Cast('2010-04-08 15:00:00' As datetime),Cast('2010-04-08 18:00:00' As datetime)

Select Round(Cast(Sum(({fn Hour([end])}-{fn Hour(start)})) As decimal(4,2)) + 
            Cast(Sum({fn Minute([end])} - 
			{fn Minute( start)}) As decimal(4,2))/60,4) As 'Total Hrs' From #s


Select {fn Hour([end])}+{fn Hour(GetDate())},
            {fn Minute([end])},
			{fn Second([end])}   from #S