-- Exemplo - Arquivo - Formato.fmt --
11.0
2
1	SQLCHAR		0	1000	") "	1	Col1	""
2	SQLCHAR		0	1000	"\r\n "	2	Col2	""


-- Utilizando o Bulk Insert ---
SELECT TXT.* 
INTO #TB_AUX
FROM OPENROWSET( BULK 'e:\temp\teste.txt', FORMATFILE = 'e:\temp\formato.fmt') AS TXT;

-- Utilizando a função Replace para substituir caracteres --
SELECT
	REPLACE(COL1, '(','') AS Coluna1,
	REPLACE(REPLACE(COL2, '(',''), ')','') AS Coluna1
FROM #TB_AUX
GO