Create Table Flores
(ClasseFlor Char(1), 
 NomeFlor varchar(30))
Go

Insert Into Flores (ClasseFlor, NomeFlor)
Values ('A', 'Hort�ncia'), ('A', 'Violeta'), ('A', 'Rosa-Branca'), ('A', 'Cravo'),
            ('B', 'Orqu�dea'), ('B', 'Girassol')
Go

-- Apresentando o retorno com r�tulo XML --
Select  NomeFlor+ ' - ' From Flores
Where ClasseFlor = 'A'
For XML Path('')
Go

-- Apresentando o retorno sem r�tulo XML --
Select  NomeFlor+ ' - ' From Flores
Where ClasseFlor = 'A'
For XML Path(''), Type
Go

-- Atribuindo r�tulo no retorno XML utilizando a diretiva TYPE --
Select (Select  NomeFlor+ ' - ' From Flores
Where ClasseFlor = 'A'
For XML Path(''), Type).value('.','varchar(max)') As Lista
Go

-- Utilizando uma vari�vel para realizar o retorno do XML --
Declare @ListaFlores Varchar(100)

Set @ListaFlores=(Select  NomeFlor+ ' - ' From Flores Where ClasseFlor = 'A' For XML Path(''))

Select @ListaFlores as MinhaLista
Go

-- Aplicando a fun��o Stuff para envolver a Subquery e apresentar novo resultado --
-- Exemplo 1 --
Select ClasseFlor,
           Stuff ((Select  ' - '+NomeFlor
		             From Flores 
					 Where ClasseFlor = 'A' For XML Path('')), 1, 2, '') as MinhaLista
From Flores as F
Group by ClasseFlor
Go

-- Exemplo 2 --
Select F1.ClasseFlor,
           Stuff ((Select ' - ' + F.NomeFlor From Flores as F
                      Where F.ClasseFlor = F1.ClasseFlor
				      Order By F.NomeFlor
                      For XML Path(''), TYPE).value('.', 'varchar(max)'), 1, 2, '') As Lista
From Flores as F1
Group By F1.ClasseFlor
Go