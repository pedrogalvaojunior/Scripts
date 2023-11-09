SET NOCOUNT ON

SELECT @@SERVERNAME AS 'SERVIDOR',
       DB_NAME() AS 'BD',
       USER_NAME() AS 'USUARIO',
       USER_ID() AS 'ID - USU�RIO',
       SESSION_USER AS 'NOME - SESS�O - USU�RIO',
       @@SPID AS 'ID - SESS�O - USU�RIO',
       SUSER_ID() AS 'ID DO LOGIN',
       SUSER_SID() AS 'SID DO LOGIN'

�Current_User --> equivalente a User_Name();
�User_Name() --> retorna o nome do usu�rio conectado ao banco de dados, de acordo com id especificado;
�Session_User --> retorna o nome do usu�rio de acordo com o contexto de banco de dados;
�Suser_Name() --> retorna o nome do usu�rio;
�Suser_ID() --> retorna o identificador do login associado ao nome do usu�rio;
�Suser_SID() --> retorna o SID associado ao nome do login;
�Suser_SName() --> retorna o nome do login associado ao SID;
�System_User --> retorna o nome do login no banco de dados corrrente, de acordo com as informa��es na system tables sys.sysusers dentro do atual conectado.User --> retorna o nome do usu�rio no banco de dados corrrente, de acordo com as informa��es na system tables sys.sysusers dentro do atual conectado.