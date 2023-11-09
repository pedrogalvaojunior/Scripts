Select Distinct SubString(Convert(VarChar(7),Ct.CodProduto),1,3) "C�digo", 
         Descricao=(Select Descricao From Produtos Where Codigo = SubString(Convert(VarChar(7),Ct.CodProduto),1,3)),
         Ct.LoteProducao, Ct.DataProducao
From Ctluvas Ct 
Where Month(Ct.DataProducao)=03
And    Year(Ct.DataProducao)=2005
Group By Ct.LoteProducao, Ct.CodProduto, Ct.DataProducao



