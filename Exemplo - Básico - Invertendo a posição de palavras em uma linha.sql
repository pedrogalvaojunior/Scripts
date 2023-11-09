create table produto
 (nomeproduto varchar(100))

 Insert Into Produto Values ('Capa USH'), ('USH Capa'), ('Capa Ikase')

-- c�digo #1 v3
-- simula��o de par�metro de pesquisa escrito pelo usu�rio
declare @pPesq varchar(30);
set @pPesq= ' capa ';

----- c�digo inicia aqui
-- invers�o do par�metro de pesquisa
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