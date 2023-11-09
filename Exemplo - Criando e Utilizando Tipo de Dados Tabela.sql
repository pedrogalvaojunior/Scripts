 -- Criando Tipo de Dados - Tabela --
 Create TYPE LocationTableType AS TABLE 
  ( LocationName VARCHAR(50)
  , CostRate INT );
  GO

-- Declarando um variável como Table Type --
Declare @LocationTVP As LocationTableType;

-- Inserindo dados no Table Type --
Insert Into @LocationTVP (LocationName, CostRate)
Values ('Teste',1)

-- Apresentando os Dados --
Select * from @LocationTVP