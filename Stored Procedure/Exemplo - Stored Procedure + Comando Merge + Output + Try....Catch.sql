-- Criando a Tabela ProdutosProduzidos --
Create Table ProdutosProduzidos
 (OrdemProducao Varchar(20) Not Null Primary Key Clustered,
 DataProducao DateTime Not Null,
 Quantidade Int Not Null)
On [Primary]
Go

-- Criando a Stored Procedure P_FindProduction --
Create Procedure P_FindProduction @OrdemProducao VarChar(20), @DataProducao DateTime
As
Begin
Set NoCount On;

Begin Try

 Merge ProdutosProduzidos As Target
  Using (Select @OrdemProducao, @DataProducao) As Source (OrdemProducao, DataProducao)
   On (Target.OrdemProducao = Source.OrdemProducao 
       And Target.DataProducao = Source.DataProducao)
  When Matched Then
   Update Set Quantidade = Quantidade + 1, DataProducao = GetDate()
  When Not Matched Then
   Insert (OrdemProducao, DataProducao, Quantidade)
   Values(Source.OrdemProducao, Source.DataProducao, 1);

End Try

Begin Catch
  
   SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine;
         
End Catch
End
Go

Select * from ProdutosProduzidos

Insert Into ProdutosProduzidos (OrdemProducao, DataProducao, Quantidade)
Values (1,GetDate(),1), 
       (2,GetDate(),1),
	   (3,GetDate(),1)


Exec P_FindProduction 3, '2014-07-08 10:26:25.250'


Select ERROR_PROCEDURE()