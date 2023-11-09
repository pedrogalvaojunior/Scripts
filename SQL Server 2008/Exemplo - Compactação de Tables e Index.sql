CREATE DATABASE WEBCAST
GO

--Criando uma tabela que usa compress�o de linha
CREATE TABLE TABELA1
 (COLUNA1 INT,
  COLUNA2 NVARCHAR(50))
WITH (DATA_COMPRESSION = ROW);
GO

--Criando uma tabela que usa compress�o de p�gina
CREATE TABLE TABELA2
 (COLUNA1 INT,
  COLUNA2 NVARCHAR(50))
WITH (DATA_COMPRESSION = PAGE);
GO

--Modificando uma tabela de para a compacta��o
ALTER TABLE TABELA1
 REBUILD WITH (DATA_COMPRESSION=PAGE);
GO

--Criando �ndice compactado
CREATE NONCLUSTERED INDEX IX_INDEX_1 ON TABELA(COLUNA2)
 WITH (DATA_COMPRESSION = ROW);
GO

--Modificando a compacta��o do �ndice
ALTER INDEX IX_INDEX_1 ON TABELA1
 REBUILD WITH(DATA_COMPRESSION=PAGE);
GO