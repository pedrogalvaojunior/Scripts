-- Criando a Tabela --
Create Table Produtos 
(Codigo Int, 
 Descricao char (20))
Go

-- Adicionando as Descrições --
EXEC   sp_addextendedproperty 'Descricao da Coluna', 'Codigo do Produto', 'user', dbo, 'table', 'Produtos', 'column', Codigo 
EXEC   sp_addextendedproperty 'Descricao da Coluna', 'Descricao do Produto', 'user', dbo, 'table', 'Produtos', 'column', Descricao
Go

--  Consultando -- 
Select * FROM  ::fn_listextendedproperty (NULL, 'user', 'dbo', 'table', 'Produtos', 'column', default)
Go