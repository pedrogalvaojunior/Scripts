Create table #tabelas (Tabela varchar(800))
Create table #Coluna (Coluna varchar(800))
Create table #temp (Tabela varchar(800), Coluna varchar(800))

-- Inserindo todas as tabelas que existem na base em uma temporaria
insert into #tabelas
select name from sys.sysobjects where xtype = 'U'

-- Rodar daqui até o final
declare @String varchar(100) 
declare @tabela varchar(800)
declare @coluna varchar(800)
Declare @sql varchar(800)

-- valor que voce quer encontrar
set @String = 'Log'

While (select COUNT(*) from #tabelas) > 0
begin

set @tabela = (select top 1 tabela from #tabelas)
select @tabela
insert into #Coluna
select 
	SC.name 
		from sys.syscolumns as SC
		inner join sys.sysobjects as SO on SC.id = SO.id
where SO.name = @tabela

set @coluna = (select top 1 Coluna from #Coluna)
While (select count(*) from #Coluna) > 0
begin
set @coluna = (select top 1 Coluna from #Coluna)
select @coluna
set @sql = 'IF (select COUNT(*) from ' + @tabela + ' where ' + @coluna + ' like ' + char(39) + '%'+ @string + '%'+ char(39)  +') > 0
begin
insert into #temp
select ' + Char(39) + @tabela + char(39) + ','+ Char(39) + @coluna + CHAR(39) +
' end'

exec(@SQL)

delete from #Coluna
where Coluna = @coluna

end

delete from #tabelas
where Tabela = @tabela

end

select * from #temp