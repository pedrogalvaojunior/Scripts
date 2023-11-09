create table t (id int not null, taxcode int not null)
alter table t add constraint uq_t unique (taxcode)
-- Ok
insert into t values (1, 1)
-- Erro
insert into t values (2, 1)
-- Se quiser personalizar
BEGIN TRY
 insert into t values (2, 1)
END TRY
BEGIN CATCH
 IF ERROR_NUMBER() = 2627
 SELECT 'O código está duplicado'
END CATCH
drop table t
