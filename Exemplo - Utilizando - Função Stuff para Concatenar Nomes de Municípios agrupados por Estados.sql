Use ProjetoDWQueimadas
Go

-- Concatenando os nomes de municípios por Estado --
Select EstadoMunicipio, 
          Ltrim(Stuff((Select ' | '+NomeMunicipio 
		           From MunicipiosQueimadas M1
				   Where M1.EstadoMunicipio = M2.EstadoMunicipio
				   Order By M1.EstadoMunicipio 
				   for xml path(''), TYPE).value('.', 'varchar(max)'),1,2,'')) As 'Relação de Municípios'
From MunicipiosQueimadas M2
Group By M2.EstadoMunicipio
Order By EstadoMunicipio Asc
Go

-- Apresentando a quantidade de municípios por Estado --
Select EstadoMunicipio, 
          Ltrim(Stuff((Select ' | '+NomeMunicipio 
		           From MunicipiosQueimadas M1
				   Where M1.EstadoMunicipio = M2.EstadoMunicipio
				   Order By M1.EstadoMunicipio 
				   for xml path(''), TYPE).value('.', 'varchar(max)'),1,2,'')) As 'Relação de Municípios',
		Count(M2.NomeMunicipio) As 'Total de Municípios Por Estado'
From MunicipiosQueimadas M2
Group By M2.EstadoMunicipio
Order By EstadoMunicipio Asc
Go
