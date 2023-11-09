Select 
            Case SERVERPROPERTY('EngineEdition')
             When 1 Then 'SQL Server Personal or Desktop Engine'
             When 2 Then 'SQL Server Standard' 
             When 3 Then 'SQL Server Enterprise' 
             When 4 Then 'SQL Server Express'
            End AS Edi��o,
            SERVERPROPERTY('LicenseType'),
            SERVERPROPERTY('NumLicenses')
            
            
SELECT  SERVERPROPERTY('servername') As "Nome do Servidor",
            SERVERPROPERTY('productversion') As Vers�o,
            SERVERPROPERTY ('productlevel') As "Service Pack", 
            SERVERPROPERTY ('edition') As Edi��o,
            @@Version As "Sistema Operacional"