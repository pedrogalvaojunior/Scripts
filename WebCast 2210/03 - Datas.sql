-- Muda o contexto do banco de dados
USE DBQueryPlus;

-- Retorna a tabela de datas
-- Há meses faltantes
SELECT Data, TotalVendido FROM tblVendasConsolidadas

-- Cria variáveis para capturar a menor e a maior data
-- O intervalo é entre 06/2007 e 08/2008
DECLARE @MenorData SMALLDATETIME, @MaiorData SMALLDATETIME

SELECT @MenorData = MIN(Data), @MaiorData = MAX(Data)
FROM tblVendasConsolidadas
WHERE Data >= '20070601' AND Data < '20080901'

-- Monta uma tabela de datas em seqüência
SELECT DATEADD(M,Num,@MenorData)
FROM dbo.FNRetNum(15)

-- Monta o intervalo de datas "necessário"
SELECT DATEADD(M,Num,@MenorData)
FROM dbo.FNRetNum(DATEDIFF(M,@MenorData,@MaiorData))

-- Monta o intervalo de datas com correções
SELECT DATEADD(M,Num-1,@MenorData)
FROM dbo.FNRetNum(DATEDIFF(M,@MenorData,@MaiorData)+1)





















-- Faz um JOIN do intervalo de datas com as datas vigentes
-- O LEFT OUTER para considerar todas as datas do intervalo
;WITH Datas (DataRef) AS (
SELECT DATEADD(M,Num-1,@MenorData)
FROM dbo.FNRetNum(DATEDIFF(M,@MenorData,@MaiorData)+1))

SELECT DataRef, ISNULL(TotalVendido,0) As ValorVendido
FROM Datas AS D
LEFT OUTER JOIN tblVendasConsolidadas AS V ON D.DataRef = V.Data