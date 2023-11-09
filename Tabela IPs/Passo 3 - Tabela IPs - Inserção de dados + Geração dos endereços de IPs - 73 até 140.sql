-- Acessando --
Use Enderecamento
Go

-- Passo 13 - Inserindo o Cruzando de Endereços de IPs entre 73 e 78 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 73 And 78
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 14 - Inserindo o Cruzando de Endereços de IPs entre 79 e 84 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 79 And 84
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 15 - Inserindo o Cruzando de Endereços de IPs entre 85 e 90 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 85 And 90
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 16 - Inserindo o Cruzando de Endereços de IPs entre 91 e 96 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 91 And 96
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 17 - Inserindo o Cruzando de Endereços de IPs entre 97 e 103 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 97 And 103
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 18 - Inserindo o Cruzando de Endereços de IPs entre 104 e 109 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 104 And 109
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 19 - Inserindo o Cruzando de Endereços de IPs entre 110 e 115 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 110 And 115
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 20 - Inserindo o Cruzando de Endereços de IPs entre 116 e 121 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 116 And 121
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 21 - Inserindo o Cruzando de Endereços de IPs entre 122 e 127 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 122 And 127
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

Dbcc ShrinkFile (5,TruncateOnly)
Go

-- Passo 22 - Inserindo o Cruzando de Endereços de IPs entre 128 e 133 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 128 And 133
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (5,TruncateOnly)
Go

-- Passo 23 - Inserindo o Cruzando de Endereços de IPs entre 134 e 140 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 134 And 140
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (5,TruncateOnly)
Go