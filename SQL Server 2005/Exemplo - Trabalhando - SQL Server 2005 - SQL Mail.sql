use master
go
sp_configure 'show advanced options',1
go
reconfigure with override
go

sp_configure 'Database Mail XPs',1
go
reconfigure 
go


EXECUTE msdb.dbo.sysmail_add_account_sp
 @account_name = 'GENERIC', 
 @description = 'Mail account for all FocusONE P1 tickets',
 @email_address = 'GENERIC@GENERIC.com',
 @display_name = 'GENERIC',
 @username='GENERIC',
 @password='GENERIC',
 @mailserver_name = 'mail server address'

EXECUTE msdb.dbo.sysmail_add_profile_sp
 @profile_name = 'GENERIC_MailProfile',
 @description = 'Profile used for GENERIC to automatically send email'


EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
 @profile_name = 'GENERIC_MailProfile',
 @account_name = 'GENERIC',
 @sequence_number = 1

EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
 @profile_name = 'GENERIC_MailProfile',
 @principal_name = 'public',
 @is_default = 1 ;

Declare 
@subject1 varchar (100),
@email varchar (50),
SET @subject = (select 'ticket number'+convert(varchar(15),v.value)+ from tickets v (nolock))
set @email = (select 'ticket number'+convert(varchar(15),v.value)+' was open yesterday and assigned to John'+ from tickets v (nolock))


EXEC msdb.dbo.sp_send_dbmail @recipients= 'GENERIC@GENERIC.com',
@copy_recipients = 'GENERIC@GENERIC.com',
@subject = @subject1,
@body = @email,
 @body_format = 'HTML' ;
