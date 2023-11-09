SELECT V.CODPESSOA, 
           PP.NOME,
           CONVERT(CHAR(10),PP.DTNASCIMENTO,103) AS DTNASCIMENTO,
           V.CODFUNCAO,
           PF.NOME AS 'FUNÇÃO',
           VP.CODSECAO,
           PS.DESCRICAO AS 'SEÇÃO',
           VP.CODPOSTOTRABALHO,
           SUBSTRING(VPT.DESCRICAO,1,5) AS 'LOCAL',
           SUBSTRING(VPT.DESCRICAO,7,LEN(VPT.DESCRICAO)) AS 'POSTO TRABALHO'
FROM VRECRUTAMENTO V LEFT JOIN PFUNC P
                                     ON V.CODPESSOA = P.CODPESSOA
									LEFT JOIN PPESSOA PP
                                     ON PP.CODIGO = V.CODPESSOA
                                    LEFT JOIN VREQUISICAOPESSOAL VP
                                      ON VP.IDREQUISICAO = V.IDREQUISICAO
                                    LEFT JOIN PFUNCAO PF
                                      ON PF.CODIGO = V.CODFUNCAO
                                    LEFT JOIN PSECAO PS
                                      ON PS.CODIGO = VP.CODSECAO
                                    LEFT JOIN VPOSTOTRABALHO VPT
                                      ON VPT.CODPOSTO = VP.CODPOSTOTRABALHO
