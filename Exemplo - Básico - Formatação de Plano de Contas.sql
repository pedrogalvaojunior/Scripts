DECLARE @tableDados TABLE ( Codigo VARCHAR(100) );

INSERT  INTO @tableDados
        SELECT  '1.0.0.0.0.00.00'
        UNION  ALL
        SELECT  '1.1.0.0.0.00.00'
        UNION ALL
        SELECT  '1.1.1.1.2.00.00'
        UNION ALL
        SELECT  '2.3.7.1.1.01.00'
        UNION ALL
        SELECT  '2.3.2.0.5.00.00';

SELECT  TD.Codigo
FROM    @tableDados AS TD;

SELECT  
    TD.Codigo, 
    LEFT(TD.CODIGO, LEN(TD.CODIGO) - PATINDEX('%[1-9]%', REVERSE(TD.CODIGO)) + 1)
FROM    @tableDados AS TD