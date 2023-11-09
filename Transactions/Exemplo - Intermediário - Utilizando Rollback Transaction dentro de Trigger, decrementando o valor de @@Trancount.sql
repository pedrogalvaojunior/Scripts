CREATE TABLE TranTest
(num int)

CREATE TABLE TranLog
(num int, trancount int)
GO

CREATE TRIGGER TrgTranTest
 ON TranTest 
 FOR INSERT
AS 
BEGIN
 SET NOCOUNT ON;
 DECLARE @num int, @tc int
 SELECT @num = num, @tc = @@TRANCOUNT FROM inserted
 INSERT INTO TranLog (num, trancount) VALUES (@num, @tc)
 IF @num %2 = 1 ROLLBACK TRAN
 SET @tc = @@TRANCOUNT
 INSERT INTO TranLog (num, trancount) VALUES (10+@num, @tc)
END
GO

INSERT INTO TranTest VALUES (1)
GO
BEGIN TRAN
INSERT INTO TranTest VALUES (2)
COMMIT TRAN
GO
BEGIN TRAN
INSERT INTO TranTest VALUES (3)
COMMIT TRAN
GO

SELECT * FROM TranLog