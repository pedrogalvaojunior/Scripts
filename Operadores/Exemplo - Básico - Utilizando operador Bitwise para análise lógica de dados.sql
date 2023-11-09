 USE tempdb;
  GO
  IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_NAME = 'bitwise')
     DROP TABLE bitwise;
  GO
  CREATE TABLE bitwise
  ( 
   a_int_value int NOT NULL,
  b_int_value int NOT NULL
  );
  GO
  INSERT bitwise VALUES (250, 255);
  GO


  USE tempdb;
  GO
  SELECT a_int_value | b_int_value
  FROM bitwise;
  GO


  select convert(binary, a_int_value | b_int_value) from bitwise