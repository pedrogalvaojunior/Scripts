-- Criando uma nova Stored Procedure --
CREATE PROCEDURE P_EXIBIRMENSAGEM
As
 Set NoCount On
 
 Begin
  Print 'Olá Mundo, este é um Teste!!!'
End

-- Executando a Stored Procedure --
Exec P_EXIBIRMENSAGEM;
Go

Execute P_EXIBIRMENSAGEM;
Go

SP_ExecuteSQL P_ExibirMensagem;
Go

-- Alterando a Stored Procedure --
Alter Procedure P_ExibirMensagem (@Usuario Varchar(20))
As
 Set NoCount On --Desativando a contagem de linhas processadas
 
 Begin
  Print @Usuario+': Olá Mundo, este é um Teste!!!'
End

-- Executando a Stored Procedure
Execute P_ExibirMensagem 'Pedro Galvão Junior'

-- Alterando a Stored Procedure --
Alter Procedure P_ExibirMensagem (@Usuario Varchar(20), @AnoNascimento SmallInt)
As
 Set NoCount On --Desativando a contagem de linhas processadas --
 
 Begin
  Declare @Resultado Int;
  Set @Resultado=(Select YEAR(GETDATE())-@AnoNascimento) ;
      
  Print @Usuario+': Olá Mundo, faz '+Convert(Varchar(2),@Resultado)+' anos que eu nasci!!!!';
End

-- Executando a Stored Procedure
Execute P_ExibirMensagem 'Pedro Galvão Junior', 1980

Create Table Objetos
(Codigo TinyInt Primary Key Identity,
  Nome Char(10))

Create Table Objetos_Log
(Codigo TinyInt Primary Key Identity,
 CodObjeto TinyInt,
 Evento Char(1))

-- Criando um novo Trigger --
Create Trigger T_Objetos_Log_Inserir
On Objetos
For Insert
As

Set NoCount On;

Insert Into Objetos_Log (CodObjeto, Evento)
Select Codigo, 'I' from Inserted

Insert Into Objetos Values ('Garfo');
Insert Into Objetos Values ('Colher');
Insert Into Objetos Values ('Faca');
Insert Into Objetos Values ('Panela');

Select * from Objetos_Log

-- Criando um novo Trigger de Update --
Create Trigger T_Objetos_Log_Atualizar
On Objetos
For Update
As

Set NoCount On;

Insert Into Objetos_Log (CodObjeto, Evento)
Select Codigo, 'U' from Inserted

Update Objetos
Set Nome='Caneca'
Where Codigo = 1

-- Criando um novo Trigger de Delete --
Alter Trigger T_Objetos_Log_Excluir
On Objetos
After Delete
As

Set NoCount On;

Insert Into Objetos_Log (CodObjeto, Evento)
Select Codigo, 'D' from deleted

Delete from Objetos
Where Codigo = 1

Select Codigo, CodObjeto,
           Case Evento
            When 'I' Then 'Insert'
            When 'U' Then 'Atualização'
            When 'D' Then 'Exclusão'
          End As Eventos
From Objetos_Log
Order By Evento           

-- Criando uma nova função In-Line--
Create Function F_Log_Eventos (@TipoEvento Char(1))
Returns Table
As
 	Return(Select * from Master.dbo.Objetos_Log
  	Where Evento = @TipoEvento) 
Go
--Executando
Select * from F_Log_Eventos('U')


-- Criando uma nova função Scalar --
Create Function F_SomarValores (@Numero Int, @Numero2 Int)
Returns Int
As
Begin
 Declare @Total Int
 Set @Total=@Numero+@Numero2
  
 Return (@Total)
End
Go

--Executando
Select dbo.F_SomarValores (1,2) As Resultados


-- Criando uma nova função Multi-Statament --
Create Function F_ConsultarObjetos (@Codigo Int)
Returns @Tabela1 Table
         	 (codigo int,
	        descricao varchar(10))
As
 Begin
  Insert @Tabela1
  Select Codigo, Nome from Objetos
  Where Codigo = @Codigo
  
  Return
 End

Go

Select * from F_ConsultarObjetos(5)