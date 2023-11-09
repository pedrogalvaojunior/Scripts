Create Table Importacao
(TipoLinha Char(4),
 Formular Varchar(10) Default Null,
 AnoInicio Int)
Go

Insert Into Importacao (TipoLinha, AnoInicio)
Values ('RPFI',2016)
Go

Insert Into Importacao (TipoLinha, AnoInicio)
Values ('RPFP',Null)
Go 4

Insert Into Importacao (TipoLinha, AnoInicio)
Values ('RPFI',2017)
Go

Insert Into Importacao (TipoLinha, AnoInicio)
Values ('RPFP',Null)
Go 4

Insert Into Importacao (TipoLinha, AnoInicio)
Values ('RPFM',Null), ('RPFT',Null)
Go

-- Consultando os dados --
Select * From Importacao
Go

;With Numeracao (NumeroLinha, TipoLinha, Formula, AnoInicio)
As
(Select ROW_NUMBER() Over (Order By (Select 0)) As NumeroLinha,
            TipoLinha,
			Formular,
			AnoInicio
 From Importacao
)
Select N1.NumeroLinha, N1.TipoLinha, N1.Formula, N1.AnoInicio,
           Case When (N1.AnoInicio Is Null) Then (Select Top 1 AnoInicio From Numeracao 
		                                                                    Where TipoLinha = 'RPFI'
																			And NumeroLinha < N2.NumeroLinha
																		    Order By NumeroLinha Desc)
			 Else N2.AnoInicio
			End As NovaColuna
From Numeracao N1 Inner Join Numeracao N2
                                      On N1.NumeroLinha = N2.NumeroLinha

