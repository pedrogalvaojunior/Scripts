create table produto
 (nomeproduto varchar(100))

 Insert Into Produto Values ('Capa USH'), ('USH Capa'), ('Capa Ikase')

-- código #1 v3
-- simulação de parâmetro de pesquisa escrito pelo usuário
declare @pPesq varchar(30);
set @pPesq= ' capa ';

----- código inicia aqui
-- inversão do parâmetro de pesquisa
declare @xPesq varchar(30), @xPos int;

set @xPesq= lower (replace (ltrim (rtrim (@pPesq)), '  ', ' '));
set @xPos= charindex (' ', @xPesq);
IF @xPos > 0
  set @xPesq= '% '+substring (@xPesq, (@xPos +1), len (@xPesq)) + ' ' 
              + substring (@xPesq, 1, (@xPos -1)) + ' %';


Select @xPesq, @xPos

-- consulta
SELECT nomeproduto
  from Produto
  where NomeProduto like @xPesq;