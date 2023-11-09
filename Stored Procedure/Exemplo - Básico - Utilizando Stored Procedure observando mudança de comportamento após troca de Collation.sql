CREATE TABLE [dbo].[Authors]
  (
    [id] [INT] NULL
  , [author] [VARCHAR](50) COLLATE SQL_Latin1_General_CP1_CI_AS
                           NULL
  , [dateposted] [DATE] NULL
  )
ON
  [PRIMARY]
GO

INSERT Authors
 VALUES (1, 'Steve', '20160101')
      , (2, 'STEVE', '20160201')
      , (3, 'Andy', '20160301')
      , (4, 'andy', '20160401')
GO


CREATE PROCEDURE GetAuthors
  @author VARCHAR(50)
AS
BEGIN
 SELECT a.id, a.author FROM dbo.Authors a 
 WHERE a.author = @author
END
GO

-- If I run the procedure with a parameter of 'Steve', it returns two rows. I then run this code: 

exec GetAuthors 'Steve'

ALTER TABLE dbo.Authors
 ALTER COLUMN author VARCHAR(50) COLLATE SQL_Latin1_General_CP437_BIN2 NULL

-- If I were to execute the stored procedure, what would happen? 

exec GetAuthors 'Steve'