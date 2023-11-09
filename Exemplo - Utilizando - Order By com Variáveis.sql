create table produtos(
	Codigo varchar(10) not null,
	Descricao varchar(50) not null,
	Etc varchar(200)
);

insert into produtos values
  ('001', 'qualquer coca é boa', 'aaa'), 
  ('002', 'eu quero uma coca da pepsi', 'bbb'), 
  ('003', 'só que qualquer coca faz mal', 'ccc'),
  ('004', 'o que que a baiana tem?', 'ddd'),
  ('005', 'lá tem cocaína', 'eee'),
  ('006', 'Coca, cocaína e coca cola', 'fff'),
  ('007', 'aqui não tem', 'ggg'),
  ('008', 'a cocada é de côco', 'hhh')

declare @valor varchar(20), @valor2 varchar(20);
set @valor2 ='coca';
set @valor ='%'+@valor2+'%';

select Codigo, Descricao, Etc, 
      charindex(@VALOR2, Descricao) as posição,
      (len(Descricao)-charindex(@VALOR2,Descricao)+1) as restante,
      substring(Descricao, charindex(@VALOR2, Descricao), (len(Descricao)-charindex(@VALOR2,Descricao)+1)) as trecho
  from produtos
  where (Descricao LIKE @VALOR) OR (Codigo LIKE @VALOR)
  order by substring(Descricao, charindex(@VALOR2, Descricao), (len(Descricao)-charindex(@VALOR2,Descricao)+1))  