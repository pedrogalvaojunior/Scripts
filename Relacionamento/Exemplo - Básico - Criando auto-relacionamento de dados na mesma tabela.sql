-- Criando a Tabela TabelaMinhaFamilia --
Create Table TabelaMinhaFamilia
(CodigoDaMinhaFamilia Int,
 CodigoDoMembroDaMinhaFamilia TinyInt Not Null,
 NomeDoMembroDaMinhaFamilia Varchar(30) Not Null,
 DataNascimentoDoMembroDaMinhaFamilia Date Not Null,
 CodigoDoMembroSuperiorDaMinhaFamilia TinyInt Not Null
 Constraint [PK_TabelaMinhaFamilia] Primary Key (CodigoDaMinhaFamilia, CodigoDoMembroDaMinhaFamilia))
Go

-- Inserindo a massa de dados - Atenção para coluna CodigoDoMembroSuperiorDaMinhaFamilia --
Insert Into TabelaMinhaFamilia (CodigoDaMinhaFamilia, CodigoDoMembroDaMinhaFamilia, NomeDoMembroDaMinhaFamilia, DataNascimentoDoMembroDaMinhaFamilia, CodigoDoMembroSuperiorDaMinhaFamilia)
Values (1, 1, 'Pedro Galvão Junior','1980-04-28',1),
       (1, 2, 'Fernanda Galvão','1981-01-28',1),
       (1, 3, 'Eduardo Galvão','2001-09-06',2),
	   (1, 4, 'João Pedro Galvão','2004-09-28',2),
	   (1, 5, 'Maria Lúiza Galvão','2012-02-27',1)
Go

-- Realizando o autorelacionamento - Atenção no Inner Join - A referência da mesma tabela deve receber o valor da Tabela já declarada --
Select T.CodigoDaMinhaFamilia, 
       T.CodigoDoMembroDaMinhaFamilia, 
	   T.NomeDoMembroDaMinhaFamilia,
	   T.DataNascimentoDoMembroDaMinhaFamilia,
	   Concat(T.CodigoDoMembroSuperiorDaMinhaFamilia,' - ', T2.NomeDoMembroDaMinhaFamilia) As 'Responsável'
From TabelaMinhaFamilia T Inner Join TabelaMinhaFamilia T2
                          On T2.CodigoDaMinhaFamilia = T.CodigoDaMinhaFamilia
						  And T2.CodigoDoMembroDaMinhaFamilia = T.CodigoDoMembroSuperiorDaMinhaFamilia
Go