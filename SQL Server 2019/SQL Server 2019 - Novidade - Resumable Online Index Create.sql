-- Criando o Banco de Dados DatabaseResumableOnlineIndexCreate --
Create Database DatabaseResumableOnlineIndexCreate
Go

-- Acessando o Banco de Dados DatabaseResumableOnlineIndexCreate --
Use DatabaseResumableOnlineIndexCreate
Go

-- Consultando as opções do Banco de Dados DatabaseResumableOnlineIndexCreate -- 
Select DatabasePropertyEx('DatabaseResumableOnlineIndexCreate','Collation') As 'Recovery',
           DatabasePropertyEx('DatabaseResumableOnlineIndexCreate','Recovery') As 'Recovery',
		   DatabasePropertyEx('DatabaseResumableOnlineIndexCreate','Status') As Status,
           DatabasePropertyEx('DatabaseResumableOnlineIndexCreate','Version') As Version
Go

Select name, database_id, compatibility_level As 'Nível de Compatibilidade', 
           recovery_model As ' ID - Modelo Recuperação', 
		   recovery_model_desc As 'Modelo de Recuperação'
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

-- Definindo o bloco de execução para inserção da Massa de Dados --
Set NoCount On
Go

Declare @ContadorDeRegistros Int

Set @ContadorDeRegistros = 1

While @ContadorDeRegistros <= 2000000 -- 2 milhões de registros lógicos   
Begin 
   
 Insert Into TableResumableOnlineIndexCreate Values (Concat('MVPConfUser',@ContadorDeRegistros), 
                                                                                         Concat('MVPC',@ContadorDeRegistros/100,Char(Rand()*95),'onf',IsNull(Char(Rand()*255),'a'),Convert(Int,Rand()*2020)), 
   																				        Current_TimeStamp)

 Print @ContadorDeRegistros

 Set @ContadorDeRegistros = @ContadorDeRegistros + 1
End

-- Aqui começa o ResumableOnLineIndexCreate --

-- Abrir nova query e configurar a criação do índice --
Use DatabaseResumableOnlineIndexCreate
Go

Create NonClustered Index IND_NonClustered_TableResumableOnlineIndexCreate_Descricao 
 On dbo.TableResumableOnlineIndexCreate(Descricao) With (Resumable = On)
Go

-- Vai dar erro, temos que configurar a opção OnLine=On --

Create NonClustered Index IND_NonClustered_TableResumableOnlineIndexCreate_Descricao 
 On dbo.TableResumableOnlineIndexCreate(Descricao) With (OnLine = On, Resumable = On)
Go

-- Agora abrir nova query para realizar a pause --

Alter Index IND_NonClustered_TableResumableOnlineIndexCreate_Descricao On dbo.TableResumableOnlineIndexCreate
Pause -- Aqui vamos forçar a pause na criação do índice
Go

/* Voltar para query de criação do índice e verificar o erro apresentado, na query de alteração o comando é realizado 
com sucesso mas na query de criação não, isso é um comportamento normal, ao realizar o Pause estamos interrompendo a 
execução do Create Index */

-- Vamos validar o State de criação do índice, destacar as colunas percent e state --
Select name, percent_complete, state_desc, last_pause_time, page_count
From sys.index_resumable_operations
Go

-- Vamos realizar o Resume para dar continuidade na criação do índice --
Alter Index IND_NonClustered_TableResumableOnlineIndexCreate_Descricao On dbo.TableResumableOnlineIndexCreate
Resume -- Aqui vamos aplicar o Resumo para dar continuidade na criação do índice
Go

-- Verificar novamente o State_desc do índice, descartar a coluna State_Desc e page_count --
Select name, percent_complete, state_desc, last_pause_time, page_count
From sys.index_resumable_operations
Go

Alter Index IND_NonClustered_TableResumableOnlineIndexCreate_Descricao On dbo.TableResumableOnlineIndexCreate
Resume -- Aqui vamos forçar a pause na criação do índice
Go

/* Importante destacar que não é possível realizar a criação de um Resumable OnLine Index Create com a opção
SORT_IN_TEMPDB = ON, pois o TempDB não suporta a uso da opção OnLine = On */
