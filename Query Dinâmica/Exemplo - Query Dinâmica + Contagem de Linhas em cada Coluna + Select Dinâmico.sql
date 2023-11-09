-- Conta em quantas linhas cada coluna está informada --
Declare @CT int, @C1 int, @C2 int, 
        @C3 int, @C4 int, @C5 int

Select @CT= Count(*), 
       @C1= Count(coluna1),  
	   @C2= Count(coluna2), 
       @C3= Count(coluna3), 
	   @C4= Count(coluna4), 
	   @C5= Count(coluna5)
From tabela

-- Verifica se ao menos uma coluna atende ao requisito --
If @CT = @C1 or @CT = @C2 or @CT = @C3 or @CT = @C4 or @CT = @C5
 Begin

-- monta comando SQL com somente as colunas que estejam completamente informadas
  Declare @ComandoSQL Varchar(2000)

  Set @ComandoSQL= 'SELECT ' +
                     case when @C1 = @CT then 'coluna1,' else '' end +
                     case when @C2 = @CT then 'coluna2,' else '' end +
	      		     case when @C3 = @CT then 'coluna3,' else '' end +
	 			     case when @C4 = @CT then 'coluna4,' else '' end +
				     case when @C5 = @CT then 'coluna5,' else '' end

  Set @ComandoSQL= Left(@ComandoSQL, Len(@ComandoSQL) -1) + ' from tabela;'

  PRINT @ComandoSQL

End