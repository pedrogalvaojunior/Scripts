Create Table Saldos
 (Codigo Int,
  Data Date,
  Saldo Float)
Go

Insert Into Saldos 
Values (1, '2019/08/30', 800.00),
		    (1, '2019/09/20', 1200.00),
            (2, '2018/08/31', 200.00),
            (2,  '2019/09/28', 800.00)
Go

Insert Into Saldos 
Values (1, '2019/08/30',  800),
            (1, '2019/09/20',  1200),
            (2, '2019/08/31',  200),
            (2, '2019/09/28',  800),
            (3,  '2019/08/25', 250)
Go

Select * From Saldos
Go

-- Definindo a Maior Data Por Codigo --
;With CTEMaiorDataPorCodigo (Codigo, MaiorData)
As
(
 Select Codigo, Max(Data) As MaiorData From Saldos
 Group By Codigo
),
-- Definindo o último Saldo Por Codigo --
CTEUltimoSaldoPorCodigo (Codigo, Data, UltimoSaldo)
As
(
 Select S.Codigo, S.Data, LAST_VALUE(S.Saldo) Over (Partition By S.Codigo Order By S.Data) As UltimoSaldo
 From Saldos S Inner Join CTEMaiorDataPorCodigo C
                                          On C.Codigo = S.Codigo
										  And C.MaiorData = S.Data
 Group By S.Codigo, S.Data, S.Saldo
),
-- Definindo a Faixa de Datas --
CTEFaixasDeDatas (Codigo, DataInicial, DataFinal)
As
(
 Select Codigo, Min(Data), Max(Data) From Saldos                                                                         
 Group By Codigo
)
-- Trazendo os resultados --
Select C.Codigo, 
           Case 
		   When (CT.DataInicial < CT.DataFinal) Then CT.DataFinal
		   Else DateAdd(Month,1,CT.DataInicial)
		   End As 'Mês de Transporte',
		   CU.UltimoSaldo
From CTEMaiorDataPorCodigo C Inner Join CTEUltimoSaldoPorCodigo CU
													  On CU.Codigo = C.Codigo
													 Inner Join CTEFaixasDeDatas CT
													  On CT.Codigo = CU.Codigo
													  
