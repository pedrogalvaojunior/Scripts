DECLARE @AA VARCHAR(12) = 'AAA'
    ,@XXX            VARCHAR(12) = 'AAA'
    ,@YYY            VARCHAR(12) = 'BBB'
    ,@ZZZ            VARCHAR(12) = 'CCC'
    ,@AAXXX          VARCHAR(12) = 'XXAAA'
    ,@AAYYY          VARCHAR(12) = 'XXBBB'
    ,@AAZZZ          VARCHAR(12) = 'XXCCC'
    ,@XXXCount       INT = 1
    ,@YYYCount       INT = 1
    ,@ZZZCount       INT = 1
    ,@AAXXXCount     INT = 1
    ,@AAYYYCount     INT = 1
    ,@AAZZZCount     INT = 1
    ,@Result        INT;

-- Much to your chagrin, you encounter the following logic in a SQL SP.
-- You may assume that each local variable is DECLAREd and @AA,
-- @XXX, @YYY, @ZZZ, @AAXXX, @AAYYY, @AAZZZ each have a value assigned,
-- with only @AA required to be NOT NULL.  Each @xxxCount variable
-- is also assigned an integer value.
--
SET @Result = 0;

IF @AA = @XXX
BEGIN
    IF @XXXCount > @AAXXXCount SET @Result = 2
END
ELSE IF @AA = @YYY
BEGIN
    IF @YYYCount > @AAYYYCount SET @Result = 2
END
ELSE IF @AA = @ZZZ
BEGIN
    IF @ZZZCount > @AAZZZCount SET @Result = 2
END
ELSE IF @AA = @AAXXX
BEGIN
    IF @XXXCount = @AAXXXCount SET @Result = 3
END
ELSE IF @AA = @AAYYY
BEGIN
    IF @YYYCount = @AAYYYCount SET @Result = 3
END
ELSE IF @AA = @AAZZZ
BEGIN
    IF @ZZZCount = @AAZZZCount SET @Result = 3
END

-- Identify the equivalent logic from the options shown:
-- Option 1:
SET @Result = 0;
IF @AA = @XXX AND @XXXCount > @AAXXXCount SET @Result = 2
ELSE IF @AA = @YYY AND @YYYCount > @AAYYYCount SET @Result = 2
ELSE IF @AA = @ZZZ AND @ZZZCount > @AAZZZCount SET @Result = 2
ELSE IF @AA = @AAXXX AND @XXXCount = @AAXXXCount SET @Result = 3
ELSE IF @AA = @AAYYY AND @YYYCount = @AAYYYCount SET @Result = 3
ELSE IF @AA = @AAZZZ AND @ZZZCount = @AAZZZCount SET @Result = 3

SELECT [Option 1:]=@Result
SELECT @Result = NULL;

-- Option 2:
IF @AA = @XXX AND @XXXCount > @AAXXXCount SET @Result = 2
ELSE IF @AA = @YYY AND @YYYCount > @AAYYYCount SET @Result = 2
ELSE IF @AA = @ZZZ AND @ZZZCount > @AAZZZCount SET @Result = 2
ELSE IF @AA = @AAXXX AND @XXXCount = @AAXXXCount SET @Result = 3
ELSE IF @AA = @AAYYY AND @YYYCount = @AAYYYCount SET @Result = 3
ELSE IF @AA = @AAZZZ AND @ZZZCount = @AAZZZCount SET @Result = 3
ELSE SET @Result = 0;                     

SELECT [Option 2:]=@Result
SELECT @Result = NULL;

-- Option 3:
SELECT @Result = CASE @AA
    WHEN @XXX THEN CASE WHEN @XXXCount > @AAXXXCount THEN 2 ELSE 0 END
    WHEN @YYY THEN CASE WHEN @YYYCount > @AAYYYCount THEN 2 ELSE 0 END
    WHEN @ZZZ THEN CASE WHEN @ZZZCount > @AAZZZCount THEN 2 ELSE 0 END
    WHEN @AAXXX THEN CASE WHEN @XXXCount = @AAXXXCount THEN 3 ELSE 0 END
    WHEN @AAYYY THEN CASE WHEN @YYYCount = @AAYYYCount THEN 3 ELSE 0 END
    WHEN @AAZZZ THEN CASE WHEN @ZZZCount = @AAZZZCount THEN 3 ELSE 0 END
    END;

SELECT [Option 3:]=@Result          -- Not identical
SELECT @Result = NULL;
   
-- Option 4:
SELECT @Result = CASE @AA
    WHEN @XXX THEN CASE WHEN @XXXCount > @AAXXXCount THEN 2 ELSE 0 END
    WHEN @YYY THEN CASE WHEN @YYYCount > @AAYYYCount THEN 2 ELSE 0 END
    WHEN @ZZZ THEN CASE WHEN @ZZZCount > @AAZZZCount THEN 2 ELSE 0 END
    WHEN @AAXXX THEN CASE WHEN @XXXCount = @AAXXXCount THEN 3 ELSE 0 END
    WHEN @AAYYY THEN CASE WHEN @YYYCount = @AAYYYCount THEN 3 ELSE 0 END
    WHEN @AAZZZ THEN CASE WHEN @ZZZCount = @AAZZZCount THEN 3 ELSE 0 END
    ELSE 0 END;

SELECT [Option 4:]=@Result
SELECT @Result = NULL;

-- Option 5:
SELECT @Result = CASE @AA
    WHEN @XXX THEN CASE WHEN @XXXCount > @AAXXXCount THEN 2 END
    WHEN @YYY THEN CASE WHEN @YYYCount > @AAYYYCount THEN 2 END
    WHEN @ZZZ THEN CASE WHEN @ZZZCount > @AAZZZCount THEN 2 END
    WHEN @AAXXX THEN CASE WHEN @XXXCount = @AAXXXCount THEN 3 END
    WHEN @AAYYY THEN CASE WHEN @YYYCount = @AAYYYCount THEN 3 END
    WHEN @AAZZZ THEN CASE WHEN @ZZZCount = @AAZZZCount THEN 3 END
    ELSE 0 END;
   
SELECT [Option 5:]=@Result    -- Not identical