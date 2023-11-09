/*
	Nome: Controle Autom�tico de VLFs  // Automatic VLF Control
	Autor: Edvaldo Castro

	Data: 05/01/2014  // Date: 2014/01/05

	
	Fun��o: Controlar Dinamicamente o tamanho dos VLFs das bases de dados. Este script especificamente realiza
			o ajuste inicial, adequando os arquivos de Transaction Log de todas as bases de dados da inst�ncia.

	Function:	Dynamically control the VLF size of all databases in a single SQL Server instance. This script do
				executes the initial adjustments, setting up the size and VLFs for Transaction Log files.
	

	Disclaimer:
			
		Os passos e scripts a seguir foram desenvolvidos para automatizar a configura��o e controle dos Virtual Log Files,
		e podem causar algum tipo de bloqueio ou indisponibilidade tempor�ria do SQL Server. 
		Antes de implantar ou utilizar partes ou todo o conte�do aqui disponibilizado, sugiro a leitura e entendimento do que 
		cada passo realiza. Implante primeiro em um ambiente de testes controlado, e caso veja benef�cios, se voc� for execut�-los 
		em seu ambiente de produ��o, por sua conta e risco.

	Disclaimer

		The steps and scripts below, has been developed to provide the automatic configuration and control of Virtual Log Files and
		may cause some blocking or temporary availability issues to SQL Server databases.
		Before you execute or use any part of the full content, I recommend you read and understand each step. Deploy it firstly to
		a controlled environment, and them if you find it useful, deploy to your production environment, BY YOUR OWN RISK !!!
		
		

*/


-- Cria a procedure sp_InitialSetupVLFControl
USE master
IF OBJECT_ID('master..sp_InitialSetupVLFControl') IS NOT NULL
	DROP PROCEDURE sp_InitialSetupVLFControl
GO
CREATE PROCEDURE sp_InitialSetupVLFControl
AS

			/* Vari�veis  -  Variables*/
			DECLARE @COUNT SMALLINT = 1 -- contador para o loop nas bases de dados // Counter for loop on each database
			DECLARE @DBNAME VARCHAR(100) -- Nome do banco que estar� sendo verificado // Database Name that is currently been verified
			DECLARE @LOGNAME VARCHAR(100) -- Nome l�gico do arquivo de log // Logical Name for the Transaction Log File
			DECLARE @MSG VARCHAR(100) -- Retorno de conclus�o com sucesso ap�s cada base ser verificada // Sucessful message returned after each operation
			DECLARE @SQL VARCHAR(MAX) -- Constru��o din�mica do comando para adequa��o dos VLFs // Dynamic query for VLFs configuration
			DECLARE @TGT_SIZE_MB INT -- Tamanho final (ideal) do arquivo de log // Final (recommended) size for the Transaction Log File according the ControlaVLF table
			DECLARE @CUR_SIZE_MB INT = 0  -- Tamanho atual do arquivo de log durante a execu��o do growth // Current size for the T-Log File during the growth execution
			DECLARE @ITER_SIZE_MB SMALLINT -- Tamanho do crescimento a cada loop (esta vari�vel determina o tamanho de cada VLF individualmente) 
										   -- File Growth size im MB each loop (this variable determines the size of each VLF)	

			--Executa um loop em todas as bases de dados da inst�ncia atribuindo as vari�veis
			-- Loop in every single database in the SQL Server instance, setting the variable values
			WHILE (@COUNT <= (SELECT MAX(ID) FROM master..controlaVLF))
				BEGIN

					SELECT @DBNAME = DatabaseName,
						   @LOGNAME = LogFileName,
						   @TGT_SIZE_MB = TargetLogFileSize_MB,
						   @ITER_SIZE_MB = 4096,  -- Defina aqui o tamanho do crescimento a cada itera��o (2048MB = 128MB/VLF  |  4096MB = 256MB/VLF  | 8192MB = 512MB/VLF)
												  -- Change the size of growth for each iteration (2048MB = 128MB/VLF  |  4096MB = 256MB/VLF  | 8192MB = 512MB/VLF)
						   @CUR_SIZE_MB = 0,

						   -- Caso o Recovery model seja full, realiza um bakcup de log e em seguida um shrinkfile, caso contr�rio, apenas o shrink file
						   -- Checks the Recovery Model, if Full, a Transaction Log Backup is issued, otherwise, only shrinkfile is issued.
						   -- Monta a query dinamica com base no modelo de recupera��o do banco | Substitutua o texto abaixo entre coment�rios /* */ pela sua rotina de backup de log
						   -- Creates the dynamic query based on recovery model of the database | Replace the comments /* */ by your T-Log procedure
						   @SQL =	CASE RecoveryModelDesc
										WHEN 'SIMPLE' THEN 'USE ' +@DBNAME+ '; DBCC SHRINKFILE(2,EMPTYFILE); USE ' +@DBNAME+ '; DBCC SHRINKFILE(2,EMPTYFILE);'
										ELSE 'USE MASTER; /* BACKUP LOG ' +@DBNAME+' TO DISK = ''NUL''; REPLACE THIS COMMENT BY YOUR BACKUP PROCEDURE */ USE ' +@DBNAME+ '; DBCC SHRINKFILE(2,EMPTYFILE); USE master; /* BACKUP LOG ' +@DBNAME+' TO DISK = ''NUL''; REPLACE THIS COMMENT BY YOUR BACKUP PROCEDURE */ USE ' +@DBNAME+ '; DBCC SHRINKFILE(2,EMPTYFILE); '
									END 
					FROM master..ControlaVLF F
					JOIN sys.databases D
					  ON F.DatabaseName = D.name
					WHERE ID = @COUNT
					  AND D.is_read_only = 0
				          AND D.user_access = 0

					EXEC (@SQL)
					--PRINT @SQL
					SET @SQL = ''
		
					-- Exibe o valor atual do tamanho do arquivo, bem como o tamanho alvo para o mesmo.
					-- Show the current size for the t-log file, as well the target size for it.
					PRINT 'VALOR ATUAL: '+CAST(@CUR_SIZE_MB AS VARCHAR(5))
					PRINT 'VALOR ALVO: '+CAST(@TGT_SIZE_MB AS VARCHAR(5))
		
				-- Executa um loop em cada uma das bases incrementando pelo tamanho do @ITER_SIZE_MB at� atingir o @TGT_SIZE_MB
				-- Runs a loop on each database increasing the file size by the @ITER_SIZE_MB while  it is smaller than @TGT_SIZE_MB
				WHILE (@CUR_SIZE_MB < @TGT_SIZE_MB)
						BEGIN
							SET @CUR_SIZE_MB = @CUR_SIZE_MB + @ITER_SIZE_MB
							SET @SQL = 'USE master; ALTER DATABASE '+@DBNAME+ ' MODIFY FILE (NAME = ''' +@LOGNAME+ ''',SIZE = '+CAST(@CUR_SIZE_MB AS VARCHAR(6))+'MB, FILEGROWTH = '+CAST(@ITER_SIZE_MB AS VARCHAR(6))+'MB);'
							PRINT @DBNAME + ': '+ CAST(@CUR_SIZE_MB AS VARCHAR(30))
							EXEC(@SQL)
				
						END
		
				-- Ajusta o tamanho para o tamanho ideal, de acordo com o recomendado na tabela ControlaVLF
				-- Shrinks the file size to the recommended in the ControlaVLF table
				RAISERROR (@MSG,0,1) WITH NOWAIT
				SET @SQL = 'USE ' +@DBNAME+ ' DBCC SHRINKFILE(2,'+CAST(@TGT_SIZE_MB AS VARCHAR(6))+'); USE ' +@DBNAME+ ' DBCC SHRINKFILE(2,'+CAST(@TGT_SIZE_MB AS VARCHAR(6))+');'
				EXEC (@SQL)
				SET @SQL = ''
				SET @CUR_SIZE_MB = 0
				SET @COUNT = @COUNT + 1

				END



