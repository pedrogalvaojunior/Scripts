-- Valores Básicos --
DECLARE @TSQL varchar(8000), @VAR char(2)
      SELECT  @VAR = 'teste'
      SELECT  @TSQL = 'SELECT * FROM OPENQUERY(MeuLinkedServer,''SELECT * FROM MinhaTabela WHERE User = ''''' + @VAR + ''''''')'
      EXEC (@TSQL)
      
-- Query Complexa --     
DECLARE @OPENQUERY nvarchar(4000), @TSQL nvarchar(4000), @LinkedServer nvarchar(4000)
SET @LinkedServer = 'MyLinkedServer'
SET @OPENQUERY = 'SELECT * FROM OPENQUERY('+ @LinkedServer + ','''
SET @TSQL = 'SELECT au_lname, au_id FROM pubs..authors'')' 
EXEC (@OPENQUERY+@TSQL)   

-- Use o Sp_executesql procedimento armazenado --
DECLARE @VAR char(2)
SELECT  @VAR = 'CA'
EXEC MyLinkedServer.master.dbo.sp_executesql
     N'SELECT * FROM pubs.dbo.authors WHERE state = @state',
     N'@state char(2)',
     @VAR