-- Criando o Banco de Dados DatabaseResumableOnlineIndexCreate --
Create Database DatabaseResumableOnlineIndexCreate
Go

-- Acessando o Banco de Dados DatabaseResumableOnlineIndexCreate --
Use DatabaseResumableOnlineIndexCreate
Go

-- Consultando as op��es do Banco de Dados DatabaseResumableOnlineIndexCreate -- 
Select DatabasePropertyEx('DatabaseResumableOnlineIndexCreate','Collation') As 'Recovery',
           DatabasePropertyEx('DatabaseResumableOnlineIndexCreate','Recovery') As 'Recovery',
		   DatabasePropertyEx('DatabaseResumableOnlineIndexCreate','Status') As Status,
           DatabasePropertyEx('DatabaseResumableOnlineIndexCreate','Version') As Version
Go

Select name, database_id, compatibility_level As 'N�vel de Compatibilidade', 
           recovery_model As ' ID - Modelo Recupera��o', 
		   recovery_model_desc As 'Modelo de Recupera��o'
From sys.databases
Where Name = 'DatabaseResumableOnlineIndexCreate'
Go

-- Criando a Tabela TableResumableOnlineIndexCreate --
Create Table TableResumableOnlineIndexCreate
(Codigo Int Identity(1,1) Primary Key Clustered,
 Usuario Varchar(50) Null,
 Senha NVarChar(30) Null,
 MarcadorDeTempo DateTime Not Null)
Go

-- Definindo o bloco de execu��o para inser��o da Massa de Dados --
Set NoCount On
Go

Declare @ContadorDeRegistros Int

Set @ContadorDeRegistros = 1

While @ContadorDeRegistros <= 2000000 -- 2 milh�es de registros l�gicos   
Begin 
   
 Insert Into TableResumableOnlineIndexCreate Values (Concat('MVPConfUser',@ContadorDeRegistros), 
                                                                                         Concat('MVPC',@ContadorDeRegistros/100,Char(Rand()*95),'onf',IsNull(Char(Rand()*255),'a'),Convert(Int,Rand()*2020)), 
   																				        Current_TimeStamp)

 Print @ContadorDeRegistros

 Set @ContadorDeRegistros = @ContadorDeRegistros + 1
End

-- Aqui come�a o ResumableOnLineIndexCreate --

-- Abrir nova query e configurar a cria��o do �ndice --
Use DatabaseResumableOnlineIndexCreate
Go

Create NonClustered Index IND_NonClustered_TableResumableOnlineIndexCreate_Descricao 
 On dbo.TableResumableOnlineIndexCreate(Descricao) With (Resumable = On)
Go

-- Vai dar erro, temos que configurar a op��o OnLine=On --

Create NonClustered Index IND_NonClustered_TableResumableOnlineIndexCreate_Descricao 
 On dbo.TableResumableOnlineIndexCreate(Descricao) With (OnLine = On, Resumable = On)
Go

-- Agora abrir nova query para realizar a pause --

Alter Index IND_NonClustered_TableResumableOnlineIndexCreate_Descricao On dbo.TableResumableOnlineIndexCreate
Pause -- Aqui vamos for�ar a pause na cria��o do �ndice
Go

/* Voltar para query de cria��o do �ndice e verificar o erro apresentado, na query de altera��o o comando � realizado 
com sucesso mas na query de cria��o n�o, isso � um comportamento normal, ao realizar o Pause estamos interrompendo a 
execu��o do Create Index */

-- Vamos validar o State de cria��o do �ndice, destacar as colunas percent e state --
Select name, percent_complete, state_desc, last_pause_time, page_count
From sys.index_resumable_operations
Go

-- Vamos realizar o Resume para dar continuidade na cria��o do �ndice --
Alter Index IND_NonClustered_TableResumableOnlineIndexCreate_Descricao On dbo.TableResumableOnlineIndexCreate
Resume -- Aqui vamos aplicar o Resumo para dar continuidade na cria��o do �ndice
Go

-- Verificar novamente o State_desc do �ndice, descartar a coluna State_Desc e page_count --
Select name, percent_complete, state_desc, last_pause_time, page_count
From sys.index_resumable_operations
Go

Alter Index IND_NonClustered_TableResumableOnlineIndexCreate_Descricao On dbo.TableResumableOnlineIndexCreate
Resume -- Aqui vamos for�ar a pause na cria��o do �ndice
Go

/* Importante destacar que n�o � poss�vel realizar a cria��o de um Resumable OnLine Index Create com a op��o
SORT_IN_TEMPDB = ON, pois o TempDB n�o suporta a uso da op��o OnLine = On */
