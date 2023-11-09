Create Table Contas
(Id Int Primary key Identity(1,1),
 Conta Varchar(20) Not Null,
 Valor Decimal(6,2) Not Null,
 Grupo Varchar(20) Not Null)
Go

Insert Into Contas (Conta, Valor, Grupo)
Values ('receitasvendasUN1' , 100, 'receitabruta'),
            ('receitasvendasUN2',70, 'receitabruta'),
            ('compramateriaprima1', 20, 'materiaprima'),
            ('saida impostos', 15,'Impostos')
Go

-- Obtendo a somatória por grupo --
;With CTESomarPorGrupo (Id, Grupo, SomatoriaGrupo)
As
(
Select Id, Grupo, Sum(Valor) Over (Partition By Grupo Order By Grupo Asc)
From Contas
Group By Id, Grupo, Valor
),
-- Obtendo a somatoria parcial
CTESomatoriaGeral (Id, Nivel1, Nivel2, Grupo, SomatoriaParcial)
As
(
Select Id,
           Lead(Id,1,0) Over (Order By Id Asc) As Nivel1,
           Lead(Id,2,0) Over (Order By Id Asc) As Nivel2,
           Grupo,
		   Sum(SomatoriaGrupo) As SomatoriaGeral
From CTESomarPorGrupo
Group By Id, Grupo
)
-- Obtendo as somatorias gerais
Select Concat(CT.Grupo, ' - ',CT1.Grupo, ' - ', CT2.Grupo) As Grupos,
           CT1.SomatoriaParcial As Grupo1,
           CT2.SomatoriaParcial As Grupo2,
		   (CT1.SomatoriaParcial+CT2.SomatoriaParcial) As 'Total Parcial',
		   (Select Sum(Valor) From Contas) As 'Somatória Geral',
		   (Select Sum(Valor)+CT1.SomatoriaParcial+CT2.SomatoriaParcial From Contas) As 'Somatória Geral Acumulado'
From CTESomatoriaGeral CT Inner Join CTESomatoriaGeral CT1
												On CT1.Id = CT.Nivel1
											  Inner Join CTESomatoriaGeral CT2
											   On CT2.Id = CT.Nivel2
Order By CT.Id Desc
Go