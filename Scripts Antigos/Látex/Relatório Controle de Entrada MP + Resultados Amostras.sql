SELECT 
       CMP.CODANTIGO,
       CMP.APELIDO "DescricaoProduto",
       UNI.DESCRICAO "UnidadePadrao"
FROM CTENTRADA_PQC PQC INNER JOIN PRODUTOSQUIMICOS PQ
                                                  ON PQC.NUMCADASTRO = PQ.NUMCADASTRO
                                                 INNER JOIN EMP100..CMPPRODUTOS CMP
                                                  ON PQ.CODSEQUENCIALPRODUTO = CMP.CODPRODSEQUENCIAL
                                                 INNER JOIN EMP100..GERUNIDADES UNI
                                                  ON CMP.UNIDESTOQUE = UNI.CODIGO
Where MONTH(PQC.DATAALMOX)=MONTH(GETDATE())-1
Order By PQC.CODSEQUENCIAL DESC

SELECT
       PQ.CODSEQUENCIALPRODUTO,
       CMP.CODANTIGO,
       CMP.APELIDO "DescricaoProduto",
       UNI.DESCRICAO "UnidadePadrao",
       PQC.DATAALMOX,
       PQC.NUMNTFISCAL,
       PQC.QUANTIDADE,
       PQC.DATAVALIDADE,
       PQC.NUMLOTE,
       PQC.NUMMP,
       CASE PQC.STATUS
        WHEN 'E' THEN 'Em análise'
        WHEN 'A' THEN 'Aprovado'
        WHEN 'R' THEN 'Reprovado'
      END AS Status,
       PQC.DATALAB,
       PQC.DATALIBERACAO,
       CASE PQC.STATUS_LAUDO
         WHEN 'S' THEN 'Sim'
         WHEN 'N' THEN 'Não'
       End STATUS_LAUDO,
       CASE PQC.STATUS_UTILIZACAO 
          WHEN 'U' THEN 'Utilizado'
          WHEN 'D' THEN 'Devolvido'
       End STATUS_UTILIZACAO,
       PQC.CODRESPONSAVEL
FROM CTENTRADA_PQC PQC INNER JOIN PRODUTOSQUIMICOS PQ
                                                  ON PQC.NUMCADASTRO = PQ.NUMCADASTRO
                                                 INNER JOIN EMP100..CMPPRODUTOS CMP
                                                  ON PQ.CODSEQUENCIALPRODUTO = CMP.CODPRODSEQUENCIAL
                                                 INNER JOIN EMP100..GERUNIDADES UNI
                                                  ON CMP.UNIDESTOQUE = UNI.CODIGO
Order By PQC.CODSEQUENCIAL DESC

SELECT ME.DESCRICAO,
            CME.CLASSE+' - '+CONVERT(VARCHAR(4),ME.CODIGO) As "CodClasses", 
            PQCx.PADRAO_MINIMO,
            PQCx.PADRAO_MAXIMO,
            ME.UNIDADE,
            PQCRe.AMOSTRA,
            PQCRe.NUMMP,
            PQCRe.CODSEQUENCIALMETODO
 FROM METODOS_ENSAIOS ME INNER JOIN CLASSIFICACAO_ME CME
                          ON ME.NUMCLASSE = CME.CODIGO
                         INNER JOIN PQCxME PQCx
                          ON PQCx.CODSEQUENCIALMETODO = ME.CODIGO
                         INNER JOIN CTENTRADA_PQC_RESULTADOS PQCRe
                          ON PQCRe.NUMMP = '0002/06'
                          AND PQCRe.CODSEQUENCIALMETODO = ME.CODIGO
WHERE PQCx.CODSEQUENCIALPRODUTO = 340