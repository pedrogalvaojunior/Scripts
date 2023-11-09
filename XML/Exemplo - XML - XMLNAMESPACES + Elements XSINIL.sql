
WITH XMLNAMESPACES ('uri' as g)
SELECT
       dbid as 'g:ID', 
       name      as 'g:NOME'
FROM sys.sysdatabases
FOR XML RAW('item'), ROOT('xml'), ELEMENTS XSINIL
