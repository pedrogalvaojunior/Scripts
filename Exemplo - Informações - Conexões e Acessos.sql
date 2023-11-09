-- Quantidade de Conex�es Simult�neas --
SELECT status, 
       client_net_address as [IP do cliente],
        p.hostname as [Nome da m�quina do cliente],
        [text] as [Texto da consulta], 
        SPID,
        DB_NAME(p.dbid) as [Nome do BD no qual foi executada a query],
        p.[program_name] as [Programa solicitante]
FROM sys.dm_exec_connections c INNER JOIN sys.sysprocesses p 
                              on c.session_id = p.spid
CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS ST
where STATUS IN ('RUNNABLE', 'RUNNING', 'SUSPENDED') 
ORDER BY STATUS

-- Quantidade de Conex�es por banco de dados --
SELECT db_name(dbid) as Banco_de_Dados,
       count(dbid) as Qtd_Conexoes
FROM sys.sysprocesses
WHERE dbid > 50 
and db_name(dbid) = 'smartgp'
GROUP BY dbid, loginame