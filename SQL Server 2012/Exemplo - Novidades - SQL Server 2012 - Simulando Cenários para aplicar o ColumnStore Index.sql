CREATE DATABASE TESTE

-- Criando uma nova Sequência de Valores --
CREATE SEQUENCE Seq As INT -- Tipo
 START WITH 1 -- Valor Inicial (1)
 INCREMENT BY 1 -- Avança de um em um
 MINVALUE 1 -- Valor mínimo 1
 MAXVALUE 10000 -- Valor máximo 10000
 CACHE 100 -- Mantém 10 posições em cache
 NO CYCLE -- Não irá reciclar

-- Excluíndo a Tabela Dados --
Drop Table Dados

 -- Criando a Tabela Dados com Primary Key --
Create Table Dados
  (Descricao VarChar(60) Primary Key,
   Valor Float Null,
   Date Date Default GetDate(),
   Time Time Default GetDate())

-- Inserindo a Massa de Dados --
Insert Into Dados (Descricao, Valor)
Values ('Ola...'+Convert(Varchar(100),Rand()),Rand())
Go 1000

-- Executando o Select em conjunto com Sequence e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados

-- Limpando o Cache de Execução --
DBCC FREEPROCCACHE

-- Executando o novamente o Select com ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
Go

-- Executando o novamente o Select ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date from Dados 
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Executando o novamente o Select + Sequence + Group By com ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
Go

-- Executando o novamente o Select + Sequence + Group By ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Executando o novamente o Select + Sem Sequence + Group By com ColumnStore Index e Verificar o Plano de Execução --
Select Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
Go

-- Executando o novamente o Select + Sem Sequence + Group By ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Executando o novamente o Select + Sem Sequence + Sem Group By com ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
Go

-- Executando o novamente o Select + Sem Sequence + Sem Group By ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go
