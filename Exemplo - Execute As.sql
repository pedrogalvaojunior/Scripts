USE AdventureWorks;
GO
-- Criando dois Logins de Acesso --
CREATE LOGIN login1 WITH PASSWORD = 'J345#$)thb';
CREATE LOGIN login2 WITH PASSWORD = 'Uor80$23b';
GO

-- Criando duas contas de usu�rio vinculadas aos Logins --
CREATE USER user1 FOR LOGIN login1;
CREATE USER user2 FOR LOGIN login2;
GO

--Give IMPERSONATE permissions on user2 to user1
--so that user1 can successfully set the execution context to user2.
GRANT IMPERSONATE ON USER:: user2 TO user1;
GO

-- Exibindo o Contexto atual de conex�o --
SELECT SUSER_NAME(), USER_NAME();

-- Mudando o Contexto de conex�o para o Login1 --
EXECUTE AS LOGIN = 'login1';

-- Verificando o contexto de conex�o --
SELECT SUSER_NAME(), USER_NAME();

-- Mudando o Contexto de conex�o para o Login2 --
EXECUTE AS USER = 'user2';

-- Exibindo o Contexto atual de conex�o --
SELECT SUSER_NAME(), USER_NAME();

-- Revertendo o Contexto de Conex�o --
REVERT;

-- Exibindo o Contexto atual de conex�o --
SELECT SUSER_NAME(), USER_NAME();

-- Revertendo o Contexto de Conex�o --
REVERT;

-- Exibindo o Contexto atual de conex�o --
SELECT SUSER_NAME(), USER_NAME();

-- Exclu�ndo os Logins --
DROP LOGIN login1;
DROP LOGIN login2;

-- Exclu�ndos os Usu�rios --
DROP USER user1;
DROP USER user2;
GO