-- Criando o Banco de Dados --
Create Database NewSQLServer2016
Go

-- Acessando o Banco de Dados --
Use NewSQLServer2016
Go

-- Passo 1 - Criando uma nova Partition Function --
CREATE PARTITION FUNCTION [PFRegistro] (int)
AS RANGE RIGHT FOR VALUES
(10000, 30000, 
 50000, 70000, 
 90000);
Go

-- Passo 2 - Criando um novo Partition Schema --
CREATE PARTITION SCHEME [PSRegistro]
AS PARTITION [PFRegistro]
TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY]);
 
-- Passo 3 - Criando a tabela TabelaParticionada --
CREATE TABLE dbo.TabelaParticionada
(NumRegistro INT NOT  NULL,
 Dados char(1000) NULL,
 DataCadastro datetime NOT NULL) 
ON [PSRegistro](NumRegistro)
GO
 
-- Passo 4 - Populando a Tabela - TabelaParticionada --
INSERT dbo.TabelaParticionada
SELECT TOP 10000
    s1.number * 1000  +  s2.number * 100 + s1.number  As NumRegistro,
    Replicate('SQL Server 2016 ',S2.number+1) As  Dados, 
	GETDATE()+S2.number As DataCadastro
FROM master..spt_values s1 CROSS JOIN master..spt_values s2 
WHERE s1.number BETWEEN 0 AND 999 AND s1.type = 'P'
AND s2.number BETWEEN 0 AND 99 AND s2.type = 'P'


-- Passo 5 - Obtendo a lista de Partitions criadas para TabelaParticionada --
SELECT
   $PARTITION.[PFRegistro] (NumRegistro) AS 'Partition',
   COUNT(*) AS TotalRegistros,
   MIN(NumRegistro) AS RegistroInicial,
   MAX(NumRegistro) AS RegistroFinal
FROM dbo.TabelaParticionada
GROUP BY $PARTITION.[PFRegistro] (NumRegistro)
Go

-- Passo 6 - Realizando a exclusao da particao 1 e tambem da particao 4 ate particao 6 --
TRUNCATE TABLE dbo.TabelaParticionada
WITH (PARTITIONS (2, 4 TO 6));
Go