-- Vers�o do SQL Server + Service Pack
SELECT  SERVERPROPERTY('servername') As "Nome do Servidor",
            SERVERPROPERTY('productversion') As Vers�o,
            SERVERPROPERTY ('productlevel') As "Service Pack", 
            SERVERPROPERTY ('edition') As Edi��o,
            @@Version As "Sistema Operacional"

--Visualizando a Vers�o do Sistema Operacional
Select @@Version

-- Mais Informa��es sobre o SQL Server
xp_msver
