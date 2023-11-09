-- Limpar as entradas de Cache n�o utilizadas
DBCC FREESYSTEMCACHE ( 'ALL' )

-- Limpar os Caches de Sess�es --
DBCC FREESESSIONCACHE

-- Eliminar todas as entradas do CACHE de "Procedures"
DBCC FREEPROCCACHE

-- Eliminar e liberar o Fluxo de processamento de procedure para o banco de dados espec�fico --
DBCC FLUSHPROCINDB( 5 )

-- For�ar a escrita das p�ginas em disco "limpando-as"
CHECKPOINT

-- Eliminar as p�ginas de buffer limpas
DBCC DROPCLEANBUFFERS
Go
