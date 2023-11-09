drop table exemplo

Create Table Exemplo (campo int, campo2 varchar(10))

insert into Exemplo (campo, campo2) values (1.21,'A')

insert into Exemplo (campo, campo2) values (1.23,'B')

insert into Exemplo (campo, campo2) values (2.9,'C')

insert into Exemplo (campo, campo2) values (3.3,'D')

Create View Temp 

As

Select Dense_Rank() Over (order by campo) As Valor,

campo2

From Exemplo

select * from temp

create Function Ufn_ReturnRank (@campo2 varchar(10))

returns table

as

return Select Dense_Rank() Over (order by campo) As Valor,

campo2

From Exemplo Where campo2 = @Campo2

 

Select * from dbo.Ufn_ReturnRank('A')


