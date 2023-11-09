Declare @CodSequencial Int,
        @Contador Int,
        @CodRelacionamento Int,
        @NovoCodSequencial Int
   
         
Set @Contador=0
Set @CodRelacionamento=0
Set @NovoCodSequencial=-1

DECLARE Contador_Cursor CURSOR FOR
 SELECT CodSequencialProduto FROM PQCxME Order By CodSequencialProduto
  OPEN Contador_Cursor

While @Contador <=(Select Count(CodSequencialProduto) from PQCxME)
 Begin
 
  FETCH NEXT FROM Contador_Cursor
  INTO @CodSequencial

  If @CodSequencial <> @NovoCodSequencial
   Begin
    Set @NovoCodSequencial = @CodSequencial
  
    Set @CodRelacionamento=@CodRelacionamento+1
    
    Update PQCxME
    Set CodRelacionamento=@CodRelacionamento
    Where CodSequencialProduto=@NovoCodSequencial 
   End

   SET @Contador=@Contador+1   
 END

CLOSE Contador_Cursor
DEALLOCATE Contador_Cursor