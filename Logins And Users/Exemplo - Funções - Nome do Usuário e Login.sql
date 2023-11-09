Clayton,



Você poderia utilizar as funções:



Current_User --> equivalente a User_Name();
User_Name() --> retorna o nome do usuário conectado ao banco de dados, de acordo com id especificado;
Session_User --> retorna o nome do usuário de acordo com o contexto de banco de dados;
Suser_Name() --> retorna o nome do usuário;
Suser_ID() --> retorna o identificador do login associado ao nome do usuário;
Suser_SID() --> retorna o SID associado ao nome do login;
Suser_SName() --> retorna o nome do login associado ao SID;
System_User --> retorna o nome do login no banco de dados corrrente, de acordo com as informações na system tables sys.sysusers dentro do atual conectado.User --> retorna o nome do usuário no banco de dados corrrente, de acordo com as informações na system tables sys.sysusers dentro do atual conectado.


Você pode utilizar também a table sys.sysusers, para obter informaçõe dos usuários.