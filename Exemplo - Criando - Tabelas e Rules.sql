CREATE TABLE DESCRICAO_TELAS(
                                               CODTELA VARCHAR(30) NOT NULL,
                                               CAPTION VARCHAR (50) NOT NULL, 
                                               OPCAO_MENU VARCHAR(50) NOT NULL,
                                  CONSTRAINT PK_TELA PRIMARY KEY CLUSTERED
                                                    (
                                                      [CODTELA]) WITH  FILLFACTOR = 80  ON [PRIMARY])

CREATE TABLE ACESSOS(
                                  CODTELA VARCHAR(30) NOT NULL,
                                  CODUSUARIO INT NOT NULL,
                                  PERMITIR CHAR(1) NOT NULL,
                                  CONSTRAINT PK_ACESSOS PRIMARY KEY CLUSTERED
                                                    (
                                                      [CODTELA],
                                                      [CODUSUARIO]) WITH  FILLFACTOR = 80  ON [PRIMARY])
     
CREATE RULE R_PERMITIR_ACESSOS
AS
 @PERMITIR IN ('S','N')

SP_BINDRULE 'R_PERMITIR_ACESSOS','ACESSOS.PERMITIR'

