-- Acessando o Banco de Dados Pitágoras --
Use ETEC
Go

-- Criando uma nova Sequência de Valores --
CREATE SEQUENCE Seq As INT -- Tipo
 START WITH 1 -- Valor Inicial (1)
 INCREMENT BY 1 -- Avança de um em um
 MINVALUE 1 -- Valor mínimo 1
 MAXVALUE 100000 -- Valor máximo 100000
 CACHE 1000 -- Mantém 10 posições em cache
 NO CYCLE -- Não irá reciclar
Go

-- Excluíndo a Tabela Dados --
If Object_Id('Dados') Is Not Null
 Drop Table Dados
Else
Begin
 -- Criando a Tabela Dados com Primary Key --
Create Table Dados
  (Descricao VarChar(60) Not Null,
   Valor Float Null,
   Date Date Default GetDate(),
   Time Time Default GetDate())

Alter Table Dados
 Add Constraint [PK_Dados] Primary Key Clustered (Descricao) On [Primary]
End

-- Listando a Relação de Índices da Tabela dbo.FactProductIventory --
Exec sp_helpindex 'Dados'
Go

-- Inserindo a Massa de Dados --
Insert Into Dados (Descricao, Valor)
Values ('Ola...'+Convert(Varchar(100),Rand()),Rand())
Go 10000

-- Limpando o Cache de Execução --
DBCC FREEPROCCACHE
Go
 
-- Ativando as Estatísticas de Time e IO --
SET STATISTICS TIME ON
SET STATISTICS IO ON
Go

-- Cenário 1 --
-- Executando o novamente o Select com ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
Go

-- Executando o novamente o Select ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date from Dados 
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Cenário 2 --
-- Executando o novamente o Select + Sequence + Group By com ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
Go

-- Executando o novamente o Select + Sequence + Group By ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Cenário 3 --
-- Executando o novamente o Select + Sem Sequence + Group By com ColumnStore Index e Verificar o Plano de Execução --
Select Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
Go

-- Executando o novamente o Select + Sem Sequence + Group By ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Cenário 4 --
-- Executando o novamente o Select + Sem Sequence + Sem Group By com ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
Go

-- Executando o novamente o Select + Sem Sequence + Sem Group By ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Desativando as Estatísticas de Time e IO --
SET STATISTICS TIME OFF
SET STATISTICS IO OFF
Go
