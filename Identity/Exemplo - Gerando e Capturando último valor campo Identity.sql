create table teste
 (codigo int identity(1,1),
  descricao varchar(10))

insert into teste values('teste')
select @@identity

drop table teste





