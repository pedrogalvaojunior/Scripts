DECLARE @CaminhoLog Nvarchar(2000)
SELECT @CaminhoLog = convert(Nvarchar(max),value) from ::fn_trace_getinfo(0)
where property = 2
 
-- Identificando os eventos de criação e exclusão de tabelas --
SELECT SPID, LoginName, NTUserName, NTDomainName, HostName, ApplicationName, StartTime, ServerName, DatabaseName, 
  CASE EventClass
   WHEN 46 THEN 'CREATE'
   WHEN 47 THEN 'DROP'
   ELSE 'OTHER'
  END AS EventClass, 
  CASE ObjectType
   WHEN 8277 THEN 'User defined Table'
   ELSE 'OTHER'
  END AS ObjectType,
  ObjectID,
  ObjectName
FROM fn_trace_gettable (@CaminhoLog, Default)
Where EventSubClass = 1 /* Evento comitado */
And ObjectType = 8277 -- Id relacionado a eventos de tabela
ORDER BY StartTime
GO

