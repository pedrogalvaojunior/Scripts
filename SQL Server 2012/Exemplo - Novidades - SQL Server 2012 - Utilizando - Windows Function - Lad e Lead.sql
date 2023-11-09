Use MsTechDay
Go

-- Declarando a variável do tipo Table --
DECLARE @Valores TABLE 
 (Data DATE, 
 Valor DECIMAL(4,2))


 -- Inserindo valores na variável --
INSERT INTO @Valores 
VALUES ('2012-04-01',0.55),
('2012-05-01',4.07), ('2012-06-01',10.22),
('2012-07-01',2.59), ('2012-08-01',5.29)

-- Utilizando as Windows Function Lag e Lead --
SELECT Data, Valor,
LAG(Valor) OVER (ORDER BY Data) As 'Posição Inicial',
LEAD(Valor) OVER (ORDER BY Data) As 'Posição Posterior',
LAG(Valor,2) OVER (ORDER BY Data) As 'Posição Intermediária',
LEAD(Valor,3) OVER (ORDER BY Data) As 'Posição Final'
FROM @Valores
