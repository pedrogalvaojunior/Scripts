Use MSTechDay
Go

Declare @Estados TABLE (Sigla CHAR(2), NomeEstado VARCHAR(50))

INSERT INTO @Estados 
VALUES 
('AC','Acre'), ('BA','Bahia'),
('CE','Cear�'), ('DF','Distrito Federal'), 
('AL','Alagoas'), ('SP','S�o Paulo'),
('RJ','Rio de Janeiro'), ('GO','Goi�s')

SELECT Sigla As UF, NomeEstado FROM @Estados
ORDER BY Sigla OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY;
-- Retorna AC (Acre), AL (Alagoas)

SELECT Sigla As UF, NomeEstado FROM @Estados
ORDER BY Sigla OFFSET 5 ROWS FETCH NEXT 1 ROWS ONLY;
-- Retorna GO (Goi�s)
