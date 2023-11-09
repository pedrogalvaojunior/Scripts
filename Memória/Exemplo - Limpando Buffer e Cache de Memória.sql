-- Limpar as entradas de Cache não utilizadas
DBCC FREESYSTEMCACHE ( 'ALL' )

-- Limpar os Caches de Sessões --
DBCC FREESESSIONCACHE

-- Eliminar todas as entradas do CACHE de "Procedures"
DBCC FREEPROCCACHE

-- Eliminar e liberar o Fluxo de processamento de procedure para o banco de dados específico --
DBCC FLUSHPROCINDB( 5 )

-- Forçar a escrita das páginas em disco "limpando-as"
CHECKPOINT

-- Eliminar as páginas de buffer limpas
DBCC DROPCLEANBUFFERS
Go
