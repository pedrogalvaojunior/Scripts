Create Table DDL_LogTransacoes
(TransID Int Identity(1,1) Primary Key,
 DataTransacao DateTime Default GetDate(),
 UsuarioTransacao VarChar(100) Default User_Name(), 
 LoginTransacao Varchar(100) Default Suser_Name(),
 LoginUsuarioSQLTransacao Varchar(100) Default Original_Login(),
 TipoEvento NVarchar(200) Null,
 Objeto NVarchar(200) Null,
 TipoObjeto NVarchar(200) Null,
 Comando_TSQL NVarchar(Max) Null)

Alter Trigger Trigger_DDL_LogTransacoes 
On Database
For DDL_DATABASE_LEVEL_EVENTS
As
 Begin
  Set NoCount On
  Declare @DadosXML XML
  
  Set @DadosXML=EVENTDATA()
  
  Insert Into DDL_LogTransacoes(TipoEvento,Objeto,TipoObjeto,Comando_TSQL)
                                Values(@DadosXML.value('(EVENT_INSTANCE/EventType)[1]','NVarchar(200)') ,
                                           @DadosXML.value('(EVENT_INSTANCE/ObjectName)[1]','NVarchar(200)') ,
										   @DadosXML.value('(EVENT_INSTANCE/ObjectType)[1]','NVarchar(200)') ,
										   @DadosXML.value('(EVENT_INSTANCE/TSQLCommand/CommandText)[1]','NVarchar(Max)'))
 End  

Create Table Teste
 (Codigo Int,
  Descricao Varchar(100))  
  
Insert Into Teste Values (1,'Arroz')
Insert Into Teste Values (2,'Arroz')
Insert Into Teste Values (3,'Arroz') 

Update Teste
Set Descricao='Feijão'
Where Codigo=3

Select * from DDL_LogTransacoes

Select * from sys.event_notification_event_types
Where TYPE_NAME Like '%Events%'
