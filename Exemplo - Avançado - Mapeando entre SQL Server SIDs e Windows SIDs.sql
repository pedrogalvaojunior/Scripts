-- Criando Tabela para armazenar Numeração --
CREATE TABLE dbo.TinyNumbers(Number TINYINT PRIMARY KEY);
Go

-- Inserindo numeração sequência de valores para mapear ID --
INSERT dbo.TinyNumbers(Number) 
SELECT TOP (256) ROW_NUMBER() OVER (ORDER BY number)-1 
FROM master.dbo.spt_values;
Go

-- Criando a Função para Obter o Windows SIDs --
CREATE FUNCTION dbo.GetWindowsSID (@sid VARBINARY(85))
RETURNS TABLE
WITH SCHEMABINDING
AS
  RETURN 
  (SELECT ADsid = STUFF((SELECT '-' + part FROM 
    (SELECT Number = -1, part = 'S-' 
            + CONVERT(VARCHAR(30),CONVERT(TINYINT,CONVERT(VARBINARY(30),LEFT(@sid,1)))) 
            + '-' 
            + CONVERT(VARCHAR(30),CONVERT(INT,CONVERT(VARBINARY(30),SUBSTRING(@sid,3,6))))
      UNION ALL
      SELECT TOP ((LEN(@sid)-5)/4) Number, 
             part = CONVERT(VARCHAR(30),CONVERT(BIGINT,CONVERT(VARBINARY(30), 
             REVERSE(CONVERT(VARBINARY(30),SUBSTRING(@sid,9+Number*4,4)))))) 
      FROM dbo.TinyNumbers 
	  ORDER BY Number
     ) AS x ORDER BY Number
       FOR XML PATH(''), TYPE).value(N'.[1]','nvarchar(max)'),1,1,'')
  );
Go

-- Criando View para relacionar SQL Servers SIDs com Windows SIDs --
CREATE VIEW dbo.server_principal_sids
AS
  SELECT sp.name, sp.[sid], ad.ADsid, sp.type_desc
    FROM sys.server_principals AS sp
    CROSS APPLY dbo.GetWindowsSID(sp.[sid]) AS ad
    WHERE [type] IN ('U','G') 
    AND LEN([sid]) % 4 = 0;
Go

-- Retornando os SIDs mapeados --
SELECT name,
       [sid],
	   ADSid,
	   type_desc 
FROM dbo.server_principal_sids;
Go