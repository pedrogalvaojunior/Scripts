CREATE TABLE TABELA1
 (CODIGO INT IDENTITY(1,1))

CREATE TABLE TABELA2
 (CODIGO INT IDENTITY(1,1),
  CODTABELA1 INT)

Create TABLE TABELA3
 (CODIGO INT IDENTITY(1,1),
   CODTABELA1 INT,
   CODTABELA2 INT)

ALTER TABLE TABELA1
 ADD CONSTRAINT [PK_CODIGO] PRIMARY KEY CLUSTERED (CODIGO)

ALTER TABLE TABELA2
 ADD CONSTRAINT [PK_CODIGO2] PRIMARY KEY CLUSTERED (CODIGO)

ALTER TABLE TABELA3
 ADD CONSTRAINT [PK_CODIGO3] PRIMARY KEY CLUSTERED (CODIGO)


ALTER TABLE TABELA2
 ADD CONSTRAINT [FK_CODIGOTABELA1] FOREIGN KEY (CODTABELA1) REFERENCES TABELA1(CODIGO)
ON DELETE CASCADE

ALTER TABLE TABELA3
 ADD CONSTRAINT [FK_CODIGOTABELA2] FOREIGN KEY (CODTABELA2) REFERENCES TABELA2(CODIGO)
ON DELETE CASCADE

ALTER TABLE TABELA3
 ADD CONSTRAINT [FK_CODIGOTABLE1] FOREIGN KEY (CODTABELA1) REFERENCES TABELA1(CODIGO)
ON DELETE CASCADE

INSERT INTO TABELA1 DEFAULT VALUES
GO 10

INSERT INTO TABELA2 VALUES(1)
INSERT INTO TABELA2 VALUES(2)
INSERT INTO TABELA2 VALUES(3)

INSERT INTO TABELA3 VALUES(1,1)
INSERT INTO TABELA3 VALUES(2,2)
INSERT INTO TABELA3 VALUES(3,1)


SELECT * FROM TABELA1

SELECT * FROM TABELA2

SELECT * FROM TABELA3

DELETE FROM TABELA1
WHERE CODIGO = 1