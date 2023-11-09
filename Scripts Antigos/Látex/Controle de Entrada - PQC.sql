SELECT PQC.CODSEQUENCIAL,
             PQC.CODPRODUTO,     
             CMP.DESCRICAO "Descrição do Produto",        
             UNI.DESCRICAO "Descrição Unidade Padrão",
             UNI.SIMBOLO "Símbolo",
             PQC.DATAALMOX,
             PQC.DESCFORNEC "Razão Social - Fornecedor",
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