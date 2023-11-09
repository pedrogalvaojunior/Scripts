SELECT * FROM CTBALOES
WHERE DATEPART(YEAR,DATATESTE)=SUBSTRING(CAST(GETDATE() AS CHAR(12)),8,4)

SELECT DAY(GETDATE()) AS DIA,
           MONTH(GETDATE()) AS MES,
           YEAR(GETDATE()) AS ANO

SELECT MAX(NUMTESTE) FROM CTBALOES
WHERE DATEPART(MONTH,DATATESTE)=MONTH(GETDATE())

DECLARE @NUMTESTE INT
SELECT @NUMTESTE=MAX(NUMTESTE) FROM CTBALOES
WHERE DATEPART(MONTH,DATATESTE)=MONTH(GETDATE())
PRINT @NUMTESTE
