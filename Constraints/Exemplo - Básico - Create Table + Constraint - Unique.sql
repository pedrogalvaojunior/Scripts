DROP TABLE Filho
DROP TABLE Pai

-- Constraints criadas no nível de Tabela, com nome
-- atribuido pelo DBA

CREATE TABLE Pai
(
   Cod_Pai      int,   
   Nome_Pai  char(30),
   RG_Pai       char(15), 
   Sal_Pai       decimal(10,2) Constraint DF_Pai Default 0,

   Constraint PK_Pai Primary Key(Cod_Pai),
   Constraint UQ_Pai Unique(RG_Pai),
   Constraint CH_Pai Check(Sal_Pai >=0)
)                                        

INSERT Pai
VALUES(1,'Paulo silva','123456',1500.00)

INSERT Pai
VALUES(2,'Pedro silva','654321',1500.00)

INSERT Pai
VALUES(3,'Marcelo silva','111222',default)

SELECT * FROM Pai
/* ****************************************** */
CREATE TABLE Filho
(
   Cod_Filho  int, 
   Cod_Pai     int ,
   Nome_Filho char(30),
   Sexo_Filho   char(1) Constraint DF_Filho Default 'M',

   Constraint PK_Filho Primary Key(Cod_Filho),
   Constraint FK_Filho Foreign Key(Cod_Pai) References Pai(Cod_Pai),
   Constraint CH_Filho Check(Sexo_Filho IN ('M','F'))
)                       

SELECT * FROM Pai

INSERT Filho VALUES(1,1,'Maria Silva','F')
INSERT Filho VALUES(2,1,'Carla Silva','F')
INSERT Filho VALUES(3,1,'Mercia Silva','F')

SELECT * FROM Pai
SELECT * FROM Filho

DELETE Pai
WHERE Cod_Pai = 1