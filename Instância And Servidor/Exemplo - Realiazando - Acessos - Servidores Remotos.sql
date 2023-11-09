/* ********************************************** */
-- Acessando dados de vários Servidores Remotos
SELECT 'SERVIDOR - BAHIA' AS SERVER,* 
FROM OPENROWSET('SQLOLEDB',
                            'BAHIA';
                            'sa';'',
                            'SELECT * FROM SISCOM.DBO.PRODUTO')
UNION ALL
SELECT 'SERVIDOR - CEARA' AS SERVER,* 
FROM OPENROWSET('SQLOLEDB',
                            'CEARA';
                            'sa';'',
                            'SELECT * FROM SISCOM.DBO.PRODUTO')
UNION ALL
SELECT 'SERVIDOR - SAOPAULO' AS SERVER,* 
FROM OPENROWSET('SQLOLEDB',
                            'SAOPAULO';
                            'sa';'',
                            'SELECT * FROM SISCOM.DBO.PRODUTO')
UNION ALL
SELECT 'SERVIDOR - TOCANTINS' AS SERVER,* 
FROM OPENROWSET('SQLOLEDB',
                            'TOCANTINS';
                            'sa';'',
                            'SELECT * FROM SISCOM.DBO.PRODUTO')
/* ********************************************** */
-- Montando Link Remoto permanente com outros servidores

Exec sp_AddLinkedServer
 @Server='SAOPAULO',
 @srvproduct='SQL SERVER'

Exec sp_AddLinkedServer
 @Server='TOCANTINS',
 @srvproduct='SQL SERVER'

Exec sp_AddLinkedServer
 @Server='BAHIA',
 @srvproduct='SQL SERVER'

Exec sp_addlinkedsrvlogin
      @rmtsrvname  = 'Amapa', 
      @useself     = 'False', 
     @locallogin  = 'sa',
     @rmtuser     = 'sa', 
     @rmtpassword = ''

Exec sp_droplinkedsrvlogin 'Amapa',null


/* ************************************************ */
SELECT * FROM BAHIA.SISCOM.DBO.CLIENTE
/* ************************************************ */
