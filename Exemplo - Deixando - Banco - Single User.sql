-- Muda o contexto de banco de dados

USE MASTER;

 

-- Coloca o banco Monousu�rio derrubando todas as conex�es

ALTER DATABASE Banco SET SINGLE_USER WITH ROLLBACK IMMEDIATE

 

-- Muda o contexto de banco de dados

USE BANCO;

 

-- Executa a procedure que necessita do banco monousu�rio

EXEC suaSP @Parametro = 'Valor'

 

-- Muda o contexto de banco de dados

USE MASTER;

 

-- Coloca o banco multiusu�rio derrubando alguma conex�o (se houver)

ALTER DATABASE Banco SET MULTI_USER WITH ROLLBACK IMMEDIATE
