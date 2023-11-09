create table Console(
	ConsoleID int identity,
	Nome varchar(100),
	Fabricante varchar(100),
	DataLancamento datetime
)

create table Jogo(
	JogoID int identity,
	Nome varchar(250),
	ConsoleID int,
	Categoria varchar(3),
	PrecoLocacao numeric(18,2) 
)

create table JogosLocacao(
	LocacaoID int not null,
	JogoID int not null,
	Valor numeric(18,2)
)
create table Log(
	LogID int identity,
	Operacao varchar(25),
	Descricao varchar(250),
	Data datetime
)
create table Locacao(
	LocacaoID int identity,
	ClienteID int,
	NumeroCupom numeric(18,2),
	DataLocacao datetime,
	Observacoes varchar(250)	
)
create table Cliente(
	ClienteID int identity,
	Nome varchar(100),
	Endereco varchar(150),
	Telefone varchar(20),
	DataCadastro datetime,
	Fidelidade varchar(3)	
)

ALTER TABLE Console ADD CONSTRAINT PK_ConsoleID PRIMARY KEY (ConsoleID)
ALTER TABLE Jogo ADD CONSTRAINT PK_JogoID PRIMARY KEY (JogoID)
ALTER TABLE Locacao ADD CONSTRAINT PK_LocacaoID PRIMARY KEY (LocacaoID)
ALTER TABLE Cliente ADD CONSTRAINT PK_ClienteID PRIMARY KEY (ClienteID)
ALTER TABLE Log ADD CONSTRAINT PK_LogID PRIMARY KEY (LogID)
ALTER TABLE	JogosLocacao ADD CONSTRAINT	PK_JogosLoc PRIMARY KEY (LocacaoID, JogoID)

ALTER TABLE Jogo ADD CONSTRAINT FK_ConsoleID FOREIGN KEY (ConsoleID) references Console
ALTER TABLE Locacao ADD CONSTRAINT FK_ClienteID FOREIGN KEY (ClienteID) references Cliente

insert into Console values('Xbox350','Microsoft',GETDATE())
insert into Console values('PlayStation 3','Sony',GETDATE())
insert into Console values('Wii','Nintendo',GETDATE())
insert into Console values('PSP','Sony',GETDATE())

insert into Jogo values('Halo 3', 1,null,4.50)
insert into Jogo values('God of War', 2,null,5.50)
insert into Jogo values('Wii', 3,null,3.50)
insert into Jogo values('PSP', 4,null,3.00)

insert into Cliente values('Carolina','Rua 01',null,GETDATE(),null)
insert into Cliente values('Vitor','Rua 02',null,GETDATE(),null)
insert into Cliente values('Sergio','Rua 03',null,GETDATE(),null)
insert into Cliente values('Fernanda','Rua 04',null,GETDATE(),null)

insert into Locacao values (1,101,GETDATE(),null)
insert into Locacao values (2,102,GETDATE(),null)
insert into Locacao values (3,103,GETDATE(),null)
insert into Locacao values (4,104,GETDATE(),null)

insert into JogosLocacao values (1,1,4.50)
insert into JogosLocacao values (2,2,5.50)
insert into JogosLocacao values (2,2,3.50)
insert into JogosLocacao values (2,2,3.00)


Create Table T1
(Codigo Int)

Declare @Linhas Int

Set @Linhas=(Select COUNT(*) from T1)

If (Select COUNT(*) from T1) = 0
 Select 'Vazia'
Else
 Select 'Tem alguma coisa' 


Create FUNCTION dbo.fnDevolucaoJogos(@ID int)
RETURNS date
BEGIN
  DECLARE @Cliente varchar(3), @Data Date
  
  SET @Cliente = (
      SELECT Fidelidade
      FROM Cliente C INNER JOIN Locacao L
      ON C.ClienteID = L.ClienteID
      WHERE LocacaoID = @ID
      )
      
  If @Cliente = 'A'
  Set @Data=(SELECT DataLocacao+9 FROM Locacao WHERE LocacaoID = @ID)  
  
   IF @Cliente = 'B'
   Set @Data=(SELECT DataLocacao+7 FROM Locacao WHERE LocacaoID = @ID) 
  ELSE
   Set @Data=(SELECT DataLocacao+3 FROM Locacao WHERE LocacaoID = @ID) 
  
  Return(@Data)
 END


SELECT [MRP].[dbo].[fnDevolucaoJogos] (1) As 'Data'

Update Locacao
Set DataLocacao = (SELECT [dbo].[fnDevolucaoJogos] (1) )
Where LocacaoId = 1