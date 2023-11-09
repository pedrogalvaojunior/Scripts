USE LABORATORIO


SELECT SUBSTRING(DESCRICAO,1,CHARINDEX(' ',DESCRICAO)) FROM PRODUTOS

SELECT * FROM PRODUTOS

declare @var varchar(100)
set @var = 'Microsoft Brasil LTDA.'

Select Substring(@var,1,charindex(' ',@var,1))