-- Acessando --
Use Enderecamento
Go

-- Desativando a contagem de linhas --
Set NoCount On
Go

-- Passo 24 - Inserindo o Cruzando de Endereços de IPs entre 141 e 145 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 141 And 145
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 25 - Inserindo o Cruzando de Endereços de IPs entre 146 e 151 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 146 And 151
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 26 - Inserindo o Cruzando de Endereços de IPs entre 152 e 158 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 152 And 158
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 27 - Inserindo o Cruzando de Endereços de IPs entre 159 e 164 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 159 And 164
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 28 - Inserindo o Cruzando de Endereços de IPs entre 165 e 170 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 165 And 170
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 29 - Inserindo o Cruzando de Endereços de IPs entre 171 e 176 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 171 And 176
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go


-- Passo 30 - Inserindo o Cruzando de Endereços de IPs entre 177 e 182 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 177 And 182
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 31 - Inserindo o Cruzando de Endereços de IPs entre 183 e 188 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 183 And 188
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

Dbcc ShrinkFile (5,TruncateOnly)
Go

-- Passo 32 - Inserindo o Cruzando de Endereços de IPs entre 189 e 194 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 189 And 194
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (6,TruncateOnly)
Go

-- Passo 33 - Inserindo o Cruzando de Endereços de IPs entre 195 e 200 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 195 And 200
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (6,TruncateOnly)
Go

-- Passo 34 - Inserindo o Cruzando de Endereços de IPs entre 205 e 210 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 205 And 210
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (6,TruncateOnly)
Go