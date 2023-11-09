  -- Criando a Tabela --
  create table MyTest
  (id int
  , first int
  , sec int
  , third as (first + sec)
  );
  go

  -- Alterando a Tabela adicionando persistência --
  alter table MyTest 
   alter column third add persisted

