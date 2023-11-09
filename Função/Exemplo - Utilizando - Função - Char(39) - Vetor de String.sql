Create table #tabela (filial varchar(1000))

insert into #tabela
values ('01,02,03'),
('04,05,06')


declare @filial varchar(1000)
declare @sql varchar(8000)
set @filial = '01,02,03'

set @sql = 'select *
				from #tabela
			where filial in (' + char(39) + @filial + CHAR(39) + ')'

Print(@SQL)