-- Selecionar o espaço ocupado por tabela sem considerar os índices --
SELECT
    OBJECT_NAME(object_id) As Tabela, 
	Rows As Linhas,
    Total_Pages * 8 As Reservado,
    Used_Pages * 8 As Utilizado,
    Data_Pages * 8 As Dados,
    (Total_Pages - Used_Pages) * 8 As NaoUtilizado
FROM
    sys.partitions As P
    INNER JOIN sys.allocation_units As A ON P.hobt_id = A.container_id
WHERE
    Index_ID IN (0,1) AND Object_ID IN
    (SELECT Object_ID FROM sys.tables)
ORDER BY Tabela 

-- Selecionar o espaço ocupado apenas pelos índices NonClustered --
SELECT
    OBJECT_NAME(P.object_id) As Tabela,
    I.Name As Indice,
    Rows As Linhas,
    Total_Pages * 8 As Reservado,
    Used_Pages * 8 As Utilizado,
    (Total_Pages - Used_Pages) * 8 As NaoUtilizado
FROM
    sys.partitions As P
    INNER JOIN sys.indexes As I ON P.object_id = I.object_id And P.Index_ID = I.Index_ID
    INNER JOIN sys.allocation_units As A ON P.hobt_id = A.container_id
WHERE
    P.Index_ID > 1 AND P.Object_ID IN
    (SELECT Object_ID FROM sys.tables)
ORDER BY
    Tabela, Indice 

-- Selecionar o espaço ocupado por tabela considerando os índices NonClustered --
SELECT
    OBJECT_NAME(object_id) As Tabela, Rows As Linhas,
    SUM(Total_Pages * 8) As Reservado,
    SUM(Used_Pages * 8) As Utilizado,
    SUM((Total_Pages - Used_Pages) * 8) As NaoUtilizado
FROM
    sys.partitions As P
    INNER JOIN sys.allocation_units As A ON P.hobt_id = A.container_id
WHERE
    Object_ID IN
    (SELECT Object_ID FROM sys.tables)
GROUP BY OBJECT_NAME(object_id), Rows
ORDER BY Tabela 
