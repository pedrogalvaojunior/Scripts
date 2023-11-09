Select db_name(dbid) as [Database],login_time as Hora_Login,

Open_tran as Transacoes_Abertas,loginame as Usuario,

Hostname as Estacao_Trabalho,program_name as Aplicacao 

From master..sysProcesses
