DECLARE @Tabela TABLE
(
 data DATE ,
 Valor DECIMAL(18,2)
)

INSERT INTO @Tabela
        ( data, Valor )

SELECT  DATEADD(DAY,-1,GETDATE()),100
UNION ALL
SELECT  DATEADD(DAY,-2,GETDATE()),200
UNION ALL
SELECT  DATEADD(DAY,-3,GETDATE()),200
UNION ALL
SELECT  DATEADD(DAY,-4,GETDATE()),300
UNION ALL
SELECT  DATEADD(DAY,-5,GETDATE()),400
UNION ALL
SELECT  DATEADD(DAY,-6,GETDATE()),500
UNION ALL
SELECT  DATEADD(DAY,-7,GETDATE()),600
UNION ALL
SELECT  DATEADD(DAY,-8,GETDATE()),700
UNION ALL
SELECT  DATEADD(DAY,-9,GETDATE()),800


SELECT T.data ,
       T.Valor,
	   [Valor de ontem] =  LAG(T.Valor,1,0) OVER(ORDER BY (SELECT NULL)) 
FROM @Tabela AS T
						  --valor 1 significa quanto retroage ,
						  --parametro 0 significa se o resultado for nullo qual será o valor default