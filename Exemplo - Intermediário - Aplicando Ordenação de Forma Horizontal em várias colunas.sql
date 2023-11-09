-- Criando a Tabela --
Create Table OrdenacaoHorizontal
(Codigo Int Primary Key Identity(1,1),
 Tipo1 Char(1) Null,
 Tipo2 Char(1) Null,
 Tipo3 Char(1) Null,
 Tipo4 Char(1) Null,
 Tipo5 Char(1) Null)
Go

-- Inserindo --
Insert Into OrdenacaoHorizontal 
Values('B','D','A','F','X'),('A','D','C','S','E'),
           ('F','D','A','H','I'),('K','B','A','S','D'),
		   ('C','A','D','E','M')
Go

-- Criando a Ordenação Horizontal --
Select
    Codigo,
    [1] as Tipo1,
    [2] as Tipo2,
    [3] as Tipo3,
    [4] as Tipo4,
    [5] as Tipo5
From 
(
    Select Codigo, Tipo, Row_Number() Over(Partition By Codigo Order By Tipo) As RN
    From OrdenacaoHorizontal
    UnPivot (Tipo For TipoN In ([Tipo1], [Tipo2], [Tipo3], [Tipo4], [Tipo5])) As U) As F
Pivot (Max(Tipo) For RN In ([1], [2], [3], [4], [5])) As P
Go