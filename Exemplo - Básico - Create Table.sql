 /* ********************************************************************* */
-- Minha Primeira Tabela

CREATE TABLE Pessoa
(
  Cod_Pes int,
  Nome_Pes char(30)
)
/********************************************************************** */
/* Inserindo dados na tabela criada anteriormente
   Apenas Cinco Linhas inseridas */
Insert Pessoa Values(1,'Ana')
Insert Pessoa Values(2,'Silvana')
Insert Pessoa Values(3,'Fabiana')
Insert Pessoa Values(4,'Mariana')
Insert Pessoa Values(5,'Adriana')
/* ********************************************************************* */
-- Lendo dados de uma tabela
Select * from Pessoa
/* ******************************************************************** */
Select * from Sysobjects
order by name
/* ******************************************************************** */
Exec SP_Help 'Pessoa'
