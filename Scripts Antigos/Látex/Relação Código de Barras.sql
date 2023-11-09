Select CodProduto As 'C�digo',
          Descricao As 'Descri��o do Produto',
          CODBarras As 'EAN13'
Into ProdutosNovos
from Produtos
Where CodProduto Like '10617%'
OR     CodProduto Like '10618%'
OR     CodProduto Like '10810%'
OR     CodProduto Like '105810%'
OR     CodProduto Like '11015%'
OR     CodProduto Like '16510%'
Order By CodProduto Asc, Descricao Asc


Drop Table ProdutosNovos
Where SubString([C�digo],9,1)='0'