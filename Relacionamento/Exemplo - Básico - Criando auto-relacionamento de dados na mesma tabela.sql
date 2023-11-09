-- Criando a Tabela TabelaMinhaFamilia --
Create Table TabelaMinhaFamilia
(CodigoDaMinhaFamilia Int,
 CodigoDoMembroDaMinhaFamilia TinyInt Not Null,
 NomeDoMembroDaMinhaFamilia Varchar(30) Not Null,
 DataNascimentoDoMembroDaMinhaFamilia Date Not Null,
 CodigoDoMembroSuperiorDaMinhaFamilia TinyInt Not Null
 Constraint [PK_TabelaMinhaFamilia] Primary Key (CodigoDaMinhaFamilia, CodigoDoMembroDaMinhaFamilia))
Go

-- Inserindo a massa de dados - Aten��o para coluna CodigoDoMembroSuperiorDaMinhaFamilia --
Insert Into TabelaMinhaFamilia (CodigoDaMinhaFamilia, CodigoDoMembroDaMinhaFamilia, NomeDoMembroDaMinhaFamilia, DataNascimentoDoMembroDaMinhaFamilia, CodigoDoMembroSuperiorDaMinhaFamilia)
Values (1, 1, 'Pedro Galv�o Junior','1980-04-28',1),
       (1, 2, 'Fernanda Galv�o','1981-01-28',1),
       (1, 3, 'Eduardo Galv�o','2001-09-06',2),
	   (1, 4, 'Jo�o Pedro Galv�o','2004-09-28',2),
	   (1, 5, 'Maria L�iza Galv�o','2012-02-27',1)
Go

-- Realizando o autorelacionamento - Aten��o no Inner Join - A refer�ncia da mesma tabela deve receber o valor da Tabela j� declarada --
Select T.CodigoDaMinhaFamilia, 
       T.CodigoDoMembroDaMinhaFamilia, 
	   T.NomeDoMembroDaMinhaFamilia,
	   T.DataNascimentoDoMembroDaMinhaFamilia,
	   Concat(T.CodigoDoMembroSuperiorDaMinhaFamilia,' - ', T2.NomeDoMembroDaMinhaFamilia) As 'Respons�vel'
From TabelaMinhaFamilia T Inner Join TabelaMinhaFamilia T2
                          On T2.CodigoDaMinhaFamilia = T.CodigoDaMinhaFamilia
						  And T2.CodigoDoMembroDaMinhaFamilia = T.CodigoDoMembroSuperiorDaMinhaFamilia
Go