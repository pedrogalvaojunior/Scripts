CREATE VIEW V_CliRemoto
AS
SELECT 'Pernambuco' as Servidor,*
FROM OPENROWSET('SQLOLEDB','Pernambuco';
                'sa';'',
                'SELECT *
                 FROM Siscom.dbo.Cliente
                 ORDER BY Nome_Cli')
UNION ALL
SELECT 'Amapa',*
FROM OPENROWSET('SQLOLEDB','Amapa';
                'sa';'',
                'SELECT *
                 FROM Siscom.dbo.Cliente
                 ORDER BY Nome_Cli')
UNION ALL
SELECT 'Tocantins',*
FROM OPENROWSET('SQLOLEDB','Tocantins';
                'sa';'',
                'SELECT *
                 FROM Siscom.dbo.Cliente
                 ORDER BY Nome_Cli')
/* ******************************************** */
SELECT * FROM V_CliRemoto
/* ******************************************* */
SELECT * FROM IMPACTA.DBO.ALUNO

SELECT * FROM Master.dbo.sysservers

SELECT * FROM SAOPAULO.SISCOM.DBO.CLIENTE