DECLARE @var VARCHAR(100)
SET @var = 'Conhecendo, cada, vez, mais, os segredos, do SQL Server.....' 

SELECT
	SUBSTRING	(',' + @var + ',',Number + 1,CHARINDEX	(',',',' + @var + ',',Number + 1	) - Number - 1) as value
FROM master..spt_values
WHERE Number >= 1
AND Number < LEN(',' + @var + ',') - 1
AND SUBSTRING(',' + @var + ',', Number, 1) = ','
AND type = 'P'
ORDER BY Number