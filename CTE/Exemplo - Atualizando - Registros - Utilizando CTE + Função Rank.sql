Create Table Valores
 (Codigo Char(4),
  Sequencia Int)

Insert Into Valores Values ('0001',1),('0001',2),('0001',3),('0001',4)

Insert Into Valores Values ('0002',5),('0002',6),('0002',7),('0002',8)

Insert Into Valores Values ('0003',9),('0003',10)

Select * from Valores

;WITH CTE (Codigo, Seguencia, NovaSequencia)

AS 
(

  SELECT Codigo, Sequencia,

  RANK() OVER (PARTITION BY Codigo ORDER BY Sequencia)

  FROM valores 
)

UPDATE Valores
SET Sequencia = NovaSequencia
FROM CTE C INNER JOIN Valores V 
            ON C.Codigo = V.Codigo
            AND C.NovaSequencia = V.Sequencia