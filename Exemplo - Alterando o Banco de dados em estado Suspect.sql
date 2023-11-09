Faça o seguinte:

1 - Conecta-se ao SQL Server no banco Master.

2  - Execute este scritp: 

sp_configure 'allow updates',1
reconfigure with override

3 - Depois execute este outro script:

Update sysdatabases set status =32768 where name ='SeuBanco'

4 - Após mudar o status do banco para Emergency Mode, é necessário reconstruir o log de transações, utilize o DBCC rebuild_log:

Dbcc Rebuild_log ('NomedoSeuBanco','CaminhodoseuArquivodeLog') 

5 - Agora para finalizar a recuperação do banco, é necessário realizar os seguintes procedimento para recuperação de dados corrompidos e também para verificar a integridade dos dados comprometidos.

Use SeuBanco
go

sp_dboption 'SeuBanco', 'dbo use only', false
go

sp_dboption 'SeuBanco','single_user', true
go

dbcc checkdb ('SeuBanco',repair_allow_data_loss)
go



6 - Após realizar este procedimento o seu banco já deverá esta em estado normal, agora é necessário voltar a forma de acesso ao banco para multiuso:

Use SeuBanco
go

sp_dboption 'SeuBanco','single_user', false
go

sp_dboption 'SeuBanco', 'dbo use only', true
go


7 - Agora, vamos bloquear a permissão de alteração as table de sistema, faça o seguinte:

sp_configure 'allow updates',0
reconfigure with override