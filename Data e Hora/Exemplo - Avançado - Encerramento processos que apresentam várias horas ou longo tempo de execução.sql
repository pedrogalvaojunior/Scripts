SET NOCOUNT ON
DECLARE @spid SMALLINT, @spidString VARCHAR(12)
--Declaring Cursor
DECLARE spidCursor CURSOR
    FOR SELECT spid
        FROM master.sys.sysprocesses
        WHERE last_batch < DATEADD(hh, -8, GETDATE()) AND spid > 50 -- Change 8 to any other value for hours AND spid > 50 -- for user spid
    FOR READ ONLY
OPEN spidCursor
FETCH NEXT FROM spidCursor INTO @spid
-- Processing kill logic
SELECT
    'Killed spid(s) - '
WHILE (@@fetch_status = 0)
    AND (@@error = 0)
    BEGIN
        SELECT @spidString = CONVERT(VARCHAR(12), @spid)
        EXEC ('kill ' + @spidString)
        SELECT @spid
        FETCH NEXT FROM spidCursor INTO @spid
    END
-- Closing cursor
CLOSE spidCursor
DEALLOCATE spidCursor
SET NOCOUNT OFF