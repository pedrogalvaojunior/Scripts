SELECT * FROM TABELA

SELECT NOME, DIA, SUM(VOTOS-VOTOS2) AS TOTAL,VOTOS2,VOTOS3,VOTOS4 FROM TABELA
WHERE MONTH(DIA) >=6 AND MONTH(DIA) <=9
GROUP BY NOME, DIA, VOTOS2,VOTOS3,VOTOS4

INSERT INTO TABELA(CODIGO,NOME,DIA,VOTOS)
VALUES(7,'TESTE',2002-08-27,78)



 