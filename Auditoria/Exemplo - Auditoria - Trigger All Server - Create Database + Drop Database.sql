create table TABELA_AUDITORIA
(Servidor varchar(200),
 NomeHost varchar(200),
 Usuario varchar(200),
 [Login] varchar(200),
 Aplicacao varchar(200),
 Horario datetime,
 Comando varchar(200))

Alter TRIGGER AUDITORIA
ON ALL SERVER
FOR
CREATE_DATABASE, DROP_DATABASE
AS

BEGIN
    DECLARE @Comando varchar(100), @Query varchar(max) 
    CREATE TABLE #inputbuffer 
    ( 
     EventType varchar(100), 
     Parameters int, 
     EventInfo varchar(max) 
    ) 
    SET @Comando = 'DBCC INPUTBUFFER(' + STR(@@SPID) + ')' 
    INSERT INTO #inputbuffer 
    EXEC (@Comando) 
    SET @Query = (SELECT EventInfo FROM #inputbuffer) 
  
    DECLARE @Horario varchar(100) 
    DECLARE @NomeHost varchar(100) 
    DECLARE @Servidor varchar(50)
    DECLARE @NomeUsuario varchar(100) 
    DECLARE @Login varchar(100) 
    DECLARE @Aplicacao nvarchar(300) 
  
    SET @Horario = CURRENT_TIMESTAMP 
    SET @NomeHost = HOST_NAME() 
    SET @Servidor = @@servername
    SET @NomeUsuario = USER 
    SET @Login = SYSTEM_USER 
    SET @Aplicacao = PROGRAM_NAME() 


	INSERT INTO Master..TABELA_AUDITORIA(Servidor, NomeHost, Usuario, Login, Aplicacao, Horario, Comando) 
	VALUES(@Servidor, @NomeHost, @NomeUsuario, @Login, @Aplicacao,@Horario, @Query) 
	
END