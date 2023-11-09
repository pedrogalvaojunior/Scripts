Use MsTechDay
Go

-- PARSE: Retorna um valor convertido com base em uma express�o e um tipo --
SELECT PARSE('2011-09-29' As DATE) As [2011-09-29]
SELECT PARSE('29/09/2011' As DATE) As [Exce��o]

/* TRY_PARSE: Retorna um valor convertido com base em uma express�o e um tipo. 
Em caso de erro de convers�o retorna null.*/
SELECT TRY_PARSE('29/09/2011' As DATE) As [Nulo]
SELECT TRY_PARSE('29/09/2011' As DATE USING 'PT-BR') [2011-09-29]

-- TRY_CONVERT: Similar ao CONVERT e seus estilos, por�m com a �tentativa�. --
SELECT TRY_CONVERT(DATE,'2011/09/29') As [2011-09-29]
SELECT TRY_CONVERT(DATE,'29/09/2011') As [Nulo]
SELECT TRY_CONVERT(CHAR(10),SYSDATETIME(),103) As [29/09/2011]
