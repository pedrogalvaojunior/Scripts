/* *********************************************** */
CREATE PROCEDURE P_PERIODO
@HORA INT
AS
 IF @HORA >=0 AND @HORA <=6
      PRINT 'MADRUGADA'

 ELSE IF @HORA >6 AND @HORA <=12
      PRINT 'MANHÃ' 

 ELSE IF @HORA >12 AND @HORA <=18 
      PRINT 'TARDE'

 ELSE IF @HORA >18 AND @HORA <=24
      PRINT 'NOITE'

 ELSE
  PRINT 'HORA INVALIDA'
/* *********************************************** */
Exec P_PERIODO
/* *********************************************** */
CREATE PROCEDURE P_PERIODO2
@HORA INT
AS
 IF @HORA BETWEEN 0 AND 6
      PRINT 'MADRUGADA'

 ELSE IF @HORA BETWEEN 6 AND 12
      PRINT 'MANHÃ' 

 ELSE IF @HORA BETWEEN 12 AND 18 
      PRINT 'TARDE'

 ELSE IF @HORA BETWEEN 18 AND 24
      PRINT 'NOITE'

 ELSE
  PRINT 'HORA INVALIDA'
/* *********************************************** */
EXEC P_PERIODO2 10