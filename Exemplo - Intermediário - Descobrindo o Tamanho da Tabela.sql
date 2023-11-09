-- Exemplo 1 --
SELECT OBJECT_NAME(ID) TABELA, CONVERT(DEC(15),SUM(RESERVED)) RESERVED
INTO #X
FROM SYSINDEXES
WHERE indid in (0, 1, 255)
GROUP BY ID

SELECT TABELA, LTRIM(STR(RESERVED * D.LOW / 1024., 15, 0)) + ' KB'
FROM #X, master.dbo.spt_values d
where d.number = 1
and d.type = 'E'
ORDER BY RESERVED DESC

-- Exemplo 2 --
SELECT
     OBJECT_NAME(object_id) As Tabela, 
	 Rows As Linhas,
     SUM(Total_Pages * 8) As Reservado,
     SUM(CASE WHEN Index_ID > 1 THEN 0 
	           ELSE Data_Pages * 8 END) As Dados,
     SUM(Used_Pages * 8) - SUM(CASE WHEN Index_ID > 1 THEN 0 
	                                                  ELSE Data_Pages * 8 END) As Indice,
     SUM((Total_Pages - Used_Pages) * 8) As NaoUtilizado
 FROM
     sys.partitions As P
     INNER JOIN sys.allocation_units As A ON P.hobt_id = A.container_id
 GROUP BY OBJECT_NAME(object_id), Rows
 ORDER BY Tabela