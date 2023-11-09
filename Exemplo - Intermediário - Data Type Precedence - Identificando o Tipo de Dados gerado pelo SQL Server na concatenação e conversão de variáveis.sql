DECLARE
    @txt VARCHAR(20),
    @dt  DATETIME,
    @i   INT,
    @bin VARBINARY(20);

SET @txt = '2017-01-01';
SET @dt = '2001-01-01';
SELECT result = @dt + @txt

-- Explicação --
Select Len(@dt + @txt), DATALENGTH(@dt + @txt)
Select Convert(DateTime2,@dt + @txt), Convert(DateTime, @dt + @txt)

SELECT result = @dt + @txt
 INTO t;

EXEC sp_help t

Drop Table t