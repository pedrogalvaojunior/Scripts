USE EQUIPAMENTOS

select * from cadmicros

drop view teste
CREATE VIEW TESTE (codmicro, codusuario, processador) With Encryption
AS 
SELECT codmicro,codusuario, processador FROM CADMICROS

SELECT * FROM TESTE 
create table tab1
(descr char(20))

insert into tab1(descr) values ({Encrypt N 'minhasenha'})

select descr from tab1
where descr = {Encrypt N'minhasenha'} 

select Encrypt(Processador) from CadMicros

select processador from CadMicros
