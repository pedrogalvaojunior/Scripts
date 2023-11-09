Declare @Tabela Table
 (Codigo Int Primary Key Identity(1,1),
  Status Char(1),
  Quantidade Int,
  Data Date Default GetDate())

Insert Into @Tabela (Status, Quantidade) Values ('N',10),('S',20)
Insert Into @Tabela (Status, Quantidade) Values ('N',20),('S',40)
Insert Into @Tabela (Status, Quantidade) Values ('N',30),('S',60)

Insert Into @Tabela (Status, Quantidade) Values ('N',40),('S',80)
Insert Into @Tabela (Status, Quantidade) Values ('N',50),('S',100)
Insert Into @Tabela (Status, Quantidade) Values ('N',60),('S',120)

Insert Into @Tabela (Status, Quantidade) Values ('N',70),('S',140)
Insert Into @Tabela (Status, Quantidade) Values ('N',80),('S',160)
Insert Into @Tabela (Status, Quantidade) Values ('N',90),('S',180)

Declare @Registros Table
 (Codigo Int Primary Key Identity(1,1),
  ValoresAcumulados Varchar(Max))

Declare @Valores Varchar(Max), 
		@Contador Int

Set @Contador = 1 

While @Contador <= (Select Count(Codigo) From @Tabela)
Begin

  Set @Valores = (Select Status +' '+ Convert(Varchar(10),Quantidade) +' '+ Convert(Varchar(10),Data) + '' From @Tabela Where Codigo = @Contador) 
  
  If @Contador = 1
   Insert @Registros Values (@Valores)
  Else
  Begin	   
   
   Update @Registros
   Set ValoresAcumulados = ValoresAcumulados + @Valores

  End

 Set @Contador += 1  

End

Select ValoresAcumulados from @Registros