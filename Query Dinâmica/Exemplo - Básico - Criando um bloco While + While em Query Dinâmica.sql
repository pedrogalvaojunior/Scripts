DECLARE @intLoopCounter INT = 2
,   @intMaxLoop INT = 162
,   @strbegin VARCHAR(8000) = ''
,   @strend VARCHAR(8000) = ''
,   @intDecre INT

SET @intDecre = @intMaxLoop

WHILE @intLoopCounter <= @intMaxLoop
    BEGIN
        SET @strbegin = @strbegin + ' WHILE @intloopCounter<=' + CAST(@intDecre AS VARCHAR) + ' 		BEGIN'
        SET @strend = @strend + ' SET @intloopCounter=@intloopCounter+1 END'
        SET @intLoopCounter = @intLoopCounter + 1
        SET @intDecre = @intDecre - 1
    END

-- uncomment to Print your generated query
PRINT 'DECLARE @intLoopCounter INT=1 ' + (@strbegin) + ' SELECT ''Shiva''' 
PRINT (@strend)

EXEC ('DECLARE @intLoopcounter INT=1 ' + @strbegin + ' SELECT '' Shiva'''+@strend)