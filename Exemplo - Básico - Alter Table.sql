DROP TABLE Filho
DROP TABLE Pai
/* ****************************************** */
CREATE TABLE Pai
(
   Cod_Pai      int            Not Null,   
   Nome_Pai  char(30)  Not Null,
   RG_Pai       char(15)   Not Null, 
   Sal_Pai       decimal(10,2)  Not Null
)                                        
/* ****************************************** */
ALTER TABLE Pai
Add Constraint PK_Pai Primary Key(Cod_Pai),
         Constraint UQ_Pai Unique(RG_Pai),
         Constraint CH_Pai Check(Sal_Pai >=0),
         Constraint DF_Pai Default 0 FOR Sal_Pai

/* ******************************************* */
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
   Cod_Filho  int  Not Null, 
   Cod_Pai     int               Not Null,
   Nome_Filho char(30) Not Null,
   Sexo_Filho   char(1)    Not Null
)                       
/* ****************************************** */
ALTER TABLE Filho
Add Constraint PK_Filho Primary Key(Cod_Filho),
         Constraint FK_Filho Foreign Key(Cod_Pai) References Pai(Cod_Pai),
         Constraint CH_Filho Check(Sexo_Filho IN ('F','M')),
         Constraint DF_Filho Default 'F' FOR Sexo_Filho
/* ****************************************** */
SELECT * FROM Pai

INSERT Filho VALUES(1,1,'Maria Silva','F')
INSERT Filho VALUES(2,1,'Carla Silva','F')
INSERT Filho VALUES(3,1,'Mercia Silva','F')
/* ****************************************** */
SELECT * FROM Pai
SELECT * FROM Filho
/* ****************************************** */
DELETE Pai
WHERE Cod_Pai = 1
/* ****************************************** */