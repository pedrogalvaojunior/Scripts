-- Cria a tabela

CREATE TABLE tbl (C1 INT, C2 INT, C3 CHAR(45), C4 CHAR(6000))

 

-- Cria um índice clustered

CREATE CLUSTERED INDEX IX ON tbl (C1)

 

-- Insere dados

INSERT INTO tbl VALUES (1,1,REPLICATE('C',45),REPLICATE('D',6000))

INSERT INTO tbl VALUES (2,2,REPLICATE('C',45),REPLICATE('D',6000))

INSERT INTO tbl VALUES (3,3,REPLICATE('C',45),REPLICATE('D',6000))

INSERT INTO tbl VALUES (4,4,REPLICATE('C',45),REPLICATE('D',6000))

 

-- Cria um índice nonclustered

CREATE NONCLUSTERED INDEX I ON tbl (C3) INCLUDE (C4)

 

-- Verifica o total de páginas ocupadas

SELECT * FROM 

Sys.Partitions As P INNER JOIN 

Sys.Allocation_Units As U ON P.hobt_id = U.container_id

WHERE OBJECT_NAME(Object_ID) = 'tbl'

 

-- Mata o índice

DROP INDEX tbl.I

 

-- Recria o índice com fill factor de 50%

-- Teoricamente com metade do FILL Factor não caberia um campo C4 com 6000 bytes

CREATE NONCLUSTERED INDEX I ON tbl (C3) INCLUDE (C4) WITH FILLFACTOR=50

 

-- Verifica o total de páginas ocupadas

SELECT * FROM

Sys.Partitions As P INNER JOIN 

Sys.Allocation_Units As U ON P.hobt_id = U.container_id

WHERE OBJECT_NAME(Object_ID) = 'tbl'

 

-- O valor se mantém para o índice nonclustered

-- Confere o Fill factor e realmente ficou em 50% mas foi desprezado

SELECT * FROM Sys.Indexes WHERE OBJECT_NAME(Object_ID) = 'tbl'

 

-- Mata a tabela

DROP TABLE tbl

