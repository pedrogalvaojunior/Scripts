CREATE TABLE [dbo].[Tabelas](
 [idTabela] [int] NOT NULL,
 [NomeTabela] [varchar](100) NOT NULL,
 CONSTRAINT [PK11] PRIMARY KEY NONCLUSTERED 
(
 [idTabela] ASC
))

Go

Insert Into Tabelas Values (1, 'Acao')
Insert Into Tabelas Values (2, 'AcaoSistema')
Insert Into Tabelas Values (3, 'Acomodacao')
Insert Into Tabelas Values (4, 'Ajuda')
Insert Into Tabelas Values (5, 'Alergia')
Insert Into Tabelas Values (6, 'Alimento')
Insert Into Tabelas Values (7, 'AlimentoReferencia')
Insert Into Tabelas Values (8, 'AMB')
Insert Into Tabelas Values (9, 'Arquivo')
Insert Into Tabelas Values (10, 'Associado')

Vamos lá, para testar o que eu estou falando abra duas sessões do SQL, nós vamos executar um script em cada sessão ao mesmo tempo.

Na primeira, vamos bloquear o registro por 15 segundos, daqui a 1 minutor (mas para dar tempo de sincronizar os dois scripts).

Begin Transaction

 Declare @InicioScript DateTime

    set @InicioScript = DateAdd(minute, 1, getdate())

 Waitfor time @InicioScript

    Select getdate()

 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
    Select Top(1) * from Tabelas With (nowait, updlock, readpast)

 WaitFor Delay '00:00:15'

rollback Transaction

 

Rapidamente execute esse script na segunda sessão, ele vai começar daqui a 1 minuto e 5 segundos (para dar tempo da primeira sessão bloquear o registro).

Begin Transaction
 Declare @InicioScript DateTime
    set @InicioScript = DateAdd(second, 5, DateAdd(minute, 1, getdate()))

 Waitfor time @InicioScript

    Select getdate()

 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

 BEGIN TRY
  Update Tabelas with (nowait) set [NomeTabela] = 'ssss' Where [idTabela] = 1
 END TRY
 BEGIN CATCH
   Select 'Erro Lock: ' + Cast(@@ERROR as VarChar) 
    END CATCH;

rollback Transaction
