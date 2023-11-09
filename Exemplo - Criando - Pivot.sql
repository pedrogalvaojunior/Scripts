declare @pessoas as table (id int, nome varchar(30))
declare @telefones as table (idpessoa int, tel varchar(9))
insert into @pessoas values(1,'Marcelo')
insert into @pessoas values(2,'Camila')
insert into @pessoas values(3,'Tricolor')

insert into @telefones values(1,'123-1234')
insert into @telefones values(1,'222-2222')
insert into @telefones values(1,'333-3333')
insert into @telefones values(2,'123-1234')
insert into @telefones values(2,'4444-4234')
insert into @telefones values(2,'1406')
insert into @telefones values(3,'125487-12')
;with cte
as
(
select id,nome,tel, row_number() over (partition by id,nome order by id,nome ) as contador from @pessoas a inner join @telefones b ON a.id = b.idpessoa
)
select * from 
(select id,nome,tel,contador from cte ) d
    pivot (max(tel) for contador in ([1],[2],[3])) as pvt
