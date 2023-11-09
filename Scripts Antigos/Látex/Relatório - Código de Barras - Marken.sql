USE BARRAS

Select CodProduto As C�digo, 
          Descricao As 'Descri��o do Produto', 
          CodBarras As 'C�digo de Barras'
From Produtos
Where Convert(Char(10), CodProduto) >= '108704830' And Convert(Char(10), CodProduto) <= '108709830'
And    SubString(CodProduto,1,3)='108' 
And    SubString(CodProduto,8,2)='30'
Or   CodProduto = '108702530'
Union All
Select CodProduto As C�digo, 
          Descricao As 'Descri��o do Produto', 
          CodBarras As 'C�digo de Barras'
From Produtos
Where Convert(Char(10), CodProduto) >= '108724830' And Convert(Char(10), CodProduto) <= '108729830'
And    SubString(CodProduto,1,3)='108' 
And    SubString(CodProduto,8,2)='30'
Or   CodProduto = '108722530'
Order By CodProduto