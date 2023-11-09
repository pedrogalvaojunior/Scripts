--create test DB
USE master;
GO

CREATE DATABASE DB_test;
GO

ALTER DATABASE DB_test SET
CHANGE_TRACKING = ON
 (AUTO_CLEANUP = ON,          -- automatic tracking table clean up process
  CHANGE_RETENTION = 1 HOURS  -- specify the time frame for which tracked information will be maintained -- 
);
GO

--create test table
USE DB_test;
GO

CREATE TABLE dbo.tb
(id int
 CONSTRAINT PK_tb_id PRIMARY KEY,
 col1 int,
 col2 varchar(10),
 col3 nvarchar(max),
 col4 varbinary(max));
GO

ALTER TABLE dbo.tb
ENABLE CHANGE_TRACKING
 WITH(TRACK_COLUMNS_UPDATED = ON  -- With this option, you can include columns also whose values were changed
 );
GO

SELECT CHANGE_TRACKING_CURRENT_VERSION() as Currentversion,
       CHANGE_TRACKING_MIN_VALID_VERSION(OBJECT_ID(N'dbo.tb')) as minvalidversion;
GO

-- testing

-- a.insert data 
INSERT dbo.tb(id, col1, col2, col3, col4)
VALUES(1,1, 'AA', 'AAA', 0x1),
	  (2,2, 'BB', 'BBB', 0x2),
      (3,3, 'CC', 'CCC', 0x2);
 
SELECT CHANGE_TRACKING_CURRENT_VERSION() as Currentversion,
       CHANGE_TRACKING_MIN_VALID_VERSION(OBJECT_ID(N'dbo.tb')) as minvalidversion,
       *
FROM CHANGETABLE(CHANGES dbo.tb, 0) CHG LEFT JOIN dbo.tb DATA
                                         ON DATA.id = CHG.id;
 
-- b. update data 
BEGIN TRAN;
UPDATE dbo.tb SET
col1 = 11
WHERE id = 1;
 
UPDATE dbo.tb SET
col1 = 111
WHERE id = 1;
COMMIT TRAN;
 
SELECT CHANGE_TRACKING_CURRENT_VERSION() as Currentversion,
       CHANGE_TRACKING_MIN_VALID_VERSION(OBJECT_ID(N'dbo.tb')) as minvalidversion,
       *
FROM CHANGETABLE(CHANGES dbo.tb, 0) CHG LEFT JOIN dbo.tb DATA
                                         ON DATA.id = CHG.id;