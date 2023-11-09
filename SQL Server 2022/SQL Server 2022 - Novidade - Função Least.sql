-- Exemplo 1 -- Menor Número --
SELECT LEAST ( '6.62', 3.1415, N'7' ) AS LeastVal 
Go

-- Exemplo 2 -- Menor Palavra --
SELECT LEAST ('Glacier', N'Joshua Tree', 'Mount Rainier') AS LeastString  
Go

-- Exemplo 3 -- Varivéis locais --
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
WHERE Correlation < LEAST(@PredictionA, @PredictionB) 
Go

-- Exemplo 4 -- Colunas, Constantes e Variáveis Locais --
CREATE TABLE dbo.studies 
(VarX varchar(10) NOT NULL,    
 Correlation decimal(4, 3) NULL)
Go

INSERT INTO dbo.studies VALUES ('Var1', 0.2), ('Var2', 0.825), ('Var3', 0.61) 
Go 

DECLARE @VarX decimal(4, 3) = 0.59

SELECT VarX, Correlation, LEAST(Correlation, 1.0, @VarX) AS LeastVar  
FROM dbo.studies
GO 