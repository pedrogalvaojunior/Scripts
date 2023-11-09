CREATE TABLE NADA (A int, X int);

INSERT into NADA values (1, 8), (2, 18), (3, NULL), (4, 22)

-- Simulando - Constant Scan --
SELECT * from NADA 
  where X = NULL;
Go

-- Gerando o Table Scan --
SELECT * from NADA 
  where X Is NULL;

declare @NULL int;
SELECT * from NADA 
  where X = @NULL;
Go