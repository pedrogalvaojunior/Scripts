-- Criando a Tabela --
Create Table Tabela
(A Float,
 B Float,
 C Float,
 D Float,
 Id_Equipamento Int,
 Tensao Float)
Go

-- Inserindo valores apresentados --
Insert Into Tabela 
Values (0.22, 2, 0.55, 3, 1, 0.22),
            (10, 2, 3, 7, 1, 13.8),
            (10, 12, 5, 15, 2, 345)
Go

-- Montando o Select Derivado com operador Union --
Select Max(Maior.A) As MaiorValorPorLinha, 
           Id_Equipamento, 
		   Tensao
From (
		   Select A, Id_Equipamento, Tensao From Tabela
		   Union
		   Select B, Id_Equipamento, Tensao From Tabela
		   Union
		   Select C, Id_Equipamento, Tensao From Tabela
		   Union
		   Select D, Id_Equipamento, Tensao From Tabela
		  ) As Maior
Group By Id_Equipamento, Tensao
Go