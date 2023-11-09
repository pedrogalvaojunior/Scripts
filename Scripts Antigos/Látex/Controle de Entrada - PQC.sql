SELECT PQC.CODSEQUENCIAL,
             PQC.CODPRODUTO,     
             CMP.DESCRICAO "Descri��o do Produto",        
             UNI.DESCRICAO "Descri��o Unidade Padr�o",
             UNI.SIMBOLO "S�mbolo",
             PQC.DATAALMOX,
             PQC.DESCFORNEC "Raz�o Social - Fornecedor",
             PQC.NUMNTFISCAL,
             PQC.QUANTIDADE,
             PQC.DATAVALIDADE,
             PQC.NUMLOTE,
             PQC.OBSERVACAO,
             PQC.NUMMP
FROM CTENTRADA_PQC PQC INNER JOIN EMP100..CMPPRODUTOS CMP
                                                  ON PQC.CODPRODUTO = CMP.CODANTIGO
                                                 INNER JOIN EMP100..GERUNIDADES UNI
                                                  ON CMP.UNIDESTOQUE = UNI.CODIGO
Order By PQC.CODSEQUENCIAL DESC

SELECT CMP.CODANTIGO, 
       CMP.DESCRICAO, 
       UNI.DESCRICAO 
FROM EMP100..CMPPRODUTOS CMP INNER JOIN EMP100..GERUNIDADES UNI
                              ON CMP.UNIDESTOQUE = UNI.CODIGO
                                                                         

DROP PROCEDURE P_FORMATAR_NUMMP

ALTER TABLE CTENTRADA_PQC
 ADD ACAO VARCHAR(100)