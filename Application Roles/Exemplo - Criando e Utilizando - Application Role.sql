Create Database Teste
Go

Use Teste

CREATE APPLICATION ROLE AppRoleTeste
   WITH PASSWORD = 'senha@123';
GO

-- Atribui permissão de select da role em um schema, por exemplo:
GRANT SELECT ON SCHEMA::dbo TO AppRoleTeste;
GO

-- define a permissão da role no banco
EXEC sp_setapprole AppRoleteste, 'senha@123';
GO
