Create Database Teste
Go

Use Teste

CREATE APPLICATION ROLE AppRoleTeste
   WITH PASSWORD = 'senha@123';
GO

-- Atribui permiss�o de select da role em um schema, por exemplo:
GRANT SELECT ON SCHEMA::dbo TO AppRoleTeste;
GO

-- define a permiss�o da role no banco
EXEC sp_setapprole AppRoleteste, 'senha@123';
GO
