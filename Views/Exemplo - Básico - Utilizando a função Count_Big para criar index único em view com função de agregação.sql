Create Table MySampleTable
(Id1 Int,
 Id2 Int,
 SomeData Varchar(100))

 Create View SampleView
 With SchemaBinding
 As
	Select COUNT(*) TableCount,
	           Id2
	From dbo.MySampleTable
	Group By Id2

-- Erro ao criar --
Create Unique Clustered Index [IX_ViewSample]
On [dbo].[SampleView]
(Id2 Asc)
Go

-- Alterando o tipo de contagem de dados --
 Create View SampleView
 With SchemaBinding
 As
	Select COUNT_BIG(*) TableCount,
	           Id2
	From dbo.MySampleTable
	Group By Id2

-- Criando o Índice --
Create Unique Clustered Index [IX_ViewSample]
On [dbo].[SampleView]
(Id2 Asc)
Go