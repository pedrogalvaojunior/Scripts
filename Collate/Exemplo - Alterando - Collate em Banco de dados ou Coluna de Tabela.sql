-- Alterando Collate no Banco de Dados --
Alter Database MosaicoClient
Collate SQL_Latin1_General_CP1_CI_AI

-- Alterando o Collate na Tabela Users para a Coluna Password --
Alter Table Users
 Alter Column [Password] Varchar(12) Collate SQL_Latin1_General_CP1_CS_AS