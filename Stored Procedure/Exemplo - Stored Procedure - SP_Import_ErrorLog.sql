CREATE PROC sp_import_errorlog

(
	@log_name sysname,
	@log_number int = 0,
	@overwrite bit = 0
)
AS
/*************************************************************************************************
Purpose:	To import the SQL Server error log into a table, so that it can be queried

Written by:	Anand Mahendra
	
Tested on: 	SQL Server 2000

Limitation: 	With error messages spanning more than one line only the first line is included in the table

Email: 		anandbox@sify.com

Example 1: 	To import the current error log to table myerrorlog
		EXEC sp_import_errorlog 'myerrorlog'

Example 2: 	To import the current error log to table myerrorlog, and overwrite the table
		'myerrorlog' if it already exists
		EXEC sp_import_errorlog 'myerrorlog', @overwrite = 1

Example 3: 	To import the previous error log to table myerrorlog
		EXEC sp_import_errorlog 'myerrorlog', 1

Example 4: 	To import the second previous error log to table myerrorlog
		EXEC sp_import_errorlog 'myerrorlog', 2

*************************************************************************************************/

BEGIN
	SET NOCOUNT ON
	
	DECLARE @sql varchar(500) --Holds to SQL needed to create columns from error log

	IF (SELECT OBJECT_ID(@log_name,'U')) IS NOT NULL
		BEGIN
			IF @overwrite = 0
				BEGIN
					RAISERROR('Table already exists. Specify another name or pass 1 to @overwrite parameter',18,1)
					RETURN -1
				END
			ELSE
				BEGIN
					EXEC('DROP TABLE ' + @log_name)
				END
		END

	
	--Temp table to hold the output of sp_readerrorlog
	CREATE TABLE #errlog
	(
		err varchar(1000),
		controw tinyint
	)

	--Populating the temp table using sp_readerrorlog
	INSERT #errlog 
	EXEC sp_readerrorlog @log_number

	--This will remove the header from the errolog
	SET ROWCOUNT 4
	DELETE #errlog
	SET ROWCOUNT 0

	
	SET @sql = 	'SELECT 
				CONVERT(DATETIME,LEFT(err,23)) [Date], 
				SUBSTRING(err,24,10) [spid], 
				RIGHT(err,LEN(err) - 33) [Message], 
				controw 
			INTO ' + QUOTENAME(@log_name) + 
			' FROM #errlog ' + 
			'WHERE controw = 0'
	
	--Creates the table with the columns Date, spid, message and controw
	EXEC (@sql)	
	
	--Dropping the temporary table
	DROP TABLE #errlog
	
	SET NOCOUNT OFF
PRINT 'Error log successfully imported to table: ' + @log_name
END 


