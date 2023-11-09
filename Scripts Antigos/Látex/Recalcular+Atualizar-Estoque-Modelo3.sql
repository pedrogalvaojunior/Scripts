SELECT      NUMITEM,
                NUMFICHA,
                EPROQUANTPE,
                EPROQUANTOE,
                EDIVERSASQUANT,
                SPROQUANTPE,
                SPROQUANTOE,               
                SDIVERSASQUANT,
                ESTOQUEATUAL,
                ESTQUANTUP
FROM CUSTO
WHERE NUMFICHA >= 26962
AND       CODPROD= '4300002'
ORDER BY NUMFICHA,  EDATA


CREATE PROCEDURE P_UltimasTresFichas @NUMEROFICHA INT,
                                                       @CODPRODUTO VARCHAR(25)

AS

  SELECT DISTINCT 
           TOP 3 NUMFICHA FROM CUSTO 
  WHERE NUMFICHA < @NUMEROFICHA
  AND     CODPROD =  @CODPRODUTO  ORDER BY NUMFICHA DESC

DROP PROCEDURE P_UltimasTresFichas

EXEC P_ULTIMASTRESFICHAS 27186,'4300002'

