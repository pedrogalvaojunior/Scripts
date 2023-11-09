-- Criando a Tabela ProdutosProduzidos --
Create Table ProdutosProduzidos
(ControleProducao Int Identity(1,1) Primary Key,
 OrdemProducao Varchar(20) Not Null,
 DataProducao DateTime Not Null,
 Quantidade Int Not Null)
On [Primary]
Go

-- Criando a Stored Procedure P_FindProduction --
Create Procedure P_FindProduction @OrdemProducao VarChar(20), @DataProducao DateTime
As
Begin
Set NoCount On;

Merge ProdutosProduzidos As Target
 Using (Select @OrdemProducao, @DataProducao) As Source (OrdemProducao, DataProducao)
  On (Target.OrdemProducao = Source.OrdemProducao 
      And Target.DataProducao = Source.DataProducao)
 When Matched Then
  Update Set Quantidade = Quantidade + 1, DataProducao = GetDate()
 When Not Matched Then
  Insert (OrdemProducao, DataProducao, Quantidade)
  Values(Source.OrdemProducao, Source.DataProducao, 1)
  OUTPUT deleted.*, $action, inserted.*;

End
Go

Select * from ProdutosProduzidos

Insert Into ProdutosProduzidos (OrdemProducao, DataProducao, Quantidade)
Values (1,GetDate(),1), 
       (2,GetDate(),1),
	   (3,GetDate(),1)


Exec P_FindProduction 1, '2014-07-08 10:06:50.297'