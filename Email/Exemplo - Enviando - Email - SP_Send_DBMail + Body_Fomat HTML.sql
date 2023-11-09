DECLARE @p_body as nvarchar(max), @p_subject as nvarchar(max)
DECLARE @p_recipients as nvarchar(max), @p_profile_name as nvarchar(max)

SET @p_profile_name = N'General Administration Profile'
SET @p_recipients = N'recipient@testemail.com;multiple.recipients@dbmail.com'
SET @p_subject = N'This is a test mail using sp_send_dbmail'
SET @p_body = 'This is an HTML test email send using <b>sp_send_dbmail</b>.'

EXEC msdb.dbo.sp_send_dbmail
  @profile_name = @p_profile_name,
  @recipients = @p_recipients,
  @body = @p_body,
  @body_format = 'HTML',
  @subject = @p_subject