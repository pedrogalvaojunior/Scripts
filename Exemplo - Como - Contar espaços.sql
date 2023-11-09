Select Descricao,
         Case When CharIndex(' ',Descricao,1)=0 Then 'Não Tem' Else 'Tem'
         End
From Produtos