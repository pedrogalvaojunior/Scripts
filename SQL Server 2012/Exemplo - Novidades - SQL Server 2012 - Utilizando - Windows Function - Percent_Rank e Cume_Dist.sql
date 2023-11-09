Use Master
Go

-- Criando a Tabela Tab1 --
CREATE TABLE Tab1 
(Col1 INT) 
GO

-- Inserindo os dados na Tabela Tab1 00
INSERT INTO Tab1 
VALUES(5), (5), (3) , (1) 
GO

-- Utilizando a Windows Function Percent_Rank --
SELECT Col1, 
       PERCENT_RANK() OVER(ORDER BY Col1) AS 'PERCENT_RANK()',
       RANK() OVER(ORDER BY Col1) AS 'RANK()',
       (SELECT COUNT(*) FROM Tab1) 'COUNT'   
FROM Tab1


-- Utilizando a Windows Function Cume_Dist --
SELECT Col1, 
       CUME_DIST() OVER(ORDER BY Col1) AS 'CUME_DIST()'   
FROM Tab1