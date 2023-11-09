Create table #Exemplo (codigo int, nome varchar(10))

insert into #Exemplo (codigo, nome) Values (1,'jose')

insert into #Exemplo (codigo, nome) Values (2,'mario')

insert into #Exemplo (codigo, nome) Values (1,'jose')

insert into #Exemplo (codigo, nome) Values (2,'mario')

insert into #Exemplo (codigo, nome) Values (3,'celso')

insert into #Exemplo (codigo, nome) Values (4,'andre')

Select [jose],[mario],[celso],[andre] from #exemplo 
Pivot (count(codigo) for nome in ([jose],[mario],[celso],[andre])) p
