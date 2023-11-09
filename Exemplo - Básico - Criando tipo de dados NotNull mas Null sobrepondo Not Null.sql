CREATE TYPE NotNullType FROM VARCHAR(10) NOT NULL;
GO
-- table create 
CREATE TABLE Test(TestId INT, NullTest NotNullType NULL);
GO
-- insert
INSERT INTO Test(TestId) VALUES(1);
SELECT NullTest FROM Test;