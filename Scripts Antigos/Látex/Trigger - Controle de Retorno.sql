Alter TRIGGER T_IncluirRetornoMarmeleiro
  ON TRANSFERENCIAS
  FOR INSERT
AS

Set NoCount On

Declare @CodRetorno Int
Set @CodRetorno=(Select Max(Codigo) from Transferencias Where CodDestino='M')

 Insert ControleRetorno
 Select Codigo, CodProduto, QuantCaixas, Quantidade, Data,'','','','','','' From Inserted
 Where Codigo = @CodRetorno


/*******/

Insert Into Transferencias Values(5002,1,'M',1,0,0,0,'2006-03-20',0)


Delete Transferencias
Where Codigo >=5000

truncate table controleretorno

select * from transferencias
select * from controleretorno

select * from produtos_nf

alter table controleretorno
 Add Observacoes Varchar(255) Null