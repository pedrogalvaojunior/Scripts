USE [AULA6]
GO

ALTER View [dbo].[V_VisualizadorDeVendas]
With Schemabinding
As
Select V.CODIGO As Codigo, 
       E.RazaoSocial,
       P.Descricao,
	   C.Nome,
	   V.DataVenda,
	   V.ValorVenda,
	   V.QTDEParcelas
From dbo.VENDAS V Inner Join dbo.EMPRESAS E
                 On V.CODEMPRESA = E.CODIGO
				Inner Join dbo.PRODUTOS P
				 On P.CODIGO = V.CODPRODUTO
				Inner Join dbo.CLIENTES C
				 On C.CODIGO = V.CODCLIENTE

GO


Create Unique Clustered Index Ind_V_VisualizadorDeVendas On V_VisualizadorDeVendas 
(Codigo Asc)
ON [Primary]
Go

Set Statistics Time On

Select * from V_VisualizadorDeVendas
Go

-- Utilizando Query Hint (Expand Views) --
Select * from V_VisualizadorDeVendas Option (Expand Views)
Go

-- Utilizando Table Hint (NoExpand) --
Select * from V_VisualizadorDeVendas With (NoExpand)
Go