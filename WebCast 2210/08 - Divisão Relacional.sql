-- Muda o contexto de banco de dados
USE DBQueryPlus;

-- Selecionar todos os clientes que tenham carro da GM e da Volks
-- O SELECT abaixo falha no resultado
-- Felipe não tem carro da GM e Wagner não tem carro da Volks
SELECT NomeCliente, CarroModelo, CarroMarca
FROM tblClientes AS CL
INNER JOIN tblCarros AS CR ON CL.ClienteID = CR.ClienteID
WHERE CR.CarroMarca IN ('GM','Volks')

-- O SELECT abaixo também falha
-- É impossível um carro ser da Volks e da GM
SELECT NomeCliente, CarroModelo, CarroMarca
FROM tblClientes AS CL
INNER JOIN tblCarros AS CR ON CL.ClienteID = CR.ClienteID
WHERE CR.CarroMarca = 'GM' AND CR.CarroMarca = 'Volks'

















-- Possível solução com duas consultas
-- Selecionar todos que tem carros da GM
SELECT ClienteID FROM tblCarros WHERE CarroMarca = 'GM'
INTERSECT -- Fazer a interseção
-- Selecionar todos que tem carros da Volks
SELECT ClienteID FROM tblCarros WHERE CarroMarca = 'Volks'

-- Juntando tudo
;WITH ClientesGMVolks AS (
SELECT ClienteID FROM tblCarros WHERE CarroMarca = 'GM'
INTERSECT -- Fazer a interseção
-- Selecionar todos que tem carros da Volks
SELECT ClienteID FROM tblCarros WHERE CarroMarca = 'Volks')

SELECT NomeCliente, CarroModelo, CarroMarca
FROM tblClientes AS CL
INNER JOIN ClientesGMVolks AS GV ON CL.ClienteID = GV.ClienteID
INNER JOIN tblCarros AS CR ON CL.ClienteID = CR.ClienteID




















-- Pivoteamento
SELECT ClienteID, [Volks], [GM]
FROM (SELECT ClienteID, CarroMarca FROM tblCarros) AS ST
PIVOT (COUNT(CarroMarca) FOR CarroMarca IN ([Volks], [GM])) AS PT
WHERE Volks >= 1 AND GM >= 1


SELECT NomeCliente, CarroModelo, CarroMarca
FROM tblClientes AS CL
INNER JOIN tblCarros AS CR ON CL.ClienteID = CR.ClienteID
WHERE  CL.ClienteID IN (

SELECT ClienteID--, [Volks], [GM]
FROM (SELECT ClienteID, CarroMarca FROM tblCarros) AS ST
PIVOT (COUNT(CarroMarca) FOR CarroMarca IN ([Volks], [GM])) AS PT
WHERE Volks >= 1 AND GM >= 1)



















-- Subquery
WITH CGV AS (
SELECT ClienteID FROM tblCarros
WHERE CarroMarca IN ('GM','Volks')
GROUP BY ClienteID
HAVING COUNT(DISTINCT CarroMarca) = 2
)

SELECT NomeCliente, CarroModelo, CarroMarca
FROM tblClientes AS CL
INNER JOIN tblCarros AS CR ON CL.ClienteID = CR.ClienteID
WHERE EXISTS
(SELECT * FROM CGV WHERE CL.ClienteID = CGV.ClienteID)



