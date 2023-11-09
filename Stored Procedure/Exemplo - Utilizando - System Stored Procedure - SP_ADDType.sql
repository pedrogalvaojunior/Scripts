/* ****************************************** */
DROP TABLE Pai
/* ****************************************** */
Exec SP_AddType 'Codigo','int','Not Null'
Exec SP_AddType 'Nome','char(30)','Not Null'
Exec SP_AddType 'RG','Char(15)','Not Null'
Exec SP_AddType 'Salario','decimal(10,2)','Not Null'

CREATE TABLE Pai
(
   Cod_Pai      Codigo,
   Nome_Pai  Nome,
   RG_Pai       RG,
   Sal_Pai       salario
)                                        

Exec SP_Help Pai

ALTER TABLE Pai
ALTER COLUMN Cod_Pai bigint not null
/* *********************************** **/
ALTER TABLE Pai
DROP COLUMN Sal_Pai

ALTER TABLE Pai
ADD Sal_Pai Salario







