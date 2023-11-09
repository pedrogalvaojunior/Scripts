Create Table Vendas
(CodigoVenda Int Primary Key Identity(1,1),
 Nome Varchar(20),
 Tipo Char(3) Default 'QRA',
 Data As (GetDate()+CodigoVenda))
Go

-- Inserindo Vendas Leonardo --
Insert Into Vendas (Nome) Values ('Leonardo')
Go 50

-- Inserindo Vendas Lincoln --
Insert Into Vendas (Nome) Values ('Lincoln')
Go 65

-- Inserindo Vendas Leonardo --
Insert Into Vendas (Nome) Values ('Antonio')
Go 120

-- Inserindo Vendas Lincoln --
Insert Into Vendas (Nome) Values ('Galvão')
Go 100

-- Exemplo 1 - Utilizando Subquery + Union para consultar as 3 vendas aleatórias de cada vendedor --
Select Nome,
           (Select Top 1 FIRST_VALUE(Data) Over (Partition By Nome Order By NewId()) From Vendas V1) As Datas,
           Tipo
From Vendas
Union
Select Nome,
           (Select Top 1 Lead(Data,1) Over (Partition By Nome Order By NewId()) From Vendas) As Datas,
		   Tipo
From Vendas

Union
Select Nome,
           (Select Top 1 Lead(Data,2) Over (Partition By Nome Order By NewId()) From Vendas) As Datas,
		   Tipo
From Vendas
Go

-- Exemplo 2 - Utitilizando CTEs adicionando a coluna CodigoVenda para consultar as 3 vendas aleatórias de cada vendedor --
;With CTEVenda1 (Data)
As
(
Select Distinct First_Value(Data) Over (Partition By Nome Order By NewId()) As Data From Vendas
),
CTEVenda2 (Data)
As
(
Select Distinct First_Value(Data) Over (Partition By Nome Order By NewId()) As Data From Vendas
),
CTEVenda3 (Data)
As
(
Select Distinct First_Value(Data) Over (Partition By Nome Order By NewId()) As Data From Vendas
)
Select V.CodigoVenda, V.Nome, V.Tipo, C.Data From CTEVenda1 C Left Join Vendas V
                                                                                                             On C.Data = V.Data
Union 

Select V.CodigoVenda, V.Nome, V.Tipo, C.Data From CTEVenda2 C Left Join Vendas V
                                                                                                             On C.Data = V.Data								
												
Union 

Select V.CodigoVenda, V.Nome, V.Tipo, C.Data As Datas
From CTEVenda3 C Left Join Vendas V
                                 On C.Data = V.Data			
Go																											 																											 

-- Exemplo 3 - Utilizando uma única CTE aplicando a junção a esquerda --
;With CTEVenda (Datas)
As
(
Select Distinct First_Value(Data) Over (Partition By Nome Order By NewId()) As Data 
From Vendas

Union

Select Distinct First_Value(Data) Over (Partition By Nome Order By NewId()) As Data
From Vendas

Union 

Select Distinct First_Value(Data) Over (Partition By Nome Order By NewId()) As Data
From Vendas
)
Select V.CodigoVenda, V.Nome, V.Tipo, Format(V.Data, 'dd/MM/yyyy') As Datas
From CTEVenda C Left Join Vendas V
                              On C.Datas = V.Data
Order By V.Nome
Go

-- Utilizando uma CTE especificando a função Dense_Rank() --
;With CTERank 
As
(Select CodigoVenda, Nome, Tipo, Data,
            Dense_Rank() Over (Partition By Nome Order By NewId()) As NumeroVenda
  From Vendas
)
Select CodigoVenda, Nome, Tipo, Data, NumeroVenda From CTERank
Where NumeroVenda <= 3
Go