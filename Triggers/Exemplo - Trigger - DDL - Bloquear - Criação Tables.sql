CREATE TRIGGER TI_BLOQUEIA_TABLE
ON ALL SERVER
FOR CREATE_TABLE
AS 
	if (EXISTS(SELECT 1 FROM sys.sysprocesses where spid > 50 and program_name LIKE '%Microsoft SQL Server Management Studio%' and spid = @@SPID and loginame = 'TESTE'))
	  BEGIN
		RAISERROR('VOCÊ NÃO TEM PERMISSÃO PARA EXECUTAR ESTA TAREFA !', 10, 1);
	  END
GO

--Faça um teste
CREATE TABLE TB_TESTE (CAMPO1 INT)
GO