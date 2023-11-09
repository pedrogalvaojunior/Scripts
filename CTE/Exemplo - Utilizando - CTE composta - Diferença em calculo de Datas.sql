Declare @Tabela Table
(IdEmpregado int, Admissao date, Demissao date);

Insert Into @Tabela 
Values (1,'20000101','20001201'),
	   (1,'20000601','20010601'),
       (1,'20010101','20011201'),
       (2,'20100101','20101231'),
       (2,'20101201','20110131'),
       (2,'20100201','20100330');

With CTE_RN 
As
(Select *,
        ROW_NUMBER() OVER(PARTITION BY IdEmpregado ORDER BY Admissao, Demissao DESC) as RN
 From @Tabela
),
    
CTE_Rec 
As
(Select IdEmpregado,
        DATEDIFF(DAY, Admissao, Demissao) + 1 as QtdDias,
        RN,
        Demissao as DemissaoAnt
From CTE_RN
Where RN = 1
          
Union all
        
Select rn.IdEmpregado,
       Case When rn.Demissao > rec.DemissaoAnt Then DATEDIFF(DAY, Case When rn.Admissao > rec.DemissaoAnt Then rn.Admissao 
	                                                               Else DATEADD(DAY, 1, rec.DemissaoAnt) 
																   End, rn.Demissao) + 1
        Else 0
       End,
       rn.RN,
       Case When rn.Demissao > rec.DemissaoAnt then rn.Demissao Else rec.DemissaoAnt End
From CTE_Rec as rec Inner Join CTE_RN as rn
                     On rn.IdEmpregado = rec.IdEmpregado 
					 And rn.RN = rec.RN + 1      
)
    
Select IdEmpregado,
       SUM(QtdDias) as QtdDias
From CTE_Rec
Group by IdEmpregado