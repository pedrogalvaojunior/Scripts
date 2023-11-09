--Criando a Table de Novos Produtos--
Create Table NovosProdutos
 (Codigo Int Identity(1,1),
   Descricao VarChar(10))

--Criando a Table de Histórico Novos Produtos--
Create Table HistoricoNovosProdutos
 (Codigo Int,
   Descricao VarChar(10))
Go

--Inserindo valores --
Insert Into Novosprodutos Values('Arroz')
Insert Into Novosprodutos Values('Arroz1')
Insert Into Novosprodutos Values('Arroz2')
Insert Into Novosprodutos Values('Arroz3')
Go

--Criando a Trigger para controle de histórico--
Create TRIGGER T_Historico
ON NovosProdutos
for update
AS 
 IF (Select Descricao from Inserted) <> (Select Descricao from Deleted)
  BEGIN
   INSERT Into HistoricoNovosProdutos (Codigo, Descricao)
        SELECT Codigo, Descricao FROM INSERTED
  END
Go

--Fazendo os teste --


Update NovosProdutos
Set Descricao='Arroz 4'
Where Codigo = 1
Go

Update NovosProdutos
Set Descricao='Arroz1'
Where Codigo = 2
Go