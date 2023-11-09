-- Escolha a base de dados para criar o Script

/*
Instru��o de utiliza��o:

	-- Alterar para o profile do seu servidor:
	@profile_name = 'MSSQLServer', 

	--Alterar para o e-mail que voc� quer enviar o alerta
	@recipients =	'seue-mail@seudominio.com',

*/

/*******************************************************************************************************************************
--	Tabela de controle que ser� utilizada para armazenar o Historico dos Alertas.
*******************************************************************************************************************************/

CREATE TABLE [dbo].[Alerta] (
	[Id_Alerta]		INT IDENTITY PRIMARY KEY,
	[Nm_Alerta]		VARCHAR(200),
	[Ds_Mensagem]	VARCHAR(2000),
	[Fl_Tipo]		TINYINT,						-- 0: CLEAR / 1: ALERTA
	[Dt_Alerta]		DATETIME DEFAULT(GETDATE())
)

GO

/*******************************************************************************************************************************
--	ALERTA: LOG FULL
*******************************************************************************************************************************/

CREATE PROCEDURE [dbo].[stpAlerta_Log_Full]
AS
BEGIN
	SET NOCOUNT ON

	-- Declara as variaveis
	DECLARE @Tamanho_Minimo_Alerta_log INT, @AlertaLogHeader VARCHAR(MAX), @AlertaLogTable VARCHAR(MAX), @EmptyBodyEmail VARCHAR(MAX),
			@Importance AS VARCHAR(6), @EmailBody VARCHAR(MAX), @Subject VARCHAR(500), @Fl_Tipo TINYINT, @LOG TINYINT,
			@ResultadoWhoisactiveHeader VARCHAR(MAX), @ResultadoWhoisactiveTable VARCHAR(MAX)		
	
	-- Seta as variaveis
	SELECT	@LOG = 85,								-- 85 %
			@Tamanho_Minimo_Alerta_log = 100000		-- 100 MB
	
	-- Verifica o �ltimo Tipo do Alerta registrado -> 0: CLEAR / 1: ALERTA	
	SELECT @Fl_Tipo = [Fl_Tipo]
	FROM [dbo].[Alerta]
	WHERE [Id_Alerta] = (SELECT MAX(Id_Alerta) FROM [dbo].[Alerta] WHERE [Nm_Alerta] = 'Arquivo de Log Full' )
	
	-- Cria a tabela que ira armazenar os dados dos processos
	IF ( OBJECT_ID('tempdb..#Resultado_WhoisActive') IS NOT NULL )
		DROP TABLE #Resultado_WhoisActive
				
	CREATE TABLE #Resultado_WhoisActive (		
		[dd hh:mm:ss.mss]		VARCHAR(20),
		[database_name]			NVARCHAR(128),		
		[login_name]			NVARCHAR(128),
		[start_time]			DATETIME,
		[status]				VARCHAR(30),
		[session_id]			INT,
		[blocking_session_id]	INT,
		[wait_info]				VARCHAR(MAX),
		[open_tran_count]		INT,
		[CPU]					VARCHAR(MAX),
		[reads]					VARCHAR(MAX),
		[writes]				VARCHAR(MAX),
		[sql_command]			XML
	)

	/*******************************************************************************************************************************
	-- Verifica se existe algum LOG com mais de 85 % de utiliza��o
	*******************************************************************************************************************************/
	IF EXISTS(
				SELECT	db.[name]							AS [Database Name],
						db.[recovery_model_desc]			AS [Recovery Model],
						db.[log_reuse_wait_desc]			AS [Log Reuse Wait DESCription],
						ls.[cntr_value]						AS [Log Size (KB)],
						lu.[cntr_value]						AS [Log Used (KB)],
						CAST(	CAST(lu.[cntr_value] AS FLOAT) / 
								CASE WHEN CAST(ls.[cntr_value] AS FLOAT) = 0 
										THEN 1 
										ELSE CAST(ls.[cntr_value] AS FLOAT) 
								END AS DECIMAL(18,2)) * 100 AS [Percente_Log_Used] ,
						db.[compatibility_level]			AS [DB Compatibility Level] ,
						db.[page_verify_option_desc]		AS [Page Verify Option]
				FROM [sys].[databases] AS db
				JOIN [sys].[dm_os_performance_counters] AS lu  ON db.[name] = lu.[instance_name]
				JOIN [sys].[dm_os_performance_counters] AS ls  ON db.[name] = ls.[instance_name]
				WHERE	lu.[counter_name] LIKE 'Log File(s) Used Size (KB)%'
						AND ls.[counter_name] LIKE 'Log File(s) Size (KB)%' 
						AND ls.[cntr_value] > @Tamanho_Minimo_Alerta_log		-- Maior que 100 MB						
						AND (
								CAST(	CAST(lu.[cntr_value] AS FLOAT) / 
										CASE WHEN CAST(ls.[cntr_value] AS FLOAT) = 0 
												THEN 1 
												ELSE CAST(ls.[cntr_value] AS FLOAT) 
										END AS DECIMAL(18,2)) * 100
							) > @LOG											-- Maior que 85 %
			 )
	BEGIN	-- INICIO - ALERTA
		IF ISNULL(@Fl_Tipo, 0) = 0	-- Envia o Alerta apenas uma vez
		BEGIN
			--------------------------------------------------------------------------------------------------------------------------------
			--	ALERTA - DADOS - WHOISACTIVE
			--------------------------------------------------------------------------------------------------------------------------------
			-- Retorna todos os processos que est�o sendo executados no momento
			EXEC [dbo].[sp_WhoIsActive]
					@get_outer_command =	1,
					@output_column_list =	'[dd hh:mm:ss.mss][database_name][login_name][start_time][status][session_id][blocking_session_id][wait_info][open_tran_count][CPU][reads][writes][sql_command]',
					@destination_table =	'#Resultado_WhoisActive'
						    
			-- Altera a coluna que possui o comando SQL
			ALTER TABLE #Resultado_WhoisActive
			ALTER COLUMN [sql_command] VARCHAR(MAX)
			
			UPDATE #Resultado_WhoisActive
			SET [sql_command] = REPLACE( REPLACE( REPLACE( REPLACE( CAST([sql_command] AS VARCHAR(1000)), '<?query --', ''), '--?>', ''), '&gt;', '>'), '&lt;', '')
			
			-- select * from #Resultado_WhoisActive
			
			-- Verifica se n�o existe nenhum processo em Execu��o
			IF NOT EXISTS ( SELECT TOP 1 * FROM #Resultado_WhoisActive )
			BEGIN
				INSERT INTO #Resultado_WhoisActive
				SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
			END		
		
			/*******************************************************************************************************************************
			--	ALERTA - CRIA O EMAIL
			*******************************************************************************************************************************/

			--------------------------------------------------------------------------------------------------------------------------------
			--	ALERTA - HEADER - LOG FULL
			--------------------------------------------------------------------------------------------------------------------------------
			SET @AlertaLogHeader = '<font color=black bold=true size= 5>'
			SET @AlertaLogHeader = @AlertaLogHeader + '<BR /> Informa��es dos Arquivos de Log <BR />'
			SET @AlertaLogHeader = @AlertaLogHeader + '</font>'
			
			--------------------------------------------------------------------------------------------------------------------------------
			--	ALERTA - BODY - LOG FULL
			--------------------------------------------------------------------------------------------------------------------------------
			SET @AlertaLogTable = CAST( (    
				SELECT td =				[DatabaseName]							+ '</td>'
							+ '<td>' +	CAST([cntr_value] AS VARCHAR)			+ '</td>'
							+ '<td>' +	CAST([Percente_Log_Used] AS VARCHAR)	+ '</td>'
				FROM (	
						-- Dados da Tabela do EMAIL
						SELECT	db.[name]											AS [DatabaseName] ,
								CAST(ls.[cntr_value] / 1024.00 AS DECIMAL(18,2))	AS [cntr_value],
								CAST(	CAST(lu.[cntr_value] AS FLOAT) / 
										CASE WHEN CAST(ls.[cntr_value] AS FLOAT) = 0 
												THEN 1 
												ELSE CAST(ls.[cntr_value] AS FLOAT) 
										END AS DECIMAL(18,2)) * 100					AS [Percente_Log_Used]
						FROM [sys].[databases] AS db
						JOIN [sys].[dm_os_performance_counters] AS lu  ON db.[name] = lu.[instance_name]
						JOIN [sys].[dm_os_performance_counters] AS ls  ON db.[name] = ls.[instance_name]
						WHERE	lu.[counter_name] LIKE 'Log File(s) Used Size (KB)%'
								AND ls.[counter_name] LIKE 'Log File(s) Size (KB)%' 
								AND ls.[cntr_value] > @Tamanho_Minimo_Alerta_log -- Maior que 100 MB								
								AND (
										CAST(	CAST(lu.[cntr_value] AS FLOAT) / 
												CASE WHEN CAST(ls.[cntr_value] AS FLOAT) = 0 
														THEN 1 
														ELSE CAST(ls.[cntr_value] AS FLOAT) 
												END AS DECIMAL(18,2)) * 100
									) > @LOG

					  ) AS D ORDER BY [Percente_Log_Used] DESC
				FOR XML PATH( 'tr' ), TYPE) AS VARCHAR(MAX) 
			)   
			
			-- Corrige a Formata��o da Tabela
			SET @AlertaLogTable = REPLACE( REPLACE( REPLACE( @AlertaLogTable, '&lt;', '<' ), '&gt;', '>' ), '<td>', '<td align=center>')
			
			-- T�tulos da Tabela do EMAIL
			SET @AlertaLogTable =
					'<table cellpadding="0" cellspacing="0" border="3">'
					+	'<tr>
							<th bgcolor=#0B0B61 width="200"><font color=white>Database</font></th>
							<th bgcolor=#0B0B61 width="200"><font color=white>Tamanho Log (MB)</font></th> 
							<th bgcolor=#0B0B61 width="250"><font color=white>Percentual Log Utilizado (%)</font></th>
						</tr>'
					+ REPLACE( REPLACE( @AlertaLogTable, '&lt;', '<'), '&gt;', '>')
					+ '</table>'
			

			--------------------------------------------------------------------------------------------------------------------------------
			--	ALERTA - HEADER - WHOISACTIVE
			--------------------------------------------------------------------------------------------------------------------------------
			SET @ResultadoWhoisactiveHeader = '<font color=black bold=true size=5>'			            
			SET @ResultadoWhoisactiveHeader = @ResultadoWhoisactiveHeader + '<BR /> Processos executando no Banco de Dados <BR />'
			SET @ResultadoWhoisactiveHeader = @ResultadoWhoisactiveHeader + '</font>'

			--------------------------------------------------------------------------------------------------------------------------------
			--	ALERTA - BODY - WHOISACTIVE
			--------------------------------------------------------------------------------------------------------------------------------
			SET @ResultadoWhoisactiveTable = CAST( (
				SELECT td =				[Dura��o]				+ '</td>'
							+ '<td>' +  [database_name]			+ '</td>'
							+ '<td>' +  [login_name]			+ '</td>'
							+ '<td>' +  [start_time]			+ '</td>'
							+ '<td>' +  [status]				+ '</td>'
							+ '<td>' +  [session_id]			+ '</td>'
							+ '<td>' +  [blocking_session_id]	+ '</td>'
							+ '<td>' +  [Wait]					+ '</td>'
							+ '<td>' +  [open_tran_count]		+ '</td>'
							+ '<td>' +  [CPU]					+ '</td>'
							+ '<td>' +  [reads]					+ '</td>'
							+ '<td>' +  [writes]				+ '</td>'
							+ '<td>' +  [sql_command]			+ '</td>'

				FROM (  
						-- Dados da Tabela do EMAIL
						SELECT	ISNULL([dd hh:mm:ss.mss], '-')							AS [Dura��o], 
								ISNULL([database_name], '-')							AS [database_name],
								ISNULL([login_name], '-')								AS [login_name],
								ISNULL(CONVERT(VARCHAR(20), [start_time], 120), '-')	AS [start_time],
								ISNULL([status], '-')									AS [status],
								ISNULL(CAST([session_id] AS VARCHAR), '-')				AS [session_id],
								ISNULL(CAST([blocking_session_id] AS VARCHAR), '-')		AS [blocking_session_id],
								ISNULL([wait_info], '-')								AS [Wait],
								ISNULL(CAST([open_tran_count] AS VARCHAR), '-')			AS [open_tran_count],
								ISNULL([CPU], '-')										AS [CPU],
								ISNULL([reads], '-')									AS [reads],
								ISNULL([writes], '-')									AS [writes],
								ISNULL(SUBSTRING([sql_command], 1, 300), '-')			AS [sql_command]
						FROM #Resultado_WhoisActive
				
					  ) AS D ORDER BY [start_time] 
				FOR XML PATH( 'tr' ), TYPE) AS VARCHAR(MAX)
			) 
			      
			-- Corrige a Formata��o da Tabela
			SET @ResultadoWhoisactiveTable = REPLACE( REPLACE( REPLACE( @ResultadoWhoisactiveTable, '&lt;', '<'), '&gt;', '>'), '<td>', '<td align = center>')
			
			-- T�tulos da Tabela do EMAIL
			SET @ResultadoWhoisactiveTable = 
					'<table cellpadding="0" cellspacing="0" border="3">'    
					+	'<tr>
							<th bgcolor=#0B0B61 width="140"><font color=white>[dd hh:mm:ss.mss]</font></th>
							<th bgcolor=#0B0B61 width="100"><font color=white>Database</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>Login</font></th>
							<th bgcolor=#0B0B61 width="200"><font color=white>Hora In�cio</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>Status</font></th>
							<th bgcolor=#0B0B61 width="30"><font color=white>ID Sess�o</font></th>
							<th bgcolor=#0B0B61 width="60"><font color=white>ID Sess�o Bloqueando</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>Wait</font></th>
							<th bgcolor=#0B0B61 width="60"><font color=white>Transa��es Abertas</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>CPU</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>Reads</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>Writes</font></th>
							<th bgcolor=#0B0B61 width="1000"><font color=white>Query</font></th>
						</tr>'    
					+ REPLACE( REPLACE( @ResultadoWhoisactiveTable, '&lt;', '<'), '&gt;', '>')   
					+ '</table>'
		
			--------------------------------------------------------------------------------------------------------------------------------
			-- Insere um Espa�o em Branco no EMAIL
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
			--	Seta as Vari�veis do EMAIL
			*******************************************************************************************************************************/
			SELECT	@Importance =	'High',
					@Subject =		'ALERTA: Existe algum Arquivo de Log com mais de 85% de utiliza��o no Servidor: ' + @@SERVERNAME,
					@EmailBody =	@AlertaLogHeader + @EmptyBodyEmail + @AlertaLogTable + @EmptyBodyEmail + 
									@ResultadoWhoisactiveHeader + @EmptyBodyEmail + @ResultadoWhoisactiveTable + @EmptyBodyEmail
						
			/*******************************************************************************************************************************
			--	ALERTA - ENVIA O EMAIL
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
			SELECT 'Arquivo de Log Full', @Subject, 1			
		END
	END		-- FIM - ALERTA
	ELSE 
	BEGIN	-- INICIO - CLEAR
		IF @Fl_Tipo = 1
		BEGIN
			--------------------------------------------------------------------------------------------------------------------------------
			--	CLEAR - DADOS - WHOISACTIVE
			--------------------------------------------------------------------------------------------------------------------------------		      
			-- Retorna todos os processos que est�o sendo executados no momento
			EXEC [dbo].[sp_WhoIsActive]
					@get_outer_command =	1,
					@output_column_list =	'[dd hh:mm:ss.mss][database_name][login_name][start_time][status][session_id][blocking_session_id][wait_info][open_tran_count][CPU][reads][writes][sql_command]',
					@destination_table =	'#Resultado_WhoisActive'
						    
			-- Altera a coluna que possui o comando SQL
			ALTER TABLE #Resultado_WhoisActive
			ALTER COLUMN [sql_command] VARCHAR(MAX)
			
			UPDATE #Resultado_WhoisActive
			SET [sql_command] = REPLACE( REPLACE( REPLACE( REPLACE( CAST([sql_command] AS VARCHAR(1000)), '<?query --', ''), '--?>', ''), '&gt;', '>'), '&lt;', '')
			
			-- select * from #Resultado_WhoisActive
			
			-- Verifica se n�o existe nenhum processo em Execu��o
			IF NOT EXISTS ( SELECT TOP 1 * FROM #Resultado_WhoisActive )
			BEGIN
				INSERT INTO #Resultado_WhoisActive
				SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
			END
		
			/*******************************************************************************************************************************
			--	CLEAR - CRIA O EMAIL
			*******************************************************************************************************************************/										

			--------------------------------------------------------------------------------------------------------------------------------
			--	CLEAR - HEADER
			--------------------------------------------------------------------------------------------------------------------------------
			SET @AlertaLogHeader = '<font color=black bold=true size=5>'			            
			SET @AlertaLogHeader = @AlertaLogHeader + '<BR /> Informa��es dos Arquivos de Log <BR />' 
			SET @AlertaLogHeader = @AlertaLogHeader + '</font>'

			--------------------------------------------------------------------------------------------------------------------------------
			--	CLEAR - BODY
			--------------------------------------------------------------------------------------------------------------------------------
			SET @AlertaLogTable = CAST( (    
				SELECT td =				[DatabaseName]							+ '</td>'
							+ '<td>' +	CAST([cntr_value] AS VARCHAR)			+ '</td>'
							+ '<td>' +	CAST([Percente_Log_Used] AS VARCHAR)	+ '</td>'

				FROM (  
						-- Dados da Tabela do EMAIL
						SELECT	db.[name]											AS [DatabaseName] ,
								CAST(ls.[cntr_value] / 1024.00 AS DECIMAL(18,2))	AS [cntr_value],
								CAST(	CAST(lu.[cntr_value] AS FLOAT) / 
										CASE WHEN CAST(ls.[cntr_value] AS FLOAT) = 0 
												THEN 1 
												ELSE CAST(ls.[cntr_value] AS FLOAT) 
										END AS DECIMAL(18,2)) * 100					AS [Percente_Log_Used] 
						FROM [sys].[databases] AS db
						JOIN [sys].[dm_os_performance_counters] AS lu  ON db.[name] = lu.[instance_name]
						JOIN [sys].[dm_os_performance_counters] AS ls  ON db.[name] = ls.[instance_name]
						WHERE	lu.[counter_name] LIKE 'Log File(s) Used Size (KB)%'
								AND ls.[counter_name] LIKE 'Log File(s) Size (KB)%'
								AND ls.[cntr_value] > @Tamanho_Minimo_Alerta_log -- Maior que 100 MB								
						 							 
					  ) AS D ORDER BY [Percente_Log_Used] DESC
				FOR XML PATH( 'tr' ), TYPE) AS VARCHAR(MAX) 
			)   
			
			-- Corrige a Formata��o da Tabela
			SET @AlertaLogTable = REPLACE( REPLACE( REPLACE( @AlertaLogTable, '&lt;', '<' ), '&gt;', '>' ), '<td>', '<td align = center>')
			    
			-- T�tulos da Tabela do EMAIL
			SET @AlertaLogTable = 
					'<table cellpadding="0" cellspacing="0" border="3">'    
					+	'<tr>
							<th bgcolor=#0B0B61 width="200"><font color=white>Database</font></th>
							<th bgcolor=#0B0B61 width="200"><font color=white>Tamanho Log (MB)</font></th> 
							<th bgcolor=#0B0B61 width="250"><font color=white>Percentual Log Utilizado (%)</font></th>          
						</tr>'    
					+ REPLACE( REPLACE( @AlertaLogTable, '&lt;', '<'), '&gt;', '>')   
					+ '</table>' 
			
			--------------------------------------------------------------------------------------------------------------------------------
			--	CLEAR - HEADER - WHOISACTIVE
			--------------------------------------------------------------------------------------------------------------------------------
			SET @ResultadoWhoisactiveHeader = '<font color=black bold=true size=5>'			            
			SET @ResultadoWhoisactiveHeader = @ResultadoWhoisactiveHeader + '<BR /> Processos executando no Banco de Dados <BR />'
			SET @ResultadoWhoisactiveHeader = @ResultadoWhoisactiveHeader + '</font>'

			--------------------------------------------------------------------------------------------------------------------------------
			--	CLEAR - BODY - WHOISACTIVE
			--------------------------------------------------------------------------------------------------------------------------------
			SET @ResultadoWhoisactiveTable = CAST( (
				SELECT td =				[Dura��o]				+ '</td>'
							+ '<td>' +  [database_name]			+ '</td>'
							+ '<td>' +  [login_name]			+ '</td>'
							+ '<td>' +  [start_time]			+ '</td>'
							+ '<td>' +  [status]				+ '</td>'
							+ '<td>' +  [session_id]			+ '</td>'
							+ '<td>' +  [blocking_session_id]	+ '</td>'
							+ '<td>' +  [Wait]					+ '</td>'
							+ '<td>' +  [open_tran_count]		+ '</td>'
							+ '<td>' +  [CPU]					+ '</td>'
							+ '<td>' +  [reads]					+ '</td>'
							+ '<td>' +  [writes]				+ '</td>'
							+ '<td>' +  [sql_command]			+ '</td>'

				FROM (  
						-- Dados da Tabela do EMAIL
						SELECT	ISNULL([dd hh:mm:ss.mss], '-')							AS [Dura��o], 
								ISNULL([database_name], '-')							AS [database_name],
								ISNULL([login_name], '-')								AS [login_name],
								ISNULL(CONVERT(VARCHAR(20), [start_time], 120), '-')	AS [start_time],
								ISNULL([status], '-')									AS [status],
								ISNULL(CAST([session_id] AS VARCHAR), '-')				AS [session_id],
								ISNULL(CAST([blocking_session_id] AS VARCHAR), '-')		AS [blocking_session_id],
								ISNULL([wait_info], '-')								AS [Wait],
								ISNULL(CAST([open_tran_count] AS VARCHAR), '-')			AS [open_tran_count],
								ISNULL([CPU], '-')										AS [CPU],
								ISNULL([reads], '-')									AS [reads],
								ISNULL([writes], '-')									AS [writes],
								ISNULL(SUBSTRING([sql_command], 1, 300), '-')			AS [sql_command]
						FROM #Resultado_WhoisActive
				
					  ) AS D ORDER BY [start_time] 
				FOR XML PATH( 'tr' ), TYPE) AS VARCHAR(MAX)
			) 
			      
			-- Corrige a Formata��o da Tabela
			SET @ResultadoWhoisactiveTable = REPLACE( REPLACE( REPLACE( @ResultadoWhoisactiveTable, '&lt;', '<'), '&gt;', '>'), '<td>', '<td align = center>')
			
			-- T�tulos da Tabela do EMAIL
			SET @ResultadoWhoisactiveTable = 
					'<table cellpadding="0" cellspacing="0" border="3">'    
					+	'<tr>
							<th bgcolor=#0B0B61 width="140"><font color=white>[dd hh:mm:ss.mss]</font></th>
							<th bgcolor=#0B0B61 width="100"><font color=white>Database</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>Login</font></th>
							<th bgcolor=#0B0B61 width="200"><font color=white>Hora In�cio</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>Status</font></th>
							<th bgcolor=#0B0B61 width="30"><font color=white>ID Sess�o</font></th>
							<th bgcolor=#0B0B61 width="60"><font color=white>ID Sess�o Bloqueando</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>Wait</font></th>
							<th bgcolor=#0B0B61 width="60"><font color=white>Transa��es Abertas</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>CPU</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>Reads</font></th>
							<th bgcolor=#0B0B61 width="120"><font color=white>Writes</font></th>
							<th bgcolor=#0B0B61 width="1000"><font color=white>Query</font></th>
						</tr>'    
					+ REPLACE( REPLACE( @ResultadoWhoisactiveTable, '&lt;', '<'), '&gt;', '>')   
					+ '</table>'
			
			--------------------------------------------------------------------------------------------------------------------------------
			-- Insere um Espa�o em Branco no EMAIL
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
			--	Seta as Vari�veis do EMAIL
			*******************************************************************************************************************************/
			SELECT	@Importance =	'High',
					@Subject =		'CLEAR: N�o existe mais algum Arquivo de Log com mais de 85% de utiliza��o no Servidor: ' + @@SERVERNAME,
					@EmailBody =	@AlertaLogHeader + @EmptyBodyEmail + @AlertaLogTable + @EmptyBodyEmail + 
									@ResultadoWhoisactiveHeader + @EmptyBodyEmail + @ResultadoWhoisactiveTable + @EmptyBodyEmail
						
			/*******************************************************************************************************************************
			--	ALERTA - ENVIA O EMAIL
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
			SELECT 'Arquivo de Log Full', @Subject, 0		
		END
	END		-- FIM - CLEAR
END

GO

