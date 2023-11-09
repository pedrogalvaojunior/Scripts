CREATE TABLE Src
  (ID int NOT NULL PRIMARY KEY,
   Value varchar(30) NOT NULL
  );

CREATE TABLE Dest
  (ID int NOT NULL,
   Value varchar(30) NOT NULL
  );
CREATE UNIQUE INDEX ix_Dest
    ON Dest(ID) WITH (IGNORE_DUP_KEY = ON);
go

-- Load some sample data
INSERT INTO Dest (ID, Value)
VALUES (1, 'Existing'),(3,'Also existing');
INSERT INTO Src (ID, Value)
VALUES (1, 'Added'),(2, 'New value'),(2, 'Another new value');

-- Test to see that MERGE does not respect IGNORE_DUP_KEY
MERGE INTO Dest
USING Src ON Src.ID = Dest.ID
WHEN NOT MATCHED
  THEN INSERT (ID, Value) VALUES (Src.ID, Src.Value);
-- Show results
SELECT * FROM Dest;

-- Test to see that UPDATE is not affected by IGNORE_DUP_KEY
UPDATE Dest
SET    ID = 3,
       Value = 'Updated';
SELECT *
FROM   Dest;

-- Clean up
DROP TABLE Dest, Src;
go
[/pre]