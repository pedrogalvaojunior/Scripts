EXEC master.dbo.xp_cmdshell 
'bcp "SELECT * FROM master.dbo.sysobjects FOR XML AUTO" queryout C:\xml.xml -S "SERVERWINDB" -T -c' 