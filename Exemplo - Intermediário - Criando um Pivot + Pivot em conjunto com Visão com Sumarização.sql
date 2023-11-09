Create Table Fornos
(Id Int Primary Key,
 Defeito Varchar(20) Not Null,
 Forno Varchar(20) Not Null,
 Equipe Varchar(20) Not Null)
Go

Insert Into Fornos
Values (1,'DEFEITO A','FORNO 3','AZUL'),
(2,'DEFEITO A','FORNO 2','VERDE'),
(3,'DEFEITO B','FORNO 1','AZUL'),
(4,'DEFEITO A','FORNO 1','PRETO'),
(5,'DEFEITO B','FORNO 2','VERDE'),
(6,'DEFEITO B','FORNO 2','AZUL'),
(7,'DEFEITO A','FORNO 1','PRETO'),
(8,'DEFEITO A','FORNO 2','AZUL')
Go


Select * From Fornos
Go

-- Gerando o Pivot --
Select * from 
(Select CONCAT(Defeito,' - ', Equipe) As DefeitosPorEquipe,
            CONCAT(Defeito,' - ', Equipe) As 'Defeitos Agrupados Por Equipes',
			Equipe,
			Forno As 'Fornos'
 From Fornos) As F
Pivot (Count(DefeitosPorEquipe) For Equipe In ([Azul],[Preto],[Verde])) as Pvt
Go

-- Adicionando os Totais --
Select * from 
(
 Select CONCAT(Defeito,' - ', Equipe) As DefeitosPorEquipe,
            CONCAT(Defeito,' - ', Equipe) As 'Defeitos Agrupados Por Equipes',
			Equipe,
			Forno As 'Fornos'
 From Fornos
) As F
Pivot (Count(DefeitosPorEquipe) For Equipe In ([Azul],[Preto],[Verde])) as Pvt

Union All

Select 'Totais....', '---->', 
           Sum(Azul) As SomaAzul, 
           Sum(Preto) As SomaPreto, 
		   Sum(Verde) As SomaVerde 
From 
(
 Select CONCAT(Defeito,' - ', Equipe) As DefeitosPorEquipe,
			Equipe
 From Fornos
) As F
Pivot (Count(DefeitosPorEquipe) For Equipe In ([Azul],[Preto],[Verde])) as Pvt
Go