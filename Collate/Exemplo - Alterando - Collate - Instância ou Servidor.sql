Alterando o collate do servidor/inst�ncia

Essa parte exigir� um pouco mais de cuidado e aten��o:

1) Execute um backup de todas as bases de dados inclusive (master, msdb e model). Antes de uma altera��o como essa sempre � mais prudente ter um backup, para o caso de eventuais problemas.

2) Pare o servi�o do SQL Server.

3) Abra o prompt de comando (cmd) e navegue at� o diret�rio de instala��o do SQL Server. Exempo: C:\Program Files\Microsoft SQL Server\MSSQL10.SQLENTERPRISE\MSSQL\Binn.

4) Em seguida, execute o seguinte comando:

sqlservr -m -sInstancia_SQLSERVER -T4022 -T3659 -q�COLLATE_ESCOLHIDO�

5) Alguns comandos ser�o executados automaticamente a partir deste. No final do processo, tecle CTRL + C para parar o servi�o atual.

6) Por fim, reinicie o servi�o do SQL Server.