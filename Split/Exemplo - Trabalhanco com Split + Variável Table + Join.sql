CREATE TABLE tabela (ID int, VALOR varchar(200));
INSERT into tabela values 
  (1111,'A1, A2, A3  '), (2222,'B1'), (3333, ' C1,  C2,  C3,C4');

CREATE TABLE nova_tabela (ID int, VALOR varchar(30));
go

-- cria tabela auxiliar de números
set NoCount on;

declare @Nums table (N int);
declare @I int;

set @I= 0;

while @I <= 200
 begin
  INSERT into @Nums values (@I);
  set @I+= 1;
 end;

--
--INSERT into nova_tabela (ID, VALOR)
  SELECT T1.ID, ltrim(rtrim(SubString(T1.VALOR, N, CharIndex(',', T1.VALOR + ',', N) - N)))
    from tabela as T1  inner join  @Nums 
         on N <= DataLength(T1.VALOR) + 1
            and SubString(',' + T1.VALOR, N, 1) = ',';