-- Criando a Tabela -- 
Create Table TesteIdentity
(Codigo Int Identity(1,1),
  Descricao Varchar(30) Not Null)
Go

-- Criando a Trigger do tipo Instead Of Insert --
Create Trigger T_ObterValorIdentity
On TesteIdentity
Instead Of Insert
AS
BEGIN
Set NoCount On

DECLARE @Relacao TABLE
 (Codigo INT);

INSERT TesteIdentity (Descricao)
 Output inserted.Codigo Into @Relacao
 SELECT Descricao  FROM inserted

 Select * From @Relacao
End
Go

-- Inserindo --
Insert Into TesteIdentity Values ('Pedro'), ('Antonio'),('Galvão'),('Junior')
Go

-- Validando --
Select * From TesteIdentity
Go