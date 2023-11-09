-- Utilizando Quotename com aspas simples + Função String_AGG --
declare @ComandoSQL nvarchar(max)
set @ComandoSQL= space(0)

SELECT @ComandoSQL+=
       'INSERT into ' + quotename (T.name) + ' (' 
       + string_agg (quotename (C.name,''''), ', ') within group (order by C.column_id)
       + ')'+CHAR(13)+'SELECT ' 
       + string_agg (quotename (C.name), ', ') within group (order by C.column_id)
       + ' from BDorigem..' + quotename (T.name) 
       + '; ' + char(13)+char(10)
  from sys.tables as T
       inner join sys.columns as C on C.object_id = T.object_id
  group by T.name
  
PRINT @ComandoSQL
Go

-- Utilizando Quotename padrão colchetes + Função Stuff() --
declare @ComandoSQL nvarchar(max)
set @ComandoSQL= space(0)

SELECT @ComandoSQL+=
       'INSERT into ' + quotename (T.name) + ' (' 
       + stuff ((SELECT ', ' + quotename (C.name)
                   from sys.columns as C 
                   where C.object_id = T.object_id
                   order by C.column_id
                   for xml path(''), TYPE).value('.', 'varchar(max)'),
                1, 2, '') 
       + ')'+CHAR(13)+ 'SELECT ' 
       + stuff ((SELECT ', ' + quotename (C.name)
                   from sys.columns as C 
                   where C.object_id = T.object_id
                   order by C.column_id
                   for xml path(''), TYPE).value('.', 'varchar(max)'),
                1, 2, '') 
       + ' from BDorigem..' + quotename (T.name) 
       + '; '+ char(13)+char(10)
  from sys.tables as T;
  
PRINT @ComandoSQL
Go
