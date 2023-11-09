-- Acessando --
Use Enderecamento
Go

-- Inserindo a relação de números entre 0 e 255 na Tabela Numeracao --
Insert Into Numeracao Default Values 
Go 256

-- Consultando --
Select * From Numeracao
Go

-- Passo 1 - Inserindo o Cruzando de Endereços de IPs entre 0 e 5 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 0 And 5
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

-- Passo 2 - Inserindo o Cruzando de Endereços de IPs entre 6 e 11 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 6 And 11
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

-- Passo 3 - Inserindo o Cruzando de Endereços de IPs entre 12 e 17 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 12 And 17
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

-- Passo 4 - Inserindo o Cruzando de Endereços de IPs entre 18 e 23 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 18 And 23
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

-- Passo 5 - Inserindo o Cruzando de Endereços de IPs entre 24 e 29 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 24 And 29
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

-- Passo 6 - Inserindo o Cruzando de Endereços de IPs entre 30 e 35 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 30 And 35
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

-- Passo 7 - Inserindo o Cruzando de Endereços de IPs entre 36 e 41 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 36 And 41
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

-- Passo 8 - Inserindo o Cruzando de Endereços de IPs entre 42 e 47 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 42 And 47
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

-- Passo 9 - Inserindo o Cruzando de Endereços de IPs entre 48 e 53 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 48 And 53
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

-- Passo 10 - Inserindo o Cruzando de Endereços de IPs entre 54 e 59 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 54 And 59
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

-- Passo 11 - Inserindo o Cruzando de Endereços de IPs entre 60 e 65 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 60 And 65
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (3,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go

-- Passo 12 - Inserindo o Cruzando de Endereços de IPs entre 66 e 72 combinando os quatro octetos --
Insert Into TabelaIPs (PrimeiroOcteto, SegundoOcteto, TerceiroOcteto, QuartoOcteto)
Select P.Codigo As PrimeiroOcteto, S.Codigo As SegundoOcteto, T.Codigo As TerceiroOcteto, Q.Codigo As QuartoOcteto
From Numeracao P With (Index=[IND_ColumnStoreIndex_Codigo])
         Cross Join Numeracao S With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao T With (Index=[IND_ColumnStoreIndex_Codigo]) 
         Cross Join Numeracao Q With (Index=[IND_ColumnStoreIndex_Codigo])
Where P.Codigo Between 66 And 72
Go

-- Encolhendo os Arquivo de Dados e Log desmarcando áreas não alocadas liberando espaço físico em disco --
Dbcc ShrinkFile (2,TruncateOnly)
Go

Dbcc ShrinkFile (4,TruncateOnly)
Go