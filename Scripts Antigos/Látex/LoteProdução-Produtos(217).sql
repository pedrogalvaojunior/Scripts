SELECT CODPRODUTO, LOTEPRODUCAO, Convert(Char(10),DataProducao,103) "Data de Produ��o", COUNT(CODPRODUTO) "Lan�amentos" FROM CTLuvas
Where CodProduto Like '217%'
Group By CodProduto, LoteProducao, DataProducao
Order By LoteProducao


select * from Produtos