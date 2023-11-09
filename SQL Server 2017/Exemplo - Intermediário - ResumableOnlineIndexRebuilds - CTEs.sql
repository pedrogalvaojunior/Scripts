Create Database ResumableOnlineIndexRebuilds
Go

Use ResumableOnlineIndexRebuilds
Go

-- Criando a Tabela ResumableOnlineIndexRebuildsTable --
Create TABLE ResumableOnlineIndexRebuildsTable
  (Codigo Int Identity(1,1) Not Null,
   Cliente Int Not Null,
   Vendedor VarChar(30) Not Null,
   Quantidade SmallInt Not Null,
   Valor Numeric(18, 2) Not Null,
   Data Date Not Null
   Constraint [PK_ResumableOnlineIndexRebuildsTable_Codigo] Primary Key (Codigo)) 
   WITH(Data_Compression=PAGE)
Go

-- Inserindo a Massa de Dados na Tabela ResumableOnlineIndexRebuildsTable --
Declare @Texto Char(130), 
        @Posicao TinyInt, 
	@ContadorLinhas Int

Set @Texto = '0123456789@ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyzŸ¡ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖÙÚÛÜİàáâãäåæçèéêëìíîïğñòóôõöùúûüıÿ' -- Existem 130 caracteres neste texto --

Set @ContadorLinhas = Rand()*10000000 -- Definir a quantidade de linhas para serem inseridas --

;WITH CTENumero1 (Numero1) 
AS 
(
 SELECT * FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) Numero1 (Numero1) -- Elevando a 10 --
),

CTECrossJoins (Numeros) -- Forçando a junção cruzada de 10 milhões de linhas --  
AS 
(
 SELECT A.Numero1 FROM CTENumero1 a Cross Join CTENumero1 b 
							Cross Join CTENumero1 C
							Cross Join CTENumero1 d
							Cross Join CTENumero1 e 
							Cross Join CTENumero1 f
							Cross Join CTENumero1 g
 Where A.Numero1 <=@ContadorLinhas
),

NumeracaoSequencial (Numeros) 
AS 
( 
  Select ROW_NUMBER() Over (Order By Numeros) From CTECrossJoins
)

Insert Into ResumableOnlineIndexRebuildsTable (Cliente, Vendedor, Quantidade, Valor, Data)
SELECT Top (@ContadorLinhas)
       Abs(CheckSum(NewID())) As Cliente,
       (SUBSTRING(ca.Texto, ABS(CHECKSUM(NEWID())%126)+1,2) + 
	    SUBSTRING(ca.Texto, ABS(CHECKSUM(NEWID())%124)+2,2) + 
	    SUBSTRING(ca.Texto, ABS(CHECKSUM(NEWID())%124)+4,4)) As Vendedor,
       ABS(CHECKSUM(NEWID())%1000) As Quantidade,
       RAND(CHECKSUM(NEWID()))*100+5 As Valor,
       DATEADD(d,ABS(CHECKSUM(NEWID())%1000),GETDATE()) As Data
FROM NumeracaoSequencial NS CROSS APPLY (SELECT @Texto) CA (Texto)
Go

-- Contando a quantidade de linhas da Tabela ResumableOnlineIndexRebuildsTable--
Select Count(Codigo) As TotalLinhas From ResumableOnlineIndexRebuildsTable
Go  

-- Descobrindo o tamanho da Tabela ResumableOnlineIndexRebuildsTable --
Exec sp_spaceused 'ResumableOnlineIndexRebuildsTable'
Go

-- Realizando o primeiro Rebuild --
Alter Index [PK_ResumableOnlineIndexRebuildsTable_Codigo] ON ResumableOnlineIndexRebuildsTable
Rebuild With(ONLINE=ON, RESUMABLE=ON)
Go

-- Abrir nova query --

-- Resumindo o processo de Pause do Índice --
Alter Index [PK_ResumableOnlineIndexRebuildsTable_Codigo] ON ResumableOnlineIndexRebuildsTable
Pause
Go

-- Consultando a View  sys.index_resumable_operations --
Select * from sys.index_resumable_operations
Go

-- Abrir nova query --

-- Resumindo o processo de Abort do Índice --
Alter Index [PK_ResumableOnlineIndexRebuildsTable_Codigo] ON ResumableOnlineIndexRebuildsTable
Abort
Go

-- Clicar no Cancel para similar uma interrupção --

-- Resumindo o processo de Rebuild do Índice --
Alter Index [PK_ResumableOnlineIndexRebuildsTable_Codigo] ON ResumableOnlineIndexRebuildsTable
Resume
Go

-- Abrir nova query --

-- Consultando a View  sys.index_resumable_operations --
Select * from sys.index_resumable_operations
Go