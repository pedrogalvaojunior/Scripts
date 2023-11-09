-- Exemplo 1 -- Maior Número --
SELECT GREATEST ( '6.62', 3.1415, N'7' ) AS GreatestVal 
Go

-- Exemplo 2 -- Maior Palavra --
SELECT GREATEST ('Glacier', N'Joshua Tree', 'Mount Rainier') AS GreatestString  
Go

-- Exemplo 3 -- Variáveis locais --
CREATE TABLE dbo.studies
(VarX varchar(10) NOT NULL,    
 Correlation decimal(4, 3) NULL)
Go

INSERT INTO dbo.studies VALUES ('Var1', 0.2), ('Var2', 0.825), ('Var3', 0.61) 
Go

DECLARE @PredictionA DECIMAL(2,1) = 0.7  
DECLARE @PredictionB DECIMAL(3,1) = 0.65  

SELECT VarX, Correlation  
FROM dbo.studies 
WHERE Correlation > GREATEST(@PredictionA, @PredictionB) 
Go

-- Exemplo 4 -- Colunas, Constantes e Variáveis Locais --
CREATE TABLE dbo.studies 
(VarX varchar(10) NOT NULL,    
 Correlation decimal(4, 3) NULL)
Go

INSERT INTO dbo.studies VALUES ('Var1', 0.2), ('Var2', 0.825), ('Var3', 0.61) 
Go 

DECLARE @VarX decimal(4, 3) = 0.59  

SELECT VarX, Correlation, GREATEST(Correlation, 0, @VarX) AS GreatestVar  
FROM dbo.studies
Go

