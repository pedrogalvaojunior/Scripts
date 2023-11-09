--Liberando 10% do espaço final do arquivo de dados --
DBCC ShrinkDatabase('Cipa',10)

--Diminuindo o Tamanho do Banco e liberando espaços existentes --
DBCC ShrinkDatabase('Cipa',TruncateOnly)

--Diminuindo o Tamanho do Arquivo de Banco para 1 MB --
DBCC ShrinkFile('Cipa_Data',1)

--Diminuindo o Tamanho do Arquivo de Banco e liberando espaços existentes --
DBCC ShrinkFile('Cipa_Data',TruncateOnly)

--Diminuindo o Tamanho do Arquivo de Log para 1 MB --
DBCC ShrinkFile('Cipa_LOG',1)

--Diminuindo o Tamanho do Arquivo de Log e liberando espaços existentes --
DBCC ShrinkFile('Cipa_LOG',TruncateOnly)

--Fazendo o Backup do Log e liberando espaços --
BACKUP LOG CIPA WITH TRUNCATE_ONLY

