Select Case SubString(Cast(codigo as varchar(10)),1,5) 
          When '10310' Then (Codigo+'40')
          When '10510' Then (Codigo+'50')
          When '10516' Then (Codigo+'60')
          When '10611' Then (Codigo+'70')
         End As 'Codigo Convertido',
         Descricao,
         Marca
From Produtos





