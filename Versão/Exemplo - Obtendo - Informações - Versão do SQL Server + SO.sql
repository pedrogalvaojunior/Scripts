-- Versão do SQL Server + Service Pack
SELECT  SERVERPROPERTY('servername') As "Nome do Servidor",
            SERVERPROPERTY('productversion') As Versão,
            SERVERPROPERTY ('productlevel') As "Service Pack", 
            SERVERPROPERTY ('edition') As Edição,
            @@Version As "Sistema Operacional"

--Visualizando a Versão do Sistema Operacional
Select @@Version

-- Mais Informações sobre o SQL Server
xp_msver
