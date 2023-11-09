USE DBSUPSQL;
GO
 
----====================================================================
--- ESCOPO DE CRIACAO DE TABELA , PK , INDICE ( NONCLUSTERED) 
----====================================================================

If Object_Id ('Auditoria_Logon') Is Not Null
 Drop Table Auditoria_Logon ;
Go


Create Table dbo.Auditoria_Logon

 (  id_Auditoria_Logon  Int Identity (1,1),
    [Login]        Varchar(100)           , 
    Data_Login     SmallDatetime          ,
    Usuario        Varchar(100)           , 
    Aplicacao      Varchar(100)           , 
    [Host]         Varchar(100)           , 
    [DataBase]     Varchar(100)           , 
    Evento         Varchar(Max))


Go 
Alter Table Auditoria_Logon Add Constraint Pk_Auditoria_Logon  Primary Key (id_Auditoria_Logon)
Go

Create NonClustered Index ID_01 On Auditoria_Logon ([Login], Data_Login ) With FillFactor = 80 
Go 

----====================================================================
--- TRIGGER DE LOGON 
----====================================================================

If Object_Id ('trg_Auditoria_LOgin') Is Not Null
 Drop  trg_Auditoria_LOgin ;
Go

CREATE TRIGGER trg_Auditoria_LOgin
          ON ALL SERVER FOR LOGON -- With Execute as 'sa'
          AS
BEGIN
         

Insert Into Auditoria_Logon ( Login,Data_Login,Usuario,Aplicacao,[Host],[DataBase],Evento ) 

  Select Login        = ORIGINAL_LOGIN()  , 
         Data_Login   = Getdate()         , 
         Usuario      = USER_NAME()       , 
         Aplicacao    = APP_NAME()        , 
         Host         = HOST_NAME()       , 
         [DataBase]   = DB_NAME()         ,

         Evento       = Convert(Varchar(max),EVENTDATA())

----========================================================================
--- ESSE FILTRO DEPENDE DA NOSSA NECESSIDADE LOGAR UMA VEZ AO DIA OU LOGAR 
--- TODA VEZ QUE ABRIR UMA SESSAO COM SQL SERVER ?
----=======================================================================


 Where Not Exists  ( Select * 
                        From Auditoria_Logon aa
                       Where Usuario = USER_NAME()
                         And Convert(Varchar(10), Data_Login ,113) = Convert(Varchar(10), Getdate()  ,113))
        
   END;



 

 