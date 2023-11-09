Use ProjetoDWQueimadas
Go

-- Concatenando os nomes de munic�pios por Estado --
Select EstadoMunicipio, 
          Ltrim(Stuff((Select ' | '+NomeMunicipio 
		           From MunicipiosQueimadas M1
				   Where M1.EstadoMunicipio = M2.EstadoMunicipio
				   Order By M1.EstadoMunicipio 
				   for xml path(''), TYPE).value('.', 'varchar(max)'),1,2,'')) As 'Rela��o de Munic�pios'
From MunicipiosQueimadas M2
Group By M2.EstadoMunicipio
Order By EstadoMunicipio Asc
Go

-- Apresentando a quantidade de munic�pios por Estado --
Select EstadoMunicipio, 
          Ltrim(Stuff((Select ' | '+NomeMunicipio 
		           From MunicipiosQueimadas M1
				   Where M1.EstadoMunicipio = M2.EstadoMunicipio
				   Order By M1.EstadoMunicipio 
				   for xml path(''), TYPE).value('.', 'varchar(max)'),1,2,'')) As 'Rela��o de Munic�pios',
		Count(M2.NomeMunicipio) As 'Total de Munic�pios Por Estado'
From MunicipiosQueimadas M2
Group By M2.EstadoMunicipio
Order By EstadoMunicipio Asc
Go
