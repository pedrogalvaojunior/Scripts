-- Create a table --
CREATE TABLE dbo.quiztable 
  ( 
     id   INT NULL, 
     NAME VARCHAR(10) NOT NULL 
  ) 
Go

--  Create a table using SELECT INTO with the ISNULL() function --
SELECT ISNULL(id, 1)    AS id, 
       ISNULL(NAME, '') AS NAME 
INTO   dbo.isnulltest 
FROM   dbo.quiztable 
Go

-- Create a table using Select Into with the COALESCE >function --
SELECT COALESCE(id, 1)    AS id, 
       COALESCE(NAME, '') AS NAME 
INTO   dbo.coalescetest 
FROM   dbo.quiztable 
Go


