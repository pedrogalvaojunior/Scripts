DECLARE @MyTable TABLE (MyIdentityColumn INT IDENTITY(1,1),
 MyCity NVARCHAR(50))

INSERT INTO @MyTable (MyCity) VALUES (N'Boston');

BEGIN TRANSACTION IdentityTest
INSERT INTO @MyTable (MyCity) VALUES (N'London')
ROLLBACK TRANSACTION IdentityTest

INSERT INTO @MyTable (MyCity) VALUES (N'New Delhi');
SELECT * FROM @MyTable mt