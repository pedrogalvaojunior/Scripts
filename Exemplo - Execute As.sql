USE AdventureWorks;
GO
-- Criando dois Logins de Acesso --
CREATE LOGIN login1 WITH PASSWORD = 'J345#$)thb';
CREATE LOGIN login2 WITH PASSWORD = 'Uor80$23b';
GO

-- Criando duas contas de usuário vinculadas aos Logins --
CREATE USER user1 FOR LOGIN login1;
CREATE USER user2 FOR LOGIN login2;
GO

--Give IMPERSONATE permissions on user2 to user1
--so that user1 can successfully set the execution context to user2.
GRANT IMPERSONATE ON USER:: user2 TO user1;
GO

-- Exibindo o Contexto atual de conexão --
SELECT SUSER_NAME(), USER_NAME();

-- Mudando o Contexto de conexão para o Login1 --
EXECUTE AS LOGIN = 'login1';

-- Verificando o contexto de conexão --
SELECT SUSER_NAME(), USER_NAME();

-- Mudando o Contexto de conexão para o Login2 --
EXECUTE AS USER = 'user2';

-- Exibindo o Contexto atual de conexão --
SELECT SUSER_NAME(), USER_NAME();

-- Revertendo o Contexto de Conexão --
REVERT;

-- Exibindo o Contexto atual de conexão --
SELECT SUSER_NAME(), USER_NAME();

-- Revertendo o Contexto de Conexão --
REVERT;

-- Exibindo o Contexto atual de conexão --
SELECT SUSER_NAME(), USER_NAME();

-- Excluíndo os Logins --
DROP LOGIN login1;
DROP LOGIN login2;

-- Excluíndos os Usuários --
DROP USER user1;
DROP USER user2;
GO