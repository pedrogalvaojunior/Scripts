USE DBNAME -- CHANGE FOR THE CATALOG THAT YOU HAVE THE OBJECT

SET NOCOUNT ON

DECLARE @OBJECTNAME VARCHAR(255)

SET @OBJECTNAME = 'OBJECT_NAME' --CHANGE FOR THE OBJECT THAT YOU WANT TO DECRYPT.


DECLARE @ORG_OBJ_BIN VARBINARY(8000)
DECLARE @SQL1 NVARCHAR(4000)
DECLARE @SQL2 VARCHAR(8000)
DECLARE @SQL3 NVARCHAR(4000)

DECLARE @ORIGSPTEXT1 NVARCHAR(4000)
DECLARE @ORIGSPTEXT2 NVARCHAR(4000)
DECLARE @ORIGSPTEXT3 NVARCHAR(4000)

DECLARE @MIN INT
DECLARE @MAX INT
DECLARE @PRINT_OBJ VARCHAR(MAX)

DECLARE @RESULTSP NVARCHAR(4000)

DECLARE @I INT,@STATUS INT,@TYPE VARCHAR(10),@PARENTID INT
DECLARE @COLID INT,@N INT,@Q INT,@J INT,@K INT,@ENCRYPTED INT,@NUMBER INT
DECLARE @PARENT_OBJ VARCHAR(255),@TR_PARENT_XTYPE VARCHAR(10)

DECLARE @OBEJCTID INT
DECLARE @PARENTOWNERNAME VARCHAR(255)

SET @OBEJCTID = OBJECT_ID(@OBJECTNAME)
SELECT @TYPE=xtype,@PARENTID=parent_obj FROM sysobjects WHERE id=@OBEJCTID
SELECT @PARENTOWNERNAME = A.name FROM sysusers A, sysobjects B WHERE A.uid = B.uid AND B.id=@PARENTID


--Server Triggers
IF @OBEJCTID IS NULL
BEGIN
	SELECT @OBEJCTID = object_id FROM sys.server_triggers WHERE name = @OBJECTNAME
	SET @TYPE = 'SRTR'
END



--Database Triggers
IF @OBEJCTID IS NULL
BEGIN
	SELECT @OBEJCTID = object_id FROM sys.triggers WHERE name = @OBJECTNAME AND parent_class_desc = 'DATABASE'
	SET @TYPE = 'DBTR'
END

--CHECK IF OBJECT EXISTS
IF NOT EXISTS (SELECT * FROM sys.sysobjvalues WHERE objid = @OBEJCTID and valclass = 1)
BEGIN
	PRINT 'OBJECT NOT FOUND'
	RETURN
END

--CHECK IF THE OBJECT IS ENCRYPTED
IF NOT EXISTS (SELECT * FROM syscomments WHERE id = @OBEJCTID and ENCRYPTED = 1)
BEGIN
	PRINT 'OBJECT IS NOT ENCRYPTED'
	RETURN
END



BEGIN TRANSACTION

--DECLARE TEMP TABLES

--TABLE TO INSERT THE RESULTS
DECLARE @Result_TB TABLE (
	Number	INT,
	ColID	INT,
	CText	VARCHAR(8000)
	)

--TEMP TABLE 1
DECLARE @Temp_TB TABLE (
	NUMBER INT,
	COLID INT,
	CTEXT VARBINARY(8000),
	ENCRYPTED INT,
	STATUS INT
	)

--TEMP TABLE 2
DECLARE @Temp_EN_TB TABLE (
	NUMBER INT,
	COLID INT,
	CTEXT VARBINARY(8000),
	ENCRYPTED INT,
	STATUS INT
	)

--TEMP TABLE TO STORE THE ENCRYPTED OBJECT
DECLARE @OBJVAL TABLE (
	ImageVal	varbinary(MAX)
	)


--DECLARE VARIABLE TO GET THE SIZE OF THE OBJECT
DECLARE @DataLen INT


INSERT INTO @OBJVAL
	SELECT imageval FROM sys.sysobjvalues WHERE objid = @OBEJCTID and valclass = 1

SET @DataLen = (SELECT datalength(imageval) FROM @OBJVAL)
SET @I = 1

WHILE @I <= CEILING(@DataLen / 8000.0)
BEGIN
	INSERT INTO @Temp_TB 
		SELECT 1, @I, substring(imageval, (@I - 1) * 8000 + 1, 8000), 1, 1 FROM @OBJVAL
	SET @I = @I + 1
END



SELECT @NUMBER=MAX(NUMBER) FROM @Temp_TB


SET @K=0
IF EXISTS (SELECT * FROM @Temp_TB WHERE ENCRYPTED = 1)
WHILE @K<=@NUMBER
BEGIN

	IF EXISTS(SELECT 1 FROM @Temp_TB WHERE NUMBER=@K)
	BEGIN

		--Stored Procedures
		IF @TYPE='P'
			SET @SQL1=(CASE WHEN @NUMBER>1 THEN 'ALTER PROCEDURE '+ @OBJECTNAME +';'+RTRIM(@K)+' WITH ENCRYPTION AS '
			ELSE 'ALTER PROCEDURE '+ @OBJECTNAME+' WITH ENCRYPTION AS '
			END)


		--Table Triggers
		IF @TYPE='TR'
		BEGIN
			SELECT @PARENT_OBJ=parent_obj FROM sysobjects WHERE id=@OBEJCTID
			SELECT @TR_PARENT_XTYPE=xtype FROM sysobjects WHERE id=@PARENT_OBJ
			IF @TR_PARENT_XTYPE='V'
			BEGIN
				SET @SQL1='ALTER TRIGGER '+@OBJECTNAME+' ON ['+@PARENTOWNERNAME+'].['+OBJECT_NAME(@PARENTID)+'] WITH ENCRYPTION INSTERD OF INSERT AS PRINT 1 '
			END
			ELSE
			BEGIN
				SET @SQL1='ALTER TRIGGER '+@OBJECTNAME+' ON ['+@PARENTOWNERNAME+'].['+OBJECT_NAME(@PARENTID)+'] WITH ENCRYPTION FOR INSERT AS PRINT 1 '
			END

		END

		--Server Triggers
		IF @TYPE='SRTR'
		BEGIN
			SET @SQL1='ALTER TRIGGER '+@OBJECTNAME+' ON ALL SERVER WITH ENCRYPTION FOR DDL_LOGIN_EVENTS AS PRINT 1 '
		END


		--Database Triggers
		IF @TYPE='DBTR'
		BEGIN
			SET @SQL1='ALTER TRIGGER '+@OBJECTNAME+' ON DATABASE WITH ENCRYPTION FOR DROP_TABLE AS PRINT 1 '
		END


		--User Functions
		IF @TYPE='FN' OR @TYPE='TF' OR @TYPE='IF'
			SET @SQL1=(CASE @TYPE WHEN 'TF' THEN 
			'ALTER FUNCTION '+ @OBJECTNAME+'(@A CHAR(1)) RETURNS @B TABLE(A VARCHAR(10)) WITH ENCRYPTION AS BEGIN INSERT @B SELECT @A RETURN END '
			WHEN 'FN' THEN
			'ALTER FUNCTION '+ @OBJECTNAME+'(@A CHAR(1)) RETURNS CHAR(1) WITH ENCRYPTION AS BEGIN RETURN @A END'
			WHEN 'IF' THEN
			'ALTER FUNCTION '+ @OBJECTNAME+'(@A CHAR(1)) RETURNS TABLE WITH ENCRYPTION AS RETURN SELECT @A AS A'
			END)


		--Views
		IF @TYPE='V'
			SET @SQL1='ALTER VIEW '+@OBJECTNAME+' WITH ENCRYPTION AS SELECT 1 AS F'

		SET @Q=LEN(@SQL1)
		SET @SQL1=@SQL1+REPLICATE('-',4000-@Q)
		SELECT @SQL2=REPLICATE('-',8000)
		SET @SQL3='EXEC(@SQL1'
		SELECT @COLID=MAX(COLID) FROM @Temp_TB WHERE NUMBER=@K 
		SET @N=1
		WHILE @N<=CEILING(1.0*(@COLID-1)/2) AND LEN(@SQL3)<=3996
		BEGIN 
			SET @SQL3=@SQL3+'+@'
			SET @N=@N+1
		END


		SET @SQL3=@SQL3+')'
		EXEC sp_executesql @SQL3,N'@SQL1 NVARCHAR(4000),@ VARCHAR(8000)',@SQL1=@SQL1,@=@SQL2

	END
	SET @K=@K+1
END


DELETE FROM  @OBJVAL
INSERT INTO @OBJVAL
SELECT imageval FROM sys.sysobjvalues WHERE objid = @OBEJCTID and valclass = 1
SET @DataLen = (SELECT datalength(imageval) FROM @OBJVAL)
SET @I = 1

WHILE @I <= CEILING(@DataLen / 8000.0)
BEGIN
	INSERT INTO @Temp_EN_TB 
		SELECT 1, @I, substring(imageval, (@I - 1) * 8000 + 1, 8000), 1, 1 FROM @OBJVAL
	SET @I = @I + 1
END

--

SET @K=0
WHILE @K<=@NUMBER 
BEGIN
	IF EXISTS(SELECT 1 FROM @Temp_TB WHERE NUMBER=@K)
	BEGIN
		SELECT @COLID=MAX(COLID) FROM @Temp_TB WHERE NUMBER=@K 
		SET @N=1

		WHILE @N<=@COLID
		BEGIN
			SELECT @ORIGSPTEXT1=CTEXT,@ENCRYPTED=ENCRYPTED,@STATUS=STATUS FROM @Temp_TB WHERE COLID=@N AND NUMBER=@K

			SET @ORIGSPTEXT3=(SELECT CTEXT FROM @Temp_EN_TB WHERE COLID=@N AND NUMBER=@K)
			IF @N=1
			BEGIN
				--Stored Procedures
				IF @TYPE='P'
					SET @ORIGSPTEXT2=(CASE WHEN @NUMBER>1 THEN 'CREATE PROCEDURE '+ @OBJECTNAME +';'+RTRIM(@K)+' WITH ENCRYPTION AS '
					ELSE 'CREATE PROCEDURE '+ @OBJECTNAME +' WITH ENCRYPTION AS '
					END)


				--User Defined Functions
				IF @TYPE='FN' OR @TYPE='TF' OR @TYPE='IF'
					SET @ORIGSPTEXT2=(CASE @TYPE WHEN 'TF' THEN 
					'CREATE FUNCTION '+ @OBJECTNAME+'(@A CHAR(1)) RETURNS @B TABLE(A VARCHAR(10)) WITH ENCRYPTION AS BEGIN INSERT @B SELECT @A RETURN END '
					WHEN 'FN' THEN
					'CREATE FUNCTION '+ @OBJECTNAME+'(@A CHAR(1)) RETURNS CHAR(1) WITH ENCRYPTION AS BEGIN RETURN @A END'
					WHEN 'IF' THEN
					'CREATE FUNCTION '+ @OBJECTNAME+'(@A CHAR(1)) RETURNS TABLE WITH ENCRYPTION AS RETURN SELECT @A AS A'
					END)


				--Table Triggers
				IF @TYPE='TR'
				BEGIN

					IF @TR_PARENT_XTYPE='V'
					BEGIN
						SET @ORIGSPTEXT2='CREATE TRIGGER '+@OBJECTNAME+' ON ['+@PARENTOWNERNAME+'].['+OBJECT_NAME(@PARENTID)+'] WITH ENCRYPTION INSTEAD OF INSERT AS PRINT 1 '
					END
					ELSE
					BEGIN
						SET @ORIGSPTEXT2='CREATE TRIGGER '+@OBJECTNAME+' ON ['+@PARENTOWNERNAME+'].['+OBJECT_NAME(@PARENTID)+'] WITH ENCRYPTION FOR INSERT AS PRINT 1 '
					END
				END


				--Server Triggers
				IF @TYPE='SRTR'
				BEGIN
					SET @ORIGSPTEXT2='CREATE TRIGGER '+@OBJECTNAME+' ON ALL SERVER WITH ENCRYPTION FOR DDL_LOGIN_EVENTS AS PRINT 1 '
				END


				--Database Triggers
				IF @TYPE='DBTR'
				BEGIN
					SET @ORIGSPTEXT2='CREATE TRIGGER '+@OBJECTNAME+' ON DATABASE WITH ENCRYPTION FOR DROP_TABLE AS PRINT 1 '
				END


				--Views
				IF @TYPE='V'
					SET @ORIGSPTEXT2='CREATE VIEW '+@OBJECTNAME+' WITH ENCRYPTION AS SELECT 1 AS F'

				SET @Q=4000-LEN(@ORIGSPTEXT2)
				SET @ORIGSPTEXT2=@ORIGSPTEXT2+REPLICATE('-',@Q)
			END
			ELSE
			BEGIN
				SET @ORIGSPTEXT2=REPLICATE('-', 4000)
			END
			SET @I=1

			SET @RESULTSP = REPLICATE(N'A', (DATALENGTH(@ORIGSPTEXT1) / 2))

			WHILE @I<=DATALENGTH(@ORIGSPTEXT1)/2
			BEGIN

				SET @RESULTSP = STUFF(@RESULTSP, @I, 1, NCHAR(UNICODE(SUBSTRING(@ORIGSPTEXT1, @I, 1)) ^
				(UNICODE(SUBSTRING(@ORIGSPTEXT2, @I, 1)) ^ 
				UNICODE(SUBSTRING(@ORIGSPTEXT3, @I, 1)))))


				SET @I=@I+1
			END

			SET @ORG_OBJ_BIN=CAST(@ORIGSPTEXT1 AS VARBINARY(8000))
			SET @RESULTSP=(CASE WHEN @ENCRYPTED=1 
				THEN @RESULTSP 
				ELSE CONVERT(NVARCHAR(4000),CASE WHEN @STATUS&2=2 THEN UNCOMPRESS(@ORG_OBJ_BIN) ELSE @ORG_OBJ_BIN END)
				END)

			INSERT INTO @Result_TB VALUES (@K, @N, @RESULTSP)

			SET @N=@N+1

		END

	END
	SET @K=@K+1
END


--A CURSOR TO STORE THE RESULTS ON A VARIABLE
SET @MIN = (SELECT MIN(COLID) FROM @Result_TB WHERE CTEXT IS NOT NULL)
SET @MAX = (SELECT MAX(COLID) FROM @Result_TB WHERE CTEXT IS NOT NULL)

declare @string nvarchar(max)
set @string = ''
WHILE @MIN <=@MAX
BEGIN
	SET @PRINT_OBJ = (SELECT CTEXT FROM @Result_TB WHERE COLID = @MIN)
	set @string = CAST(@string as nvarchar(max)) + CAST(@PRINT_OBJ as nvarchar(max))
--	PRINT @PRINT_OBJ
	SET @MIN = @MIN + 1
END



/* 
This script is designed to overcome the limitation in the SQL print command 
that causes it to truncate strings longer than 8000 characters (4000 for nvarchar).

It will print the text passed to it in substrings smaller than 4000
characters.  If there are carriage returns (CRs) or new lines (NLs in the text),
it will break up the substrings at the carriage returns and the
printed version will exactly reflect the string passed.

If there are insufficient line breaks in the text, it will
print it out in blocks of 4000 characters with an extra carriage
return at that point.

If it is passed a null value, it will do virtually nothing.

NOTE: This is substantially slower than a simple print, so should only be used
when actually needed.
 */

set @string = rtrim( @string )
declare @cr char(1), @lf char(1)
set @cr = char(13)
set @lf = char(10)

declare @len int, @cr_index int, @lf_index int, @crlf_index int, @has_cr_and_lf bit, @left nvarchar(4000), @reverse nvarchar(4000)
set @len = 4000

while ( len( @string ) > @len )
begin
   set @left = left( @string, @len )
   set @reverse = reverse( @left )
   set @cr_index = @len - charindex( @cr, @reverse ) + 1
   set @lf_index = @len - charindex( @lf, @reverse ) + 1
   set @crlf_index = case when @cr_index < @lf_index then @cr_index else @lf_index end
   set @has_cr_and_lf = case when @cr_index < @len and @lf_index < @len then 1 else 0 end
   print left( @string, @crlf_index - 1 )
   set @string = right( @string, len( @string ) - @crlf_index - @has_cr_and_lf )
end

print @string


ROLLBACK TRANSACTION