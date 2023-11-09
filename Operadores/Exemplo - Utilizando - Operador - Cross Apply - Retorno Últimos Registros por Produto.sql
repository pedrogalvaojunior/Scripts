declare @table1 as table(
	id int identity,
	descricao char(100)
)

declare @table2 as table(
	id int identity,
	idTable1 int,
	descricao char(100),
	data datetime default getdate() not null
)


insert into 
	@table1 (descricao)
values
	('Produto A'), ('Produto B'), ('Produto C')

insert into 
	@table2 (idTable1, descricao)
values
	(1, 'Log 1 do Produto A'),
	(1, 'Log 2 do Produto A'),
	(1, 'Log 3 do Produto A'),
	(2, 'Log 1 do Produto B'),
	(2, 'Log 2 do Produto B'),
	(3, 'Log 1 do Produto C'),
	(3, 'Log 2 do Produto C'),
	(3, 'Log 3 do Produto C')

--Causando o seu problema
select
	*
from
	@table1 a
inner join
	@table2 b on a.id = b.idTable1

--Resolvendo o problema
select
	*
from
	@table1 a
cross apply
	(
		select
			top 1 
			*
		from
			@table2 b
		where
			a.id = b.idTable1
		order by
			id desc
	) as x

