Select CodProduto,
           Case
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),4,1)=1 Then 'Pequeno'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),4,1)=2 Then 'Médio'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),4,1)=3 Then 'Grande'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=2 And SubString(Convert(VarChar(7), CodProduto),4,1)=4 Then 'Ex. Grande'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=3 And SubString(Convert(VarChar(7), CodProduto),4,1)=1 Then 'Ex. Pequeno'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=3 And SubString(Convert(VarChar(7), CodProduto),4,1)=2 Then 'Pequeno'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=3 And SubString(Convert(VarChar(7), CodProduto),4,1)=3 Then 'Médio'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=3 And SubString(Convert(VarChar(7), CodProduto),4,1)=4 Then 'Grande'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=1 Then '6.0'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=2 Then '6.5'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=3 Then '7.0'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=4 Then '7.5'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=5 Then '8.0'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=6 Then '8.5'
            When SubString(Convert(VarChar(7), CodProduto),1,1)=4 And SubString(Convert(VarChar(7), CodProduto),4,1)=7 Then '9.0'
          End As Cor
From CtLuvas
--Where LoteProducao='183055'


