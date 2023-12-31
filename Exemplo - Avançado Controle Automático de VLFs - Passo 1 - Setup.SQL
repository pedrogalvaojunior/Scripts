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

-- Cria a procedure sp_SetupVLFControl
USE master
IF OBJECT_ID('master..sp_SetupVLFControl') IS NOT NULL
	DROP PROCEDURE sp_SetupVLFControl
GO
CREATE PROCEDURE sp_SetupVLFControl
AS
		IF OBJECT_ID('master..ControlaVLF') IS NOT NULL
			DROP TABLE ControlaVLF
		GO
		CREATE TABLE master..ControlaVLF
		(
			  ID INT IDENTITY,
			  ServerName VARCHAR(30) ,
			  DatabaseID SMALLINT ,
			  DatabaseName VARCHAR(30) ,
			  RecoveryModelDesc VARCHAR(15) ,
			  HasFullBackup BIT ,
			  TargetLogFileSize_MB NUMERIC(20, 2) ,
			  QtyVLF INT ,
			  CheckDate DATETIME ,
			  LastShrinkDate DATETIME ,
			  ShrinkCounter SMALLINT DEFAULT 0 ,
			  LogFileName VARCHAR(50) ,
			  PhysicalFileName VARCHAR(300) ,
			  FileState VARCHAR(10)
			)

		--CRIA TABELA TEMPOR�RIA PARA COLETAR INFORMA��ES DO DBCC LOGINFO
		IF OBJECT_ID('tempdb..##LogInfo') IS NOT NULL
			DROP TABLE ##LogInfo
		GO
		CREATE TABLE ##LogInfo
			(
			  ServerName VARCHAR(30) DEFAULT @@SERVERNAME ,
			  DatabaseID SMALLINT DEFAULT DB_ID() ,
			  DatabaseName VARCHAR(30) DEFAULT DB_NAME() ,
			  RecoveryUnitId TINYINT ,
			  FileID TINYINT ,
			  FileSize BIGINT ,
			  StartOffset BIGINT ,
			  FSeqNo INT ,
			  Status TINYINT ,
			  Parity SMALLINT ,
			  CreateLSN VARCHAR(40)
			)

		--COLETA INFORMA��ES DOS VLFs
		EXEC sp_msforeachdb '
		use [?];
		IF DB_ID() > 4
		BEGIN
			INSERT INTO ##LOGINFO (RecoveryUnitId,FileID,FileSize,StartOffset,FSeqNo,Status,Parity,CreateLSN)
			EXEC (''DBCC LOGINFO'')
		END

		'

		--ARMAZENA AS INFORMA�OES RELEVANTES REFERENTES AOS VLFs
		USE master
		GO
		INSERT  INTO ControlaVLF
				( ServerName ,
				  DatabaseID ,
				  DatabaseName ,
				  RecoveryModelDesc ,
				  HasFullBackup , 
				  TargetLogFileSize_MB ,
				  QtyVLF ,
				  CheckDate ,
				  LogFileName ,
				  PhysicalFileName ,
				  FileState
				)
				SELECT  ServerName ,
						DatabaseID ,
						DatabaseName ,
						sd.recovery_model_desc ,
						CASE 
							WHEN EXISTS (SELECT TOP 1 * FROM msdb..backupset WHERE type = 'D' AND database_name = DatabaseName) THEN 1
							ELSE 0
						END,				
						CAST(SUM(FILESIZE) / 1024. AS DEC(20, 2)) / 1024. AS TargetLogFileSize_MB ,
						COUNT(*) AS QtyVLF ,
						GETDATE() AS CheckDate ,
						mf.name ,
						mf.physical_name , 
						mf.state_desc
				FROM    ##LogInfo li
						JOIN sys.master_files mf ON li.DatabaseID = mf.database_id
						JOIN sys.databases sd ON sd.database_id = li.databaseid
												 AND sd.database_id = mf.database_id
	
				WHERE   mf.type_desc = 'log'
						AND mf.database_id > 4
						AND mf.state_desc = 'online'
				GROUP BY ServerName ,
						DatabaseID ,
						DatabaseName ,
						mf.name ,
						mf.physical_name ,
						mf.state_desc ,
						sd.recovery_model_desc
				ORDER BY DatabaseID


		--ATUALIZA O MENOR TAMANHO PARA O TAMANHO DO MENOR VLF
		UPDATE C 
		SET c.TargetLogFileSize_MB = 256
		FROM    ControlaVLF c
		WHERE   TargetLogFileSize_MB < 512

		SELECT * FROM MASTER..CONTROLAVLF



