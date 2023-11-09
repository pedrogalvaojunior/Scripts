USE LATEX_SISTEMAS


CREATE TABLE HISTORVENDAS(
                     CODSEQUENCIAL INT NOT NULL IDENTITY,
                     CODREPRESENTANTE CHAR(3) NOT NULL,
                     LINHAPRODUTO CHAR(1) NOT NULL,
                     VLFATURADO FLOAT NOT NULL,
                     MES CHAR(2) NOT NULL,
                     ANO CHAR(4) NOT NULL,
            CONSTRAINT PK_HISTORVENDAS PRIMARY KEY CLUSTERED 
                   (
                    [CODSEQUENCIAL]) WITH  FILLFACTOR = 80  ON [PRIMARY])