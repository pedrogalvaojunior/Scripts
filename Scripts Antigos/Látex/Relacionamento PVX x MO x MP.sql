Select CTPVMI.NUMCONTROLE, 
         MO.DescricaoProduto, 
         MO.DataEntrada_LAB, 
         MO.DataLiberacao, 
         'MO' As Sigla
from CTProducao_PVM_Items CTPVMI Inner Join CTProducao_Moinho MO
                                                    ON CTPVMI.NUMCONTROLE = MO.NUMMO
Where CTPVMI.NUMPVM = '0033/08'
And     CTPVMI.CodSigla = 'MO'
Union
Select CTPVMI.NUMCONTROLE, 
         MP.Descricao, 
         MP.DataLAB, 
         MP.DataLiberacao, 
         'MP' As Sigla
from CTProducao_PVM_Items CTPVMI Inner Join CTEntrada_PQC MP
                                                    ON CTPVMI.NUMCONTROLE = MP.NUMMP
Where CTPVMI.NUMPVM = '0033/08'
And     CTPVMI.CodSigla = 'MP'
Order By CTPVMI.NumControle DESC


exec dbo.P_RegistroHistorico_PesquisaMovimentacaoParcial '0033/08'

Select * from CTProducao_PVM_Items
Where NUMPVM='0033/08'

exec P_RegistroHistorico_ResumoResultadosPVMxMO '0067/08'

Select Distinct NumControle, DescricaoProduto, DataEntrada, DataLiberacao, CodSigla from CTProducao_RegistroHistoricoParcial 
Order By NumControle Desc, CodSigla


