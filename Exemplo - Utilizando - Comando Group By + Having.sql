SELECT * FROM TABELA
WHERE MONTH(DIA) >=6 AND MONTH(DIA) <=9 (SELECT SUM(VOTOS) AS TOTAL FROM TABELA
GROUP BY MONTH(DIA)
HAVING MONTH(DIA) >=6 AND MONTH(DIA) <=9)
ORDER BY MONTH(DIA)
