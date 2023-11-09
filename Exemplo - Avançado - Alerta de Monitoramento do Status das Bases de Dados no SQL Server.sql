-- Escolha a base de dados para criar o Script

/*
Instrução de utilização:

	-- Alterar para o profile do seu servidor:
	@profile_name = 'MSSQLServer', 

	--Alterar para o e-mail que você quer enviar o alerta
	@recipients =	'seue-mail@seudominio.com',

*/

/*******************************************************************************************************************************
--	Tabela de controle que será utilizada para armazenar o Historico dos Alertas.
*******************************************************************************************************************************/

CREATE TABLE [dbo].[Alerta] (
	[Id_Alerta]		INT IDENTITY PRIMARY KEY,
	[Nm_Alerta]		VARCHAR(200),
	[Ds_Mensagem]	VARCHAR(2000),
	[Fl_Tipo]		TINYINT,						-- 0: CLEAR / 1: ALERTA
	[Dt_Alerta]		DATETIME DEFAULT(GETDATE())
)

GO


CREATE PROCEDURE [dbo].[stpAlerta_Status_Databases]
AS
BEGIN
	SET NOCOUNT ON

	-- Declara as variaveis
	DECLARE @Subject VARCHAR(500), @Fl_Tipo TINYINT, @Importance AS VARCHAR(6), 
	@EmailBody VARCHAR(MAX), @EmptyBodyEmail VARCHAR(MAX),			 
	@AlertaStatusDatabasesHeader VARCHAR(MAX), @AlertaStatusDatabasesTable VARCHAR(MAX)			
	
			
	/*******************************************************************************************************************************
	--	ALERTA: DATABASE INDISPONIVEL
	*******************************************************************************************************************************/	
	-- Verifica o último Tipo do Alerta registrado -> 0: CLEAR / 1: ALERTA
	SELECT @Fl_Tipo = [Fl_Tipo]
	FROM [dbo].[Alerta]		
	WHERE [Id_Alerta] = (SELECT MAX(Id_Alerta) FROM [dbo].[Alerta] WHERE [Nm_Alerta] = 'Database Indisponivel' )
	
	/*******************************************************************************************************************************
	-- Verifica se alguma Database não está ONLINE
	*******************************************************************************************************************************/ 
	IF EXISTS	(
					SELECT NULL
					FROM [sys].[databases]
					WHERE [state_desc] NOT IN ('ONLINE','RESTORING')
				)
	BEGIN	-- INICIO - ALERTA		
		IF ISNULL(@Fl_Tipo, 0) = 0	-- Envia o Alerta apenas uma vez
		BEGIN			
			/*******************************************************************************************************************************
			--	CRIA O EMAIL - ALERTA
			*******************************************************************************************************************************/

			--------------------------------------------------------------------------------------------------------------------------------
			--	ALERTA - HEADER
			--------------------------------------------------------------------------------------------------------------------------------
			SET @AlertaStatusDatabasesHeader = '<font color=black bold=true size=5>'			            
			SET @AlertaStatusDatabasesHeader = @AlertaStatusDatabasesHeader + '<BR /> Status das Databases <BR />' 
			SET @AlertaStatusDatabasesHeader = @AlertaStatusDatabasesHeader + '</font>'

			--------------------------------------------------------------------------------------------------------------------------------
			--	ALERTA - BODY
			--------------------------------------------------------------------------------------------------------------------------------
			SET @AlertaStatusDatabasesTable = CAST( (    
				SELECT td =				[name]			+ '</td>'
							+ '<td>' +	[state_desc]	+ '</td>'

				FROM (  
						-- Dados da Tabela do EMAIL  
						SELECT [name], [state_desc]
						FROM [sys].[databases]
						WHERE [state_desc] NOT IN ('ONLINE','RESTORING')
						
					  ) AS D ORDER BY [name]
				FOR XML PATH( 'tr' ), TYPE) AS VARCHAR(MAX) 
			)   
			      
			-- Corrige a Formatação da Tabela
			SET @AlertaStatusDatabasesTable = REPLACE( REPLACE( REPLACE( @AlertaStatusDatabasesTable, '&lt;', '<'), '&gt;', '>'), '<td>', '<td align = center>')
			    
			-- Títulos da Tabela do EMAIL
			SET @AlertaStatusDatabasesTable = 
					'<table cellpadding="0" cellspacing="0" border="3">'    
					+	'<tr>
							<th bgcolor=#0B0B61 width="200"><font color=white>Database</font></th>
							<th bgcolor=#0B0B61 width="200"><font color=white>Status</font></th>        
						</tr>'    
					+ REPLACE( REPLACE( @AlertaStatusDatabasesTable, '&lt;', '<'), '&gt;', '>')
					+ '</table>' 
			             
			--------------------------------------------------------------------------------------------------------------------------------
			-- Insere um Espaço em Branco no EMAIL
			--------------------------------------------------------------------------------------------------------------------------------
			SET @EmptyBodyEmail =	''
			SET @EmptyBodyEmail =
					'<table cellpadding="5" cellspacing="5" border="0">' +
						'<tr>
							<th width="500">               </th>
						</tr>'
						+ REPLACE( REPLACE( ISNULL(@EmptyBodyEmail,''), '&lt;', '<'), '&gt;', '>')
					+ '</table>'

			/*******************************************************************************************************************************
			--	Seta as Variáveis do EMAIL
			*******************************************************************************************************************************/
			SELECT	@Importance =	'High',
					@Subject =		'ALERTA: Existe alguma Database que não está ONLINE no Servidor: ' + @@SERVERNAME,
					@EmailBody =	@AlertaStatusDatabasesHeader + @EmptyBodyEmail + @AlertaStatusDatabasesTable + @EmptyBodyEmail
			
			/*******************************************************************************************************************************
			--	ENVIA O EMAIL - ALERTA
			*******************************************************************************************************************************/
			EXEC [msdb].[dbo].[sp_send_dbmail]
					@profile_name = 'MSSQLServer',
					@recipients =	'seue-mail@seudominio.com',
					@subject =		@Subject,
					@body =			@EmailBody,
					@body_format =	'HTML',
					@importance =	@Importance
					
			/*******************************************************************************************************************************
			-- Insere um Registro na Tabela de Controle dos Alertas -> Fl_Tipo = 1 : ALERTA
			*******************************************************************************************************************************/
			INSERT INTO [dbo].[Alerta] ( [Nm_Alerta], [Ds_Mensagem], [Fl_Tipo] )
			SELECT 'Database Indisponivel', @Subject, 1			
		END
	END		-- FIM - ALERTA
	ELSE 
	BEGIN	-- INICIO - CLEAR			
		IF ISNULL(@Fl_Tipo, 0) = 1
		BEGIN
			/*******************************************************************************************************************************
			--	CRIA O EMAIL - CLEAR
			*******************************************************************************************************************************/			

			--------------------------------------------------------------------------------------------------------------------------------
			--	CLEAR - HEADER
			--------------------------------------------------------------------------------------------------------------------------------
			SET @AlertaStatusDatabasesHeader = '<font color=black bold=true size=5>'			            
			SET @AlertaStatusDatabasesHeader = @AlertaStatusDatabasesHeader + '<BR /> Status das Databases <BR />' 
			SET @AlertaStatusDatabasesHeader = @AlertaStatusDatabasesHeader + '</font>'

			--------------------------------------------------------------------------------------------------------------------------------
			--	CLEAR - BODY
			--------------------------------------------------------------------------------------------------------------------------------
			SET @AlertaStatusDatabasesTable = CAST( (    
				SELECT td =				[name]			+ '</td>'
							+ '<td>' +	[state_desc]	+ '</td>'

				FROM (
						-- Dados da Tabela do EMAIL
						SELECT [name], [state_desc]
						FROM [sys].[databases]
					
				) AS D ORDER BY [name]
				FOR XML PATH( 'tr' ), TYPE) AS VARCHAR(MAX) 
			)   
			      
			-- Corrige a Formatação da Tabela
			SET @AlertaStatusDatabasesTable = REPLACE( REPLACE( REPLACE( @AlertaStatusDatabasesTable, '&lt;', '<'), '&gt;', '>'), '<td>', '<td align = center>')
			    
			-- Títulos da Tabela do EMAIL
			SET @AlertaStatusDatabasesTable = 
					'<table cellpadding="0" cellspacing="0" border="3">'    
					+	'<tr>
							<th bgcolor=#0B0B61 width="200"><font color=white>Database</font></th>
							<th bgcolor=#0B0B61 width="200"><font color=white>Status</font></th>        
						</tr>'    
					+ REPLACE( REPLACE( @AlertaStatusDatabasesTable, '&lt;', '<'), '&gt;', '>')
					+ '</table>' 
			
			--------------------------------------------------------------------------------------------------------------------------------
			-- Insere um Espaço em Branco no EMAIL
			--------------------------------------------------------------------------------------------------------------------------------
			SET @EmptyBodyEmail =	''
			SET @EmptyBodyEmail =
					'<table cellpadding="5" cellspacing="5" border="0">' +
						'<tr>
							<th width="500">               </th>
						</tr>'
						+ REPLACE( REPLACE( ISNULL(@EmptyBodyEmail,''), '&lt;', '<'), '&gt;', '>')
					+ '</table>'

			/*******************************************************************************************************************************
			--	Seta as Variáveis do EMAIL
			*******************************************************************************************************************************/
			SELECT	@Importance =	'High',
					@Subject =		'CLEAR: Não existe mais alguma Database que não está ONLINE no Servidor: ' + @@SERVERNAME,
					@EmailBody =	@AlertaStatusDatabasesHeader + @EmptyBodyEmail + @AlertaStatusDatabasesTable + @EmptyBodyEmail 
			
			/*******************************************************************************************************************************
			--	ENVIA O EMAIL - CLEAR
			*******************************************************************************************************************************/
			EXEC [msdb].[dbo].[sp_send_dbmail]
					@profile_name = 'MSSQLServer',
					@recipients =	'seue-mail@seudominio.com',
					@subject =		@Subject,
					@body =			@EmailBody,
					@body_format =	'HTML',
					@importance =	@Importance
						
			/*******************************************************************************************************************************
			-- Insere um Registro na Tabela de Controle dos Alertas -> Fl_Tipo = 0 : CLEAR
			*******************************************************************************************************************************/
			INSERT INTO [dbo].[Alerta] ( [Nm_Alerta], [Ds_Mensagem], [Fl_Tipo] )
			SELECT 'Database Indisponivel', @Subject, 0
		END
	END		-- FIM - CLEAR
END
