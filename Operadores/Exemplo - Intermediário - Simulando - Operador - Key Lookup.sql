-- Criando o Banco de Dados DBMonitor --
Create Database DBMonitor
Go

-- Acessando o Banco de Dados DBMonitor --
Use DBMonitor
Go

-- Criando a Tabela Países --
Create Table Paises
(Id Int Identity(1,1) Primary Key,
 Nome Varchar(80))
Go

-- Criando a Tabela Impostos --
Create Table Impostos
(ID Int Identity(1,1) Primary Key,
 IdPais Int Not Null, 
 TaxaBase Float,
 TaxaEquilibrio As (TaxaBase)*10)
Go

-- Adicionando o relacionamento --
Alter Table Impostos
 Add Constraint [FK_ImpostosxPaises] Foreign Key (IdPais)
  References Paises(Id)
Go

-- Inserindo a massa de dados de Países --
SET NOCOUNT ON
Go

Insert Into Paises Values('Brasil'),
                                        ('Jamaica'),
										('Kiribati'),
										('Papau Nova Guiné'),
										('São Tomé e Príncipe'),
										('Estônia')
Go


-- Inserindo a massa de dados de Impostos --
SET NoCount On
Go

Declare @Contador TinyInt

Set @Contador = 0

While @Contador < 255
Begin

 Insert Into Impostos (IdPais, TaxaBase) 
 Values(IIF(@contador <=50, 1,
			IIF(@Contador >=51 And @Contador <=100, 2,
            IIF(@Contador >=101 And @Contador <=150, 3,
            IIF(@Contador >=151 And @Contador <=200, 4,
            IIF(@Contador >=201 And @Contador <=220, 5, 6	))))),
			RAND()*4)

 Set @Contador = @Contador + 1
End

-- Consultando os dados --
Select P.Nome, 
           Sum(I.TaxaBase) As SomaTaxaBase,
		   Sum(I.TaxaEquilibrio) As SomaTaxaEquilibrio
From Impostos I Inner Join Paises P
						 On I.IdPais = P.Id
Group By P.Nome
Order By SomaTaxaEquilibrio Desc
Go

-- Consultando os dados --
Select * from Paises
Go

Select * from Impostos
Go

-- Criando um novo índice NonClustered na Tabela Impostos --
Create NonClustered Index IND_Impostos_IDPais On Impostos(IdPais)
Go

-- Simulando Operador Key Lookup --

-- Exemplo 1 --
Select * from Impostos With (Index = IND_Impostos_IDPais)
Go

-- Exemplo 2 --
Select Top 1000 * From Impostos
Order By IdPais
Go