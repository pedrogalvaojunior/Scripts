Set DateFormat DMY

SELECT DATATESTE,
           MES= CASE 
                    WHEN DATEPART(MONTH,DATATESTE)='4' THEN 'ABRIL'
                    WHEN DATEPART(MONTH,DATATESTE)='5' THEN 'MAIO'
                    WHEN DATEPART(MONTH,DATATESTE)='6' THEN 'JUNHO'
                   END
FROM CTBALOES
WHERE MONTH(DATATESTE) BETWEEN '4' AND '6'


select datediff(year,28/04/1980,getdate()) as anos

select datediff(day,datarevisao,dataproducao) as anos from ctluvas
where datarevisao>='01/01/2004'