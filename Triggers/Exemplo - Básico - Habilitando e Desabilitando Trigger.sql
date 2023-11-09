-- Habilitando --
Alter Table Estoque 
Enable Trigger t_atualizarsaldos
Go

-- Desabilitando --
Alter table Estoque 
Disable Trigger t_atualizarsaldos
Go