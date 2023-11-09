Select CodProduto As 'Código',
          Descricao As 'Descrição do Produto',
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
Where SubString([Código],9,1)='0'