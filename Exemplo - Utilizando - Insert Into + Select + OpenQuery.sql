Declare @LoteProducao Char(6),
           @CodProduto Char(3)

Set @LoteProducao='245061'
Set @CodProduto='441'

Delete from Ctluvas2006
Where LoteProducao=@LoteProducao 
AND    SUBSTRING(CONVERT(CHAR(7),CODPRODUTO),1,3)=@CodProduto
Go

Insert Into CtLuvas2006
Select * from openquery([131.107.3.2], 'Select * from Ctluvas Where LoteProducao= ''245061'' AND SUBSTRING(CONVERT(CHAR(7),CODPRODUTO),1,3)=''441''')

