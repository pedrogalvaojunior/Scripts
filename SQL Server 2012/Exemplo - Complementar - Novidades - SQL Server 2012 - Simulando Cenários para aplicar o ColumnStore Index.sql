-- Acessando o Banco de Dados Pit�goras --
Use Pitagoras
Go

-- Criando uma nova Sequ�ncia de Valores --
CREATE SEQUENCE Seq As INT -- Tipo
 START WITH 1 -- Valor Inicial (1)
 INCREMENT BY 1 -- Avan�a de um em um
 MINVALUE 1 -- Valor m�nimo 1
 MAXVALUE 100000 -- Valor m�ximo 100000
 CACHE 1000 -- Mant�m 10 posi��es em cache
 NO CYCLE -- N�o ir� reciclar
Go

-- Exclu�ndo a Tabela Dados --
If Object_Id('Dados') Is Not Null
 Drop Table Dados
Else
Begin
 -- Criando a Tabela Dados com Primary Key --
Create Table Dados
  (Descricao VarChar(60) Primary Key,
   Valor Float Null,
   Date Date Default GetDate(),
   Time Time Default GetDate())
End

-- Listando a Rela��o de �ndices da Tabela dbo.FactProductIventory --
Exec sp_helpindex 'Dados'
Go

-- Inserindo a Massa de Dados --
Insert Into Dados (Descricao, Valor)
Values ('Ola...'+Convert(Varchar(100),Rand()),Rand())
Go 10000

-- Limpando o Cache de Execu��o --
DBCC FREEPROCCACHE
Go
 
-- Ativando as Estat�sticas de Time e IO --
SET STATISTICS TIME ON
SET STATISTICS IO ON
Go

-- Cen�rio 1 --
-- Executando o novamente o Select com ColumnStore Index e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
Go

-- Executando o novamente o Select ignorando o ColumnStore Index e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date from Dados 
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Cen�rio 2 --
-- Executando o novamente o Select + Sequence + Group By com ColumnStore Index e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
Go

-- Executando o novamente o Select + Sequence + Group By ignorando o ColumnStore Index e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Cen�rio 3 --
-- Executando o novamente o Select + Sem Sequence + Group By com ColumnStore Index e Verificar o Plano de Execu��o --
Select Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
Go

-- Executando o novamente o Select + Sem Sequence + Group By ignorando o ColumnStore Index e Verificar o Plano de Execu��o --
Select Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Cen�rio 4 --
-- Executando o novamente o Select + Sem Sequence + Sem Group By com ColumnStore Index e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
Go

-- Executando o novamente o Select + Sem Sequence + Sem Group By ignorando o ColumnStore Index e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Desativando as Estat�sticas de Time e IO --
SET STATISTICS TIME OFF
SET STATISTICS IO OFF
Go
