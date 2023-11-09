CREATE TABLE Strings (String1 varchar(5),
                      String2 varchar(10),
                      string3 varchar(5),
                      string4 varchar(10))
Go

INSERT INTO dbo.Strings (String1, String2, String3, string4)
VALUES('Hello',NULL,NULL,'Goodbye')
Go

SELECT ISNULL(String1, String2) AS Expr1,
       COALESCE(String1, String2) AS Expr2,
       ISNULL(String3, String4) AS Expr3,
       COALESCE(String3, String4) AS Expr4
FROM Strings
Go