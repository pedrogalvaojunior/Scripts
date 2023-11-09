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

-- Utilizando a Windows Function First_Value --
SELECT Col1, 
       FIRST_VALUE(Col1) OVER(ORDER BY Col1) AS 'FIRST'
FROM Tab1


-- Utilizando a Windows Function Last_Value --
SELECT Col1, 
       LAST_VALUE(Col1) OVER(ORDER BY Col1 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'LAST'   
FROM Tab1