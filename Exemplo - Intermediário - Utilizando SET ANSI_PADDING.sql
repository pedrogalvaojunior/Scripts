PRINT 'Testing with ANSI_PADDING ON'
SET ANSI_PADDING ON;
GO

CREATE TABLE t1 (
   charcol CHAR(16) NULL, 
   varcharcol VARCHAR(16) NULL, 
   varbinarycol VARBINARY(8)
);
GO
INSERT INTO t1 VALUES ('No blanks', 'No blanks', 0x00ee);
INSERT INTO t1 VALUES ('Trailing blank ', 'Trailing blank ', 0x00ee00);

SELECT 'CHAR' = '>' + charcol + '<', 'VARCHAR'='>' + varcharcol + '<',
   varbinarycol
FROM t1;
GO

PRINT 'Testing with ANSI_PADDING OFF';
SET ANSI_PADDING OFF;
GO

CREATE TABLE t2 (
   charcol CHAR(16) NULL, 
   varcharcol VARCHAR(16) NULL, 
   varbinarycol VARBINARY(8)
);
GO
INSERT INTO t2 VALUES ('No blanks', 'No blanks', 0x00ee);
INSERT INTO t2 VALUES ('Trailing blank ', 'Trailing blank ', 0x00ee00);

SELECT 'CHAR' = '>' + charcol + '<', 'VARCHAR'='>' + varcharcol + '<',
   varbinarycol
FROM t2;
GO

DROP TABLE t1;
DROP TABLE t2;