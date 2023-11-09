Create Database ResumableOnlineIndexRebuilds
Go

Use ResumableOnlineIndexRebuilds
Go

-- Criando a Tabela ResumableOnlineIndexRebuildsTable --
Create TABLE ResumableOnlineIndexRebuildsTable
  (Codigo int IDENTITY(1,1) NOT NULL,
   Cliente int NOT NULL,
   Vendedor varchar(30) NOT NULL,
   Quantidade smallint NOT NULL,
   Valor numeric(18, 2) NOT NULL,
   Data date NOT NULL
   Constraint [PK_ResumableOnlineIndexRebuildsTable_Codigo] Primary Key (Codigo)) 
   WITH(Data_Compression=PAGE)
Go

-- Inserindo a Massa de Dados na Tabela ResumableOnlineIndexRebuildsTable --
Declare @Texto Char(130), 
        @Posicao TinyInt, 
		@ContadorLinhas Int

Set @Texto = '0123456789@ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyzŽŸ¡ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåæçèéêëìíîïðñòóôõöùúûüýÿ' -- Existem 130 caracteres neste texto --

Set @ContadorLinhas = Rand()*1000000 -- Definir a quantidade de linhas para serem inseridas --

While (@ContadorLinhas >=1)
Begin

 Set @Posicao=Rand()*130

 If @Posicao <=125
  Begin
   Insert Into ResumableOnlineIndexRebuildsTable (Cliente, Vendedor, Quantidade, Valor, Data)
   Values(@ContadorLinhas, 
          Concat(SubString(@Texto,@Posicao+2,2),SubString(@Texto,@Posicao-4,4),SubString(@Texto,@Posicao+2,4)),
          Rand()*1000, 
	      Rand()*100+5, 
		  DATEADD(d, 1000*Rand() ,GetDate()))
  End
  Else
  Begin
    Insert Into ResumableOnlineIndexRebuildsTable (Cliente, Vendedor, Quantidade, Valor, Data)
    Values(@ContadorLinhas, 
           Concat(SubString(@Texto,@Posicao-10,1),SubString(@Texto,@Posicao+4,6),SubString(@Texto,@Posicao-12,3)),
           Rand()*1000, 
	       Rand()*100+5, 
		   DATEADD(d, 1000*Rand() ,GetDate()))

   End

   Set @ContadorLinhas = @ContadorLinhas - 1
End

-- Contando a quantidade de linhas da Tabela ResumableOnlineIndexRebuildsTable--
Select Count(*) From ResumableOnlineIndexRebuildsTable
Go  

-- Descobrindo o tamanho da Tabela ResumableOnlineIndexRebuildsTable --
Exec sp_spaceused 'ResumableOnlineIndexRebuildsTable'
Go

-- Realizando o primeiro Rebuild --
Alter Index [PK_ResumableOnlineIndexRebuildsTable_Codigo] ON ResumableOnlineIndexRebuildsTable
Rebuild With(ONLINE=ON, RESUMABLE=ON)
Go

-- Clicar no Cancel para similar uma interrupção --

-- Resumindo o processo de Rebuild do Índice --
Alter Index [PK_ResumableOnlineIndexRebuildsTable_Codigo] ON ResumableOnlineIndexRebuildsTable
Resume
Go

-- Consultando a View  sys.index_resumable_operations --
Select * from sys.index_resumable_operations
Go

-- Resumindo o processo de Pause do Índice --
Alter Index [PK_ResumableOnlineIndexRebuildsTable_Codigo] ON ResumableOnlineIndexRebuildsTable
Pause
Go

-- Consultando a View  sys.index_resumable_operations --
Select * from sys.index_resumable_operations
Go

-- Resumindo o processo de Abort do Índice --
Alter Index [PK_ResumableOnlineIndexRebuildsTable_Codigo] ON ResumableOnlineIndexRebuildsTable
Abort
Go