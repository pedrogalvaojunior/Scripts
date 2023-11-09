CREATE TABLE tblCli (Codigo INT, Nome VARCHAR(40), CodigoSup INT)

 

INSERT INTO tblCli VALUES (1,'Presidente', NULL)

INSERT INTO tblCli VALUES (2,'Superintendente', 1)

INSERT INTO tblCli VALUES (3,'Gerente', 2)

INSERT INTO tblCli VALUES (4,'Coordenador', 3)

INSERT INTO tblCli VALUES (5,'Supervisor', 4)

INSERT INTO tblCli VALUES (6,'Analista', 5)

INSERT INTO tblCli VALUES (7,'Estagiário', 6)

INSERT INTO tblCli VALUES (8,'Conselheiro', 1)

 

WITH Rel

AS (

SELECT Nome, 1 AS Nivel, Codigo FROM tblCli

WHERE CodigoSup IS NULL

UNION ALL

SELECT tblCli.Nome, Nivel + 1, tblCli.Codigo FROM Rel

INNER JOIN tblCli ON Rel.Codigo = tblCli.CodigoSup

)

 

SELECT

REPLICATE('--',Nivel) + '> ' + Nome

FROM

Rel

ORDER BY

Nivel
