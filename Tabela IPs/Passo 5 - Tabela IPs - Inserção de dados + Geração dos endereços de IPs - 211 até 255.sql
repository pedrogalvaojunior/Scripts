-- Acessando --
Use Enderecamento
Go

-- Desativando a contagem de linhas --
Set NoCount On
Go

-- Passo 35 - Inserindo o Cruzando de Endereços de IPs entre 211 e 216 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 211 And 216
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (6,TruncateOnly)
Go

-- Passo 36 - Inserindo o Cruzando de Endereços de IPs entre 217 e 222 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 217 And 222
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (6,TruncateOnly)
Go

-- Passo 37 - Inserindo o Cruzando de Endereços de IPs entre 223 e 228 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 223 And 228
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (6,TruncateOnly)
Go

-- Passo 38 - Inserindo o Cruzando de Endereços de IPs entre 229 e 235 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 229 And 235
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (6,TruncateOnly)
Go

-- Passo 39 - Inserindo o Cruzando de Endereços de IPs entre 236 e 241 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 236 And 241
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (6,TruncateOnly)
Go

-- Passo 40 - Inserindo o Cruzando de Endereços de IPs entre 242 e 247 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 242 And 247
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (6,TruncateOnly)
Go

-- Passo 41 - Inserindo o Cruzando de Endereços de IPs entre 248 e 253 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 248 And 253
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (6,TruncateOnly)
Go

Dbcc ShrinkFile (7,TruncateOnly)
Go

-- Passo 42 - Inserindo o Cruzando de Endereços de IPs entre 254 e 255 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 254 And 255
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (7,TruncateOnly)
Go