Select CodProduto As "Produto",
          Convert(Char(10), DataProducao,103) As "Data de Produção",
          Maquina,
          LoteProducao As "Lote de Produção",
          LoteInterno As "Lote Interno",
          Round(Peso,3) "Peso"
From Ctluvas
Where Maquina Between 6 and 7 And LoteInterno >=200
Or       Maquina Between 4 and 5 And LoteInterno >=40 
Or       Maquina Between 8 and 9 And LoteInterno >=120
Or       Maquina =1  And LoteInterno >=150
Order by CodProduto, Maquina, LoteInterno