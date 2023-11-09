Create Table #ListarNomes
 (Codigo Int Identity(1,1),
   Nome VarChar(50))

Insert #ListarNomes Values('Junior Galvão')
Insert #ListarNomes Values('Eduardo Graça')
Insert #ListarNomes Values('Fernanda Galva')
Insert #ListarNomes Values('João Silva Galvez')
Insert #ListarNomes Values('Marcio de Jesuita Gernando')
Insert #ListarNomes Values('Marcio de Jnoas Belo de Garcia')


Declare @PosicaoEspaco Int,
           @Contador Int,
           @NomeFormatado VarChar(50)
     
Set @Contador=0

While @Contador <= (Select Count(*) from #ListarNomes)
 Begin
  Set @PosicaoEspaco=(Select PatIndex('% %',Nome) From #ListarNomes Where Codigo = @Contador)

  Select @NomeFormatado=Upper(Substring(Nome,1,1))+SubString(Nome,2, @PosicaoEspaco-1)+
                                     Upper(SubString(Nome,@PosicaoEspaco+1,1))+SubString(Nome,@PosicaoEspaco+2,Len(Nome))
  From #ListarNomes
  Where Codigo = @Contador

  Print 'Nome do Usuário formatado -->:'+@NomeFormatado

  Set @Contador = @Contador + 1
 End


Declare @Nome table
 (nome varchar(100))
 

Insert Into @Nome Values ('José Lucas')
Insert Into @Nome Values ('Pedro A. Galvão Junior')
Insert Into @Nome Values ('Eduardo Billeni Galvao')
      
Select Substring(nome,1,charindex(' ',nome,1))+
         Right(Nome,CharIndex(' ',Reverse(Nome))) from @Nome 