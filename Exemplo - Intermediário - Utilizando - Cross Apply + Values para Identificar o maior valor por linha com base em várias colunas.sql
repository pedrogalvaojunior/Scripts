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

-- Montando o Select -- Utilizando operador Cross Apply em conjunto o Values --
Select Max(ColunasEmLinha.Valores) As MaiorValor, 
           Id_Equipamento, 
		   Tensao  
From Tabela T Cross Apply (Values (T.A), 
                                                         (T.B),  
														 (T.C), 
														 (T.D)
											) As ColunasEmLinha(Valores)
Group By Id_Equipamento, Tensao
Go
