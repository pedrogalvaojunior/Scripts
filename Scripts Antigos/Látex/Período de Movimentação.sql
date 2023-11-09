SELECT DISTINCT(CT.NUMFICHA),
                         CT.CODPROD, 
                         CTB.DESCRICAOPROD,
                         'de: '+CAST(DAY(MIN(EDATA)) AS VARCHAR(2))+'/'+                         
                         CASE MONTH(MIN(EDATA))
                          When 1 Then 'Jan'
                          When 2 Then 'Fev'
                          When 3 Then 'Mar'
                          When 4 Then 'Abr'
                          When 5 Then 'Mai'
                          When 6 Then 'Jun'
                          When 7 Then 'Jul'
                          When 8 Then 'Ago'
                          When 9 Then 'Set'
                          When 10 Then 'Out'
                          When 11 Then 'Nov'
                          When 12 Then 'Dez'
                         END+'/'+CAST(YEAR(MIN(EDATA)) AS VARCHAR(4))+' até: '+
                         CAST(DAY(MAX(EDATA)) AS VARCHAR(2))+'/'+                         
                         CASE MONTH(MAX(EDATA))
                          When 1 Then 'Jan'
                          When 2 Then 'Fev'
                          When 3 Then 'Mar'
                          When 4 Then 'Abr'
                          When 5 Then 'Mai'
                          When 6 Then 'Jun'
                          When 7 Then 'Jul'
                          When 8 Then 'Ago'
                          When 9 Then 'Set'
                          When 10 Then 'Out'
                          When 11 Then 'Nov'
                          When 12 Then 'Dez'
                         END+'/'+CAST(YEAR(MAX(EDATA)) AS VARCHAR(4)) AS PERIODO
FROM CUSTO CT INNER JOIN CUSTOTAB CTB
                              ON CT.CODPROD=CTB.CODPROD
WHERE CT.CODPROD= '2 181/183'
GROUP BY CT.NUMFICHA, CT.CODPROD, CTB.DESCRICAOPROD
ORDER BY CT.NUMFICHA

