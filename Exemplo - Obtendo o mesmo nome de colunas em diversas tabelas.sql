create table t1
 (codigo int)

create table t2
 (codigo int) 

-- Consultando através do relacionamento entre sys.tables e sys.columns --
select name from sys.tables
where object_id in (select object_id from sys.columns where name = 'codigo')

-- Consultando através do relacionamento entre sys.tables e sys.syscolumns --
select name from sys.tables
where object_id in (select id from sys.syscolumns where name = 'codigo')