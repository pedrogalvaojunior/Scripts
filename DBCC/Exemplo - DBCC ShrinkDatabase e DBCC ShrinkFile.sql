--Liberando 10% do espa�o final do arquivo de dados --
DBCC ShrinkDatabase('Cipa',10)

--Diminuindo o Tamanho do Banco e liberando espa�os existentes --
DBCC ShrinkDatabase('Cipa',TruncateOnly)

--Diminuindo o Tamanho do Arquivo de Banco para 1 MB --
DBCC ShrinkFile('Cipa_Data',1)

--Diminuindo o Tamanho do Arquivo de Banco e liberando espa�os existentes --
DBCC ShrinkFile('Cipa_Data',TruncateOnly)

--Diminuindo o Tamanho do Arquivo de Log para 1 MB --
DBCC ShrinkFile('Cipa_LOG',1)

--Diminuindo o Tamanho do Arquivo de Log e liberando espa�os existentes --
DBCC ShrinkFile('Cipa_LOG',TruncateOnly)

--Fazendo o Backup do Log e liberando espa�os --
BACKUP LOG CIPA WITH TRUNCATE_ONLY

