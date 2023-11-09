/* ****************************************** */
DROP TABLE Pai
/* ****************************************** */
Exec SP_DropType 'Codigo'
Exec SP_DropType 'Nome'
Exec SP_DropType 'RG'
Exec SP_DropType 'Salario'
/* ****************************************** */
Exec SP_AddType 'Codigo','int','Not Null'
Exec SP_AddType 'Nome','char(30)','Not Null'
Exec SP_AddType 'RG','Char(15)','Not Null'
Exec SP_AddType 'Salario','decimal(10,2)','Not Null'
/* *************************************** */
CREATE RULE R_Salario
AS @Sal >= 0
/* *************************************** */
CREATE DEFAULT D_Salario
AS 0
/* *************************************** */
Exec SP_BindRule 'R_Salario','Salario'
Exec SP_Bindefault 'D_Salario','Salario'
/* *************************************** */
CREATE TABLE Pai
(
   Cod_Pai      Codigo,
   Nome_Pai  Nome,
   RG_Pai       RG,
   Sal_Pai       Salario
)                                        

SELECT * FROM Pai

INSERT Pai VALUES(1,'João','123456',default)
INSERT Pai VALUES(2,'João','123456',2533.00)
INSERT Pai VALUES(3,'João','123456',null)