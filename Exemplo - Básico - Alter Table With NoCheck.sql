/* ****************************************** */
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
INSERT Pai
VALUES(1,'Paulo silva','123456',1500.00)

INSERT Pai
VALUES(2,'Pedro silva','654321',2500.00)

INSERT Pai
VALUES(3,'Marcelo silva','111222',300.00)

SELECT * FROM Pai
/* ****************************************** */
ALTER TABLE Pai
Add
Constraint PK_Pai Primary Key(Cod_Pai),
Constraint UQ_Pai Unique(RG_Pai),
Constraint DF_Pai Default 0 FOR Sal_Pai,
Constraint CH_Pai Check(Sal_Pai >=0)


ALTER TABLE Pai
NoCheck Constraint CH_Pai

INSERT Pai
VALUES(4,'Carlos silva','7654321',-1500.00)

ALTER TABLE Pai
Check Constraint CH_Pai

/* ******************************************* */
CREATE TABLE Filho
(
   Cod_Filho  int               Not Null, 
   Cod_Pai     int               Not Null,
   Nome_Filho char(30) Not Null,
   Sexo_Filho   char(1)    Not Null
)                       
/* ****************************************** */
SELECT * FROM Pai

INSERT Filho VALUES(1,1,'Maria Silva','F')
INSERT Filho VALUES(2,1,'Carla Silva','F')

SELECT * FROM Pai
SELECT * FROM Filho

/* ****************************************** */
ALTER TABLE Filho
Add 
Constraint PK_Filho Primary Key(Cod_Filho),
Constraint DF_Filho Default 'F' FOR Sexo_Filho,
Constraint CH_Filho Check(Sexo_Filho IN ('F','M')),
Constraint FK_Filho Foreign Key(Cod_Pai) References Pai(Cod_Pai)

ALTER TABLE Filho
NoCheck Constraint FK_Filho

INSERT Filho VALUES(3,1000,'Mercia Silva','F')

ALTER TABLE Filho
Check Constraint FK_Filho
/* ****************************************** */
SELECT * FROM Pai
SELECT * FROM Filho
/* ****************************************** */
DELETE Pai
WHERE Cod_Pai = 1
/* ****************************************** */