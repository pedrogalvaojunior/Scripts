CREATE EVENT SESSION [Blocked] ON SERVER 
ADD EVENT sqlserver.blocked_process_report 
ADD TARGET package0.event_file
(SET filename=N'C:\xel\blocked.xel')
GO

ALTER EVENT SESSION [Blocked]
ON SERVER
STATE = start;
GO


--Agora precisamos ler os arquivos .XEL gerados pela sessão e extrair os dados do XML para identificarmos as causas dos blocked process:

select theNodes.event_data.value('(//blocked-process/process)[1]/@spid','int') as blocking_process,
theNodes.event_data.value('(//blocked-process/process/inputbuf)[1]','varchar(max)') as blocking_text,
theNodes.event_data.value('(//blocked-process/process)[1]/@clientapp','varchar(100)') as blocking_app,
theNodes.event_data.value('(//blocked-process/process)[1]/@loginname','varchar(50)') as blocking_login,
theNodes.event_data.value('(//blocked-process/process)[1]/@isolationlevel','varchar(50)') as blocking_isolation,
theNodes.event_data.value('(//blocked-process/process)[1]/@hostname','varchar(50)') as blocking_host,
theNodes.event_data.value('(//blocking-process/process)[1]/@spid','int') as blocked_process,
theNodes.event_data.value('(//blocking-process/process/inputbuf)[1]','varchar(max)') as blocked_text,
theNodes.event_data.value('(//blocking-process/process)[1]/@clientapp','varchar(100)') as blocked_app,
theNodes.event_data.value('(//blocking-process/process)[1]/@loginname','varchar(50)') as blocked_login,
theNodes.event_data.value('(//blocked-process/process)[1]/@isolationlevel','varchar(50)') as blocked_isolation,
theNodes.event_data.value('(//blocking-process/process)[1]/@hostname','varchar(50)') as blocked_host
from 
(select convert(xml,event_data) event_data
from
sys.fn_xe_file_target_read_file('c:\xel\blocked*.xel', NULL, NULL, NULL)) theData
cross apply theData.event_data.nodes('//event') theNodes(event_data)