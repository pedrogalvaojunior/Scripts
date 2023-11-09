Create Database Teste

Use Teste

Create Table Teste
(Codigo Int,
  Descricao Varchar(100)
)

Create User UserVP from Login UserVP
Create User UserAdHoc from Login UserAdHoc
Create User UserMarketing from Login UserMarketing

grant select on object:: teste.dbo.teste to uservp
grant select on object:: teste.dbo.teste to useradhoc
grant select on object:: teste.dbo.teste to userMarketing
go

grant insert on object:: teste.dbo.teste to uservp
grant insert on object:: teste.dbo.teste to useradhoc
grant insert on object:: teste.dbo.teste to userMarketing
go

Execute As Login ='UserVP'
SELECT [Codigo]
      ,[Descricao]
  FROM [TESTE].[dbo].[Teste]
GO

Execute As Login ='UserAdHoc'
SELECT [Codigo]
      ,[Descricao]
  FROM [TESTE].[dbo].[Teste]
GO

-- Permitindo troca de usuário de forma impersonate --
Grant Impersonate On User:: UserVP To UserAdHoc

-- Resetando as conexões em uso no Contexto de Banco de Dados --
Revert 

Execute As Login ='UserAdHoc'
go
  
Declare @Contador Int

Set @contador=1

While @Contador <=100000000
 Begin
  
  Select * from Teste
  
  Set @Contador=@Contador+1
 End
 
Execute As Login ='UserVP'
go
Insert Into teste default values
Go 100000   
Go 

Execute As Login ='UserMarketing'
go
Insert Into teste default values
Go 100000
Go


Execute As Login ='UserAdHoc'
go
Insert Into teste default values
Go 100000
Go