/* ****************************************** */
DROP TABLE Filho
DROP TABLE Pai
/* ****************************************** */
CREATE TABLE Pai
(
   Cod_Pai      int  Identity    Not Null,   
   Nome_Pai  char(30)          Not Null,
   RG_Pai       char(15)           Not Null, 
   Sal_Pai       decimal(10,2)  Not Null
)                                        

INSERT Pai
VALUES('Paulo silva','123456',1500.00)

INSERT Pai
VALUES('Pedro silva','654321',2500.00)

INSERT Pai
VALUES('Marcelo silva','111222',300.00)

INSERT Pai
VALUES('Marcos silva','111222',300.00)

INSERT Pai
VALUES('João silva','111222',300.00)

SELECT * FROM Pai

DELETE Pai
WHERE Cod_Pai IN (3,4)

INSERT Pai
VALUES('José silva','111222',300.00)

INSERT Pai
VALUES('Antonio silva','111222',300.00)

INSERT Pai
VALUES('Juca silva','111222',300.00)

SELECT * FROM Pai
ORDER BY Cod_Pai

INSERT Pai
VALUES(3,'Roberto silva','111222',300.00)

INSERT Pai(Cod_Pai,Nome_Pai,RG_Pai,Sal_Pai)
VALUES(4,'Roberto silva','111222',300.00)

SET IDENTITY_INSERT Pai ON

INSERT Pai --ERRO
VALUES(3,'Roberto silva','111222',300.00)

INSERT Pai(Cod_Pai,Nome_Pai,RG_Pai,Sal_Pai)
VALUES(3,'Roberto silva','111222',300.00)

INSERT Pai(Cod_Pai,Nome_Pai,RG_Pai,Sal_Pai)
VALUES(4,'Ricardo silva','111222',300.00)

SET IDENTITY_INSERT Pai OFF

INSERT Pai
VALUES('Jonas silva','111222',300.00)

SELECT * FROM Pai
ORDER BY Cod_Pai
/* ******************************************** */
DROP TABLE Pai
/* ******************************************** */
CREATE TABLE Pai
(
   Cod_Pai      int  Identity(100,2) Not Null,   
   Nome_Pai  char(30)          Not Null,
   RG_Pai       char(15)           Not Null, 
   Sal_Pai       decimal(10,2)  Not Null
)     

 0000INSERT Pai
VALUES('Paulo silva','123456',1500.00)

INSERT Pai
VALUES('Pedro silva','654321',2500.00)

INSERT Pai
VALUES('Marcelo silva','111222',300.00)

INSERT Pai
VALUES('Marcos silva','111222',300.00)

INSERT Pai
VALUES('João silva','111222',300.00)

SELECT * FROM Pai