SELECT PRODUTO, LINHA, VENDA, DEVOLUCAO, VENDA - DEVOLUCAO AS DIFERENCA
FROM
(
SELECT PROD.CODIGO AS PRODUTO,PROD.LINHA AS LINHA ,
( SELECT ... DEVOLVE QTD VENDIDO ) AS VENDA ,
( SELECT ... DEVOLVE QTD DEVOLUCAO ) AS DEVOLUCAO
FROM PRODUTOS PROD
WHERE PROD.CODIGO = '5000') AS SUBQ


Select Codigo, Total1, Total2, Total3-Total4 As Diferenca 
from 
(
 Select Codigo, Total1, Total2,
 Total3=Total1-Total2,
 Total4=Total1+Total2
  From Teste3) 
Teste3


Select Total1-Total2 As Diferenca
from
( 
  Select Total1=1+1,
            Total2=2+2
) teste


***** CTE *****

WitH SUBQ (codigo, total1, Total3, Total4)
AS
(
 Select Codigo, Total1, 
 Total3=Total1-Total2,
 Total4=Total1+Total2
  From Teste3
) 

SELECT

codigo, Total1, Total3, Total4, Total3 - total4 AS DIFERENCA

FROM SUBQ