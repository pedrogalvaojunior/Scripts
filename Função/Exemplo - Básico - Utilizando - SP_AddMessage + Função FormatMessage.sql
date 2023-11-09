USE master;
GO

EXEC sp_addmessage @msgnum = 60000, @severity = 16, 
   @msgtext = N'The item named %s already exists in %s.', 
   @lang = 'us_english';

EXEC sp_addmessage @msgnum = 60000, @severity = 16, 
   @msgtext = N'O nome do objeto %s já esta em uso em %s.', 
   @lang = 'BRAZILIAN';
GO

SELECT * FROM sys.messages WHERE message_id = 60000 AND language_id = 1046;

DECLARE @var1 VARCHAR(200);

SELECT @var1 = FORMATMESSAGE(60000, 'Teste', 'Testando');

SELECT @var1;


sp_dropmessage @msgnum=60000, @lang = 'us_english'