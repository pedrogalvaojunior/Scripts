SELECT NomeUsuario,
           NomeDepto,
           Processador,
           OS,
           Memoria,
           HD1
FROM CADMICROS
WHERE PROCESSADOR Like 'AMD K6/2 5%'
OR       PROCESSADOR Like 'VIA%'
OR       PROCESSADOR Like 'Intel Pentium 1%'
OR       PROCESSADOR Like 'Intel Pentium 2%'
OR       PROCESSADOR Like 'Intel Celeron 4%'
OR       PROCESSADOR Like 'Intel Pentium M%'
OR       PROCESSADOR Like 'AMD 586%' 
ORDER BY PROCESSADOR


SELECT * FROM CADMICROS
ORDER BY PROCESSADOR

If Exists (select srvname='TESTE2003' from master..sysservers)
 Begin
  Exec sp_dropserver 
         @server='TESTE2003'

  Exec sp_droplinkedsrvlogin
         @rmtsrvname='TESTE2003',
         @locallogin='JR'

  Exec sp_addlinkedserver
       @server='TESTE2003',
       @srvproduct='SQL Server' 

  Exec sp_addlinkedsrvlogin
         @rmtsrvname='TESTE2003',
         @useself='False',
         @locallogin='JR',
         @rmtuser='JR',
        @rmtpassword='12345678'
 End
 


select * from sysservers

Exec sp_addlinkedserver
       @server='SERVERWIN2003',
       @srvproduct='SQL Server' 

Exec sp_addlinkedsrvlogin
 @rmtsrvname='SERVERWIN2003',
 @useself='False',
 @locallogin='JUNIOR',
 @rmtuser='JUNIOR',
 @rmtpassword='pdjm3825'

SELECT * FROM SERVERWIN.CUSTO100.dbo.CUSTO
WHERE CODPROD='4700051/52/53'

SELECT * FROM SERVERWIN.CUSTO100.dbo.FICHAIMPRESSA

SELECT DATEPART(MONTH,EDATA) AS MES,DATEPART(YEAR,EDATA) AS ANO,* FROM SERVERWIN.CUSTO100.DBO.FICHAIMPRESSA
WHERE CODPROD = '4700034/37' AND NUMFICHA = 26207
ORDER BY EDATA

