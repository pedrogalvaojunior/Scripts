P_ACERTOSMOVIMENTACAO '2007','190076','15','117'

select codproduto, loteinterno, tamanho, peso, dataproducao, loteproducao from CTLUVAS2003
where loteproducao='357038'
order by loteinterno

DELETE CTLUVAS2007
WHERE LOTEPRODUCAO='204076' --and substring(convert(char(7),codproduto),1,3)='311'
AND   LOTEINTERNO IN (10)

declare @lote char(6)
set @lote='362036'

DELETE CTLUVAS2003
WHERE LOTEPRODUCAO=@lote --and substring(convert(char(7),codproduto),1,3)='311'
AND   LOTEINTERNO IN (Select LoteInterno from CTLUVAS2003 Where LOTEPRODUCAO=@lote 
                      Group by LOTEINTERNO Having Count(LoteInterno)>1)

Update CTLuvas2003
SET CODPRODUTO='4112200'
WHERE LOTEPRODUCAO='294035'
AND   CODPRODUTO like '211%'

P_CONTROLEPERDAPORLOTE2005 '128059'

Select * into #Lote from Ctluvas2003
where loteproducao='281035' and loteinterno <=10
order by loteinterno

UPDATE #LOTE
SET LOTEPRODUCAO='284035'

INSERT INTO CTLUVAS2003
Select * FROM #lote 
where CODPRODUTO like '211%'

DROP TABLE #LOTE

select Convert(Int,Convert(DateTime,'2006-06-23'))

Select Convert(Int,DataProducao,126) from InspecaoLuvas

Select DateDiff(Day,'2006-06-29 00:00:01','2006-06-30 00:00:00')

SELECT DATEADD(day, -30, getdate())