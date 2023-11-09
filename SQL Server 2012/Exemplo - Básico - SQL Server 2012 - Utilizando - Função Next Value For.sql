Create Schema Test
Go

CREATE TABLE Test.MyTable
  (
      IDColumn nvarchar(25) PRIMARY KEY,
      name varchar(25) NOT NULL
  ) ;
  GO
  
  CREATE SEQUENCE Test.CounterSeq
      AS int
      START WITH 1
      INCREMENT BY 1 ;
  GO
  
  ALTER TABLE Test.MyTable
      ADD DEFAULT N'AdvWorks_' + CAST(NEXT VALUE FOR Test.CounterSeq AS NVARCHAR(20)) FOR IDColumn;
  GO
  
  INSERT Test.MyTable (name)
  VALUES ('Larry') ;
  GO
  
  SELECT * FROM Test.MyTable;
  GO
  
