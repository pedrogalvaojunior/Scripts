-- Muda o contexto de banco de dados

USE MASTER;

 

-- Coloca o banco Monousuário derrubando todas as conexões

ALTER DATABASE Banco SET SINGLE_USER WITH ROLLBACK IMMEDIATE

 

-- Muda o contexto de banco de dados

USE BANCO;

 

-- Executa a procedure que necessita do banco monousuário

EXEC suaSP @Parametro = 'Valor'

 

-- Muda o contexto de banco de dados

USE MASTER;

 

-- Coloca o banco multiusuário derrubando alguma conexão (se houver)

ALTER DATABASE Banco SET MULTI_USER WITH ROLLBACK IMMEDIATE
