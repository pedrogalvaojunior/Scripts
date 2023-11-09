EXEC msdb.dbo.sp_send_dbmail
   @recipients     = 'xxxxxx@xxxxxx.com', 
   @subject        = 'Reports',
   @query = ' SELECT ID,Indicator,EffecDate,ProvNumber,ProvName,ErrorDescription FROM IntegrationDb.dbo.[Report]',
   @attach_query_result_as_file = 1,
   @query_attachment_filename= 'Report.xlsx'