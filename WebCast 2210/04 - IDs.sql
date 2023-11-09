-- Muda o contexto do banco de dados
USE DBQueryPlus;

-- Retorna a tabela de produtos com IDs ausentes
SELECT ProdutoID, ProdutoNome FROM tblProdutos

-- Captura o maior ID
DECLARE @MaxIDProduto INT
SET @MaxIDProduto = (SELECT MAX(ProdutoID) FROM tblProdutos)
SELECT @MaxIDProduto

-- Retorna todos os números existentes para esse intervalo
SELECT Num FROM dbo.FNRetNum(@MaxIDProduto)

-- Verifica os IDs não existentes
SELECT Num FROM dbo.FNRetNum(@MaxIDProduto)
WHERE Num NOT IN (SELECT ProdutoID FROM tblProdutos)

SELECT Num FROM dbo.FNRetNum(@MaxIDProduto) AS F
WHERE NOT EXISTS (
	SELECT ProdutoID FROM tblProdutos AS P
	WHERE F.Num = P.ProdutoID)













-- Solução de apresentação
SELECT ProdutoID + 1 AS Inicio,
  (SELECT MIN(ProdutoID) FROM tblProdutos AS P2
   WHERE P2.ProdutoID > P1.ProdutoID) - 1 AS Fim
FROM tblProdutos AS P1
WHERE NOT EXISTS
  (SELECT * FROM tblProdutos AS P2
   WHERE P2.ProdutoID = P1.ProdutoID + 1)
  AND ProdutoID < (SELECT MAX(ProdutoID) FROM tblProdutos AS P1);