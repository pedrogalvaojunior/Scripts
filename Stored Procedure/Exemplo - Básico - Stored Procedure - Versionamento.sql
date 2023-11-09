CREATE PROCEDURE dbo.GetOne
AS 
SELECT 1
GO
CREATE PROCEDURE dbo.GetOne;2 --Versionamento, recurso antigo
AS 
SELECT 2
GO 

exec dbo.GetOne;2 -- Executando a procedure versão 2
go