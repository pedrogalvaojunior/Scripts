Set NoCount On

Select ''''+CT.LoteProducao+''','''+''+
         CASE LEN(CT.LoteInterno)
          WHEN 1 THEN REPLICATE('0',2)+Convert(VarChar(3),CT.LoteInterno)+''','''
          WHEN 2 THEN REPLICATE('0',1)+Convert(VarChar(3),CT.LoteInterno)+''','''
          WHEN 3 THEN Convert(VarChar(3),CT.LoteInterno)+''','''
         End+
         CASE LEN(CT.CodProduto)
          WHEN 6 THEN Convert(VarChar(13),CT.CodProduto)+REPLICATE('0',7)+''','''
          WHEN 7 THEN Convert(VarChar(13),CT.CodProduto)+REPLICATE('0',6)+''','''
          End+''+
          Convert(VarChar(10),INS.Data,112)+''','+''''+
          SUBSTRING(INS.STATUSLOTE,1,1)+''''
FROM CTLUVAS CT INNER JOIN INSPECAOLUVAS INS
                           ON CT.LOTEPRODUCAO = INS.LOTEPRODUCAO
                           AND SUBSTRING(CONVERT(VARCHAR(7),CT.CODPRODUTO),1,3) = INS.CODPRODUTO
ORDER BY INS.LOTEPRODUCAO, CT.LOTEINTERNO



