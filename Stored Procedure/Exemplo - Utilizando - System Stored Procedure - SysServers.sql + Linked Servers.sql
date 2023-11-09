/* ****************************************** */
/*ligando um servidor remoto  */

SELECT * FROM Master.dbo.sysservers

SELECT * FROM saopaulo.siscom.dbo.cliente

SELECT * FROM Tocantins.siscom.dbo.cliente

/* ****************************************** */
Exec sp_addlinkedserver
        @server     = 'Amapa',
        @srvproduct = 'SQL Server'

Exec sp_DropServer 'Amapa'

/* ****************************************** */
Exec sp_addlinkedsrvlogin
      @rmtsrvname  = 'Amapa', 
      @useself     = 'False', 
     @locallogin  = 'sa',
     @rmtuser     = 'sa', 
     @rmtpassword = ''

Exec sp_droplinkedsrvlogin
      @rmtsrvname  = 'Amapa', 
     @locallogin  = 'sa'



/* ****************************************** */
CREATE VIEW V_ClienteRemoto
AS
SELECT 'Tocantins' as Servidor,* FROM Tocantins.Siscom.dbo.Cliente
UNION ALL
SELECT 'Pernambuco',* FROM Pernambuco.Siscom.dbo.Cliente
UNION ALL
SELECT 'Amapa',* FROM Amapa.Siscom.dbo.Cliente
/* ****************************************** */
SELECT * FROM V_ClienteRemoto


