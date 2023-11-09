CREATE TABLE emails(
	id_tabela  int,
	nome_cliente  varchar(80),
	email_cliente  varchar (150)
)

INSERT INTO emails VALUES (1,'User_teste01','User_teste01@empresa.com.br')
INSERT INTO emails VALUES (2,'User_teste02','User_teste02@empresa.com.br')
INSERT INTO emails VALUES (3,'User_teste03','User_teste03@empresa.com.br')
INSERT INTO emails VALUES (4,'User_teste04','User_teste04@empresa.com.br')
INSERT INTO emails VALUES (5,'User_teste05','User_teste05@empresa.com.br')
INSERT INTO emails VALUES (6,'User_teste06','User_teste06@empresa.com.br')
INSERT INTO emails VALUES (7,'User_teste07','User_teste07@empresa.com.br')

DECLARE @lista_emails VARCHAR(MAX)

SELECT  DISTINCT 
		@lista_emails = STUFF((
			SELECT ';' + email_cliente
				FROM emails
			FOR XML PATH('')),1,1,''
			) --AS Lista_Emails
			FROM emails 

	SELECT @lista_emails 

	EXEC msdb.dbo.sp_send_dbmail 
		@profile_name = 'Nome Perfil',
		@recipients = @lista_emails

GO