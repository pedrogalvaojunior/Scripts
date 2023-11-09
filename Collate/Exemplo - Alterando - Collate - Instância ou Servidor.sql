Alterando o collate do servidor/instância

Essa parte exigirá um pouco mais de cuidado e atenção:

1) Execute um backup de todas as bases de dados inclusive (master, msdb e model). Antes de uma alteração como essa sempre é mais prudente ter um backup, para o caso de eventuais problemas.

2) Pare o serviço do SQL Server.

3) Abra o prompt de comando (cmd) e navegue até o diretório de instalação do SQL Server. Exempo: C:\Program Files\Microsoft SQL Server\MSSQL10.SQLENTERPRISE\MSSQL\Binn.

4) Em seguida, execute o seguinte comando:

sqlservr -m -sInstancia_SQLSERVER -T4022 -T3659 -q”COLLATE_ESCOLHIDO”

5) Alguns comandos serão executados automaticamente a partir deste. No final do processo, tecle CTRL + C para parar o serviço atual.

6) Por fim, reinicie o serviço do SQL Server.