-- Constraints criadas no nível de coluna, com nome
--atribuido pelo próprio SQL Server
CREATE TABLE Pai
(
   Cod_Pai      int           Primary Key,
   Nome_Pai  char(30),
   RG_Pai       char(15)  Unique,
   Sal_Pai        decimal(10,2) Check(Sal_Pai >= 0) Default 0
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
   Cod_Filho  int Primary Key,
   Cod_Pai     int  Foreign Key(Cod_Pai) References Pai(Cod_Pai),
   Nome_Filho char(30),
   Sexo_Filho   char(1) Check(Sexo_Filho IN ('F','M')) Default 'M'
)
/* OU */
CREATE TABLE Filho
(
   Cod_Filho  int Primary Key,
   Cod_Pai     int  References Pai(Cod_Pai),
   Nome_Filho char(30),
   Sexo_Filho   char(1) Check(Sexo_Filho IN ('F','M')) Default 'M'
)

SELECT * FROM Pai

INSERT Filho VALUES(1,1,'Maria Silva','F')
INSERT Filho VALUES(2,1,'Carla Silva','F')
INSERT Filho VALUES(3,1,'Mercia Silva','F')

SELECT * FROM Pai
SELECT * FROM Filho

DELETE Pai
WHERE Cod_Pai = 1