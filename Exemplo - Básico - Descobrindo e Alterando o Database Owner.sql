-- Obtendo a lista de Database Owners --
Select d.database_id,
           d.name,
		   suser_name(d.owner_sid) as 'Owner',
		   d.user_access_desc,
		   d.compatibility_level
from sys.databases as d
Go

-- Obtendo informações de um banco específico --
Exec sp_helpdb 'Master'
Go

-- Alterando o Database Owner --
Exec sp_changedbowner 'NomedoNovoOwner'
Go

-- Obtendo informações de um banco específico após alteração --
Exec sp_helpdb 'Master'
Go